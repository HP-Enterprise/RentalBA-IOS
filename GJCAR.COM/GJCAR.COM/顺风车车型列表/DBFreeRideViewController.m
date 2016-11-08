
//
//  DBFreeRideViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/7.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBFreeRideViewController.h"

#import "DBMyOrderViewController.h"


#import "DBFreeRideDateViewController.h"

#import "DBChooseDateViewController.h"
#import "DBDatePickViewController.h"


#import "DBFreeRideReturnCarStoreShowsModel.h"

#import "DBNewFreeRideModel.h"

#import "DBOrderPayViewController.h"

@interface DBFreeRideViewController ()<UITextFieldDelegate>

{
    DBTextField *nameFiled;
    
    DBTextField *cardNumberFiled;
    
     NSMutableDictionary * userInfoDic ;
    
    UIView * temporaryView ;
}
@property (nonatomic,strong)UIScrollView * scrollView ;

@property (nonatomic,strong)UIView * tipView;

//@property (nonatomic,strong)DBChooseDateViewController * datePicker;


@property (nonatomic,strong)DBFreeRideDateViewController * datePicker;


//价格选择控件
@property (nonatomic,strong)DBDatePickViewController * carTypePicker;

@property (nonatomic,strong)NSMutableDictionary * infoDic ;

@property (nonatomic,strong)DBNewFreeRideModel * newmodel;

@property (nonatomic,strong)NSString * takeStart;
@property (nonatomic,strong)NSString * takeEnd ;
@property (nonatomic)NSInteger  returnStoreId ;

@property (nonatomic,strong)NSMutableArray * returnStoreArray ;

@property (nonatomic,strong)DBProgressAnimation * progress ;
@end

@implementation DBFreeRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavgationView];
    

    
    [self loadData];
    
}



#pragma mark 加载动画
-(void)addProgress
{
    _progress = [[DBProgressAnimation alloc]init];
    [_progress addProgressAnimationWithViewControl:self];
    
    
}

-(void)removeProgress
{
    if (_progress != nil)
    {
        [_progress removeProgressAnimation];
    }
}



#pragma mark 加载个人信息
-(void)loadUserInfo
{
    
    userInfoDic  = [NSMutableDictionary dictionary];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me",Host];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            userInfoDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"message"]];

            [self performSelectorOnMainThread:@selector(setScrollView) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            
            [self tipShow:@"登录信息有误"];
            
        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
}

-(void)loadData
{
    
    _returnStoreArray = [NSMutableArray array];
    NSString * url = [NSString stringWithFormat:@"%@/api/freeRide/%@",Host,self.model.id];
    
//    [self addProgress];
    
    
    //http://www.feeling.hpecar.com/api/freeRide?currentPage=1&getCarCityId=1&pageSize=5&returnCarCityId=3&status=1
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
//        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
//             NSArray * array =[[responseObject objectForKey:@"message"]objectForKey:@"returnCarStoreShows"];
            
            _newmodel = [[DBNewFreeRideModel alloc]initWithDictionary:[responseObject objectForKey:@"message"] error:nil];
            

            [self loadUserInfo];
//            [self performSelectorOnMainThread:@selector(loadUserInfo) withObject:nil waitUntilDone:YES];
         
          
        }

        else
        {
            [self tipShow:@"没有相关数据"];
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        NSLog(@"%@",error);
        
//        [self removeProgress];
        
    }];

}


#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"顺风车预定" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    
    [self.view addSubview:nav];
    
    
}

#pragma mark ---创建Scrollview
-(void)setScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 )];
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 60);
    _scrollView.showsHorizontalScrollIndicator = NO ;
    _scrollView.showsVerticalScrollIndicator = NO ;
    
    
    [self.view addSubview:_scrollView];
    

    
    [self setCarInfoView];
    
    
}




#pragma mark ---创建车型信息
-(void)setCarInfoView
{
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth,150)];
    baseView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:baseView];
    
    
    
    //车辆图片
    UIImageView * carImageV  = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 60)];

    carImageV.image = [UIImage imageNamed:@"img-05.jpg"];
    [baseView addSubview:carImageV];
    
    
    //城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carImageV.frame)+20, 0, ScreenWidth - CGRectGetMaxX(carImageV.frame) - 10, 30)];
    
    cityLabel.font = [UIFont systemFontOfSize:16];

    cityLabel.text = [NSString stringWithFormat:@"%@ - %@",_newmodel.takeCarCityShow.cityName,_newmodel.returnCarCityShow.cityName];
    
    
    [baseView addSubview:cityLabel];
    
    //车辆名
    UILabel * NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x, CGRectGetMaxY(cityLabel.frame), ScreenWidth - CGRectGetMaxX(carImageV.frame) - 10, 20)];
    
    NameLabel.font = [UIFont systemFontOfSize:12];

    NameLabel.text = [NSString stringWithFormat:@"%@",_newmodel.vehicleShow.vehicleModelShow.model];
    
    
    [baseView addSubview:NameLabel];

    
    //横线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( cityLabel.frame.origin.x , CGRectGetMaxY(NameLabel.frame) , ScreenWidth - cityLabel.frame.origin.x, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView];

    
    //里程

    UIImageView * maxMileageImageV = [[UIImageView alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame)+5, 20, 20)];
    maxMileageImageV.image = [UIImage imageNamed:@"maxMileage"];
    [baseView addSubview:maxMileageImageV];
    
    

    UILabel *  maxMileageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(maxMileageImageV.frame)+10, lineView.frame.origin.y, lineView.frame.size.width/2, 30)];
    maxMileageLabel.text = @"限使用里程" ;
    
    maxMileageLabel.font= [UIFont systemFontOfSize:12];
    [baseView addSubview:maxMileageLabel];
    
    UILabel * maxMileage = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(maxMileageLabel.frame) - 20, maxMileageLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(maxMileageLabel.frame)  , 30)];
    maxMileage.text =[NSString stringWithFormat:@"%@km", _newmodel.maxMileage];
    maxMileage.font = [UIFont systemFontOfSize:12];
    maxMileage.textAlignment = 2 ;
    [baseView addSubview:maxMileage];
    
    
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( cityLabel.frame.origin.x , CGRectGetMaxY(maxMileage.frame) , ScreenWidth - cityLabel.frame.origin.x, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];
    
    
    //费用自理
    
    UIImageView * costImageV = [[UIImageView alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x, CGRectGetMaxY(lineView1.frame)+5, 20, 20)];
    costImageV.image = [UIImage imageNamed:@"costType"];
    [baseView addSubview:costImageV];
    
    
    
    UILabel *  costLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(costImageV.frame)+10, lineView1.frame.origin.y, lineView.frame.size.width/2, 30)];
    costLabel.text = @"燃油费路桥费" ;
    
    costLabel.font= [UIFont systemFontOfSize:12];
    [baseView addSubview:costLabel];
    
    UILabel * cost = [[UILabel alloc]initWithFrame:CGRectMake(maxMileage.frame.origin.x, costLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(maxMileageLabel.frame) - 20 , 30)];
    cost.text =[NSString stringWithFormat:@"自理"];
    cost.font = [UIFont systemFontOfSize:12];
    cost.textAlignment = 2 ;
    [baseView addSubview:cost];

    //横线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( cityLabel.frame.origin.x , CGRectGetMaxY(costLabel.frame)-0.5 , ScreenWidth - cityLabel.frame.origin.x, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView2];
    

    
    //价格
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake( cityLabel.frame.origin.x , CGRectGetMaxY(lineView2.frame)+ 10 , ScreenWidth - cityLabel.frame.origin.x, 30)];
    
    NSString * price = _newmodel.price ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",price]];
    //
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,price.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, price.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    priceLabel.attributedText = str;

    
    [baseView addSubview:priceLabel];
    
    
    
    //横线
    UIView * coverlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(priceLabel.frame)-0.5 , ScreenWidth , 0.5)];
    coverlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:coverlineView];

    
    NSLog(@"%f",CGRectGetMaxY(coverlineView.frame));
    
    
    //创建取车城市信息
    [self fullInUserInfo:baseView.frame];
    
}



#pragma mark ---创建信息完善页面
-(void)fullInUserInfo:(CGRect)frame
{
    
    
    
    temporaryView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 120)];
    
    
    //联系人信息
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    
    //    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    //    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    //    [mustCost addSubview:lineView];
    
    [temporaryView addSubview:mustCost];
    
    //联系人信息
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"联系人信息";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    
    //姓名
    
    nameFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mustCost.frame), ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    nameFiled.backgroundColor = [UIColor whiteColor];
    nameFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    nameFiled.field.delegate = self ;
    nameFiled.field.placeholder = @"请输入姓名";
    [nameFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [nameFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    nameFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    
    
    
    UIView * changePwLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
    changePwLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
    [nameFiled addSubview:changePwLine];
    [temporaryView addSubview:nameFiled];
    
    
    
    //证件号码
    
    cardNumberFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameFiled.frame), ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    cardNumberFiled.backgroundColor = [UIColor whiteColor];
    cardNumberFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    cardNumberFiled.field.delegate = self ;
    cardNumberFiled.field.placeholder = @"请输入身份证号码";
    [cardNumberFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [cardNumberFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    cardNumberFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    [temporaryView addSubview:cardNumberFiled];
    
    
    
    
    
    //创建费用view
    
    if ([userInfoDic objectForKey:@"credentialNumber"]==nil || [[userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] || [userInfoDic objectForKey:@"realName"]==nil || [[userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]]|| [[userInfoDic objectForKey:@"realName"]isEqualToString:@""])
    {
        
        [_scrollView addSubview:temporaryView];
        
        _scrollView.contentSize = CGSizeMake(ScreenWidth, _scrollView.contentSize.height + 120 );
        [self setCityInfo:temporaryView.frame];
        
        
    }
    
    else
    {
        [self setCityInfo:frame];
        
    }
    
    
    
}




#pragma mark ----创建取车城市信息
-(void)setCityInfo:(CGRect)frame
{
    _infoDic = [NSMutableDictionary dictionary];
    
    //创建背景
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame)+10, ScreenWidth, 167)];
    
    baseView.backgroundColor = [UIColor whiteColor];
    
    [_scrollView addSubview:baseView];
    
    
    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:14];
    
    //定位图片
    UIImageView * cityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,20 , 10 , 10 )];
    cityImage.image = [UIImage imageNamed:@"position"];
    [baseView addSubview:cityImage];
    
    
    
//    //展开的小箭头
//    
//    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , cityImage.frame.origin.y + 3, 7 , 4 )];
//    moreImage.image = [UIImage imageNamed:@"more-image"];
//    [baseView addSubview:moreImage];
    
    
    //取车城市
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 ,  cityImage.frame.origin.y-5 ,four.width + 5, 20 )];
    takeCityLabel.text = @"取车城市";
    takeCityLabel.textAlignment = 1 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:13 ];
    [baseView  addSubview:takeCityLabel];
    
    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView];
    
    
    //取车城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 20)];
    cityLabel.text = _newmodel.takeCarCityShow.cityName;
    cityLabel.textAlignment = 0 ;
    cityLabel.textColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:13 ];
    
    [baseView addSubview:cityLabel];
    cityLabel.tag = 101 ;
    

    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 10  ,ScreenWidth - 2 * takeCityLabel.frame.origin.x , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];
    
    
    //取车地点
    UILabel * takePlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView1.frame)+10 ,four.width + 5, 20 )];
    takePlaceLabel.text = @"取车门店";
    takePlaceLabel.textAlignment = 1 ;
    takePlaceLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takePlaceLabel.font = [UIFont systemFontOfSize:13 ];
    [baseView  addSubview:takePlaceLabel];
    takePlaceLabel.tag = 105 ;
    
    
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takePlaceLabel.frame)+5,  takePlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView2];
    
    
    //取车地点
    UILabel *  placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, takePlaceLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20)];
    placeLabel.text = _newmodel.takeCarStoreShow.storeName;
    placeLabel.textAlignment = 0 ;
    placeLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    placeLabel.font = [UIFont systemFontOfSize:13 ];
    placeLabel.adjustsFontSizeToFitWidth = YES ;
    [baseView addSubview:placeLabel];


    
    //取还车分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView2.frame) + 10  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine];
    
    
    
    //还车位置图片
    UIImageView * returnCityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 , CGRectGetMaxY(carveLine.frame) + 15 , 10 , 10 )];
    returnCityImage.image = [UIImage imageNamed:@"position-1"];
    [baseView addSubview:returnCityImage];
    
    
    
    
    //取车城市
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnCityImage.frame)+5 ,  CGRectGetMaxY(carveLine.frame)+10 ,four.width + 5, 20 )];
    returnCityLabel.text = @"还车城市";
    returnCityLabel.textAlignment = 1 ;
    returnCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCityLabel.font = [UIFont systemFontOfSize:13 ];
    [baseView  addSubview:returnCityLabel];
    
    
    
    //竖线
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnCityLabel.frame)+5,  returnCityLabel.frame.origin.y , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView3];
    
    
    //定位城市
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView3.frame) - 5  - 50, 20)];
    returnLabel.text = _newmodel.returnCarCityShow.cityName;
    returnLabel.textAlignment = 0 ;
    returnLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnLabel.font = [UIFont systemFontOfSize:13 ];
    
    [baseView addSubview:returnLabel];
    returnLabel.tag = 102 ;
    

    
    //横线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( returnCityLabel.frame.origin.x, CGRectGetMaxY(lineView3.frame) + 10  ,lineView1.frame.size.width, 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView4];
    
    
    //还车地点
    UILabel * returnPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView4.frame)+10 ,four.width + 5, 20 )];
    returnPlaceLabel.text = @"还车门店";
    returnPlaceLabel.textAlignment = 1 ;
    returnPlaceLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnPlaceLabel.font = [UIFont systemFontOfSize:13 ];
    [baseView  addSubview:returnPlaceLabel];
    returnPlaceLabel.tag = 106 ;
    
    
    //展开的小箭头
    
    UIImageView * returnMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -27 ,lineView4.frame.origin.y  +18, 7 , 4 )];
    returnMoreImage.image = [UIImage imageNamed:@"more-image"];
    [baseView addSubview:returnMoreImage];

    
    
    
    //竖线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnPlaceLabel.frame)+5,  returnPlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView5];
    
    
    //还车地点
    UILabel * returnPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+5 , returnPlaceLabel.frame.origin.y,ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20 )];
   
    
    DBFreeRideReturnCarStoreShowsModel * storeModel = _newmodel.returnCarStoreShows[0];
    
    returnPlace.text = storeModel.storeName;
    returnPlace.textAlignment = 0 ;
    returnPlace.textColor = [UIColor blackColor];
    returnPlace.font = [UIFont systemFontOfSize:13 ];
    [baseView  addSubview:returnPlace];
    returnPlace.tag = 104 ;
    returnPlace.userInteractionEnabled = YES;

    
    UIControl * returnC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, returnPlace.frame.size.width, returnPlace.frame.size.height)];
    [returnC addTarget:self action:@selector(setCityPickerView: withData:) forControlEvents:UIControlEventTouchUpInside];
    [returnPlace addSubview:returnC];
    
    
    //    取还车与时间分割线
    
    UIView * carveLine1 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView5.frame) + 10  ,ScreenWidth, 0.5)];
    carveLine1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine1];

    
    NSLog(@"%f",CGRectGetMaxY(carveLine1.frame));
    
    //创建时间View
    [self setUseTime:baseView.frame];
    
}


#pragma mark ----创建时间信息
-(void)setUseTime:(CGRect)frame
{
    
    
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth,100)];
    baseView.backgroundColor = [UIColor whiteColor];
    
    [_scrollView addSubview:baseView];
    
    

    _takeStart = [NSString stringWithFormat:@"%@ 08:00:00",[_newmodel.takeCarDateStart substringWithRange:NSMakeRange(0, 10)]];
    _takeEnd = [NSString stringWithFormat:@"%@ 08:00:00",[DBcommonUtils dateWithDays:[_newmodel.maxRentalDay integerValue] frome:[_newmodel.takeCarDateStart substringWithRange:NSMakeRange(0, 11)]]];
    
    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:13 ];
    [baseView addSubview:takeCar];
    
    //获取却车时间

    UILabel * takeTime = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20)];

    takeTime.textAlignment = 1 ;
    takeTime.font = [UIFont systemFontOfSize:16];
    takeTime.text = [_newmodel.takeCarDateStart substringWithRange:NSMakeRange(5, 5)];
    
    [baseView addSubview:takeTime];
    takeTime.tag = 119 ;

    
    
    
    //星期
    UILabel * week = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    week.text =[NSString stringWithFormat:@"%@ 08:00",[DBcommonUtils weekdayStringFromDate:nil withDateStr:_newmodel.takeCarDateStart]];
    
    week.textAlignment = 1 ;
    week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    week.font = [UIFont systemFontOfSize:12 ];
    [baseView addSubview:week];
    week.tag = 120 ;
    
    
    UIControl * timeC = [[UIControl alloc]initWithFrame:CGRectMake(takeCar.frame.origin.x, takeCar.frame.origin.y, ScreenWidth/4, 40)];
    [baseView addSubview:timeC];
    [timeC addTarget:self action:@selector(setTakeDatePickerView: withData:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    

    //还车时间
    UILabel * returnCartime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4 - 10 ,takeCar.frame.origin.y, ScreenWidth/4, 10)];
    returnCartime.text = @"还车时间";
    returnCartime.textAlignment = 1 ;
    returnCartime.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCartime.font = [UIFont systemFontOfSize:13 ];
    [baseView addSubview:returnCartime];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20 , returnCartime.frame.origin.y - 1, 9, 11)];
    imageView.image = [UIImage imageNamed:@"lock"];
    [baseView addSubview:imageView];
    
    
    
    
    
    
    
    
    
    //时间

    UILabel * returnTime = [[UILabel alloc]initWithFrame:CGRectMake
    (ScreenWidth * 3/4  -10 ,takeTime.frame.origin.y, ScreenWidth/4  , 20)];
    returnTime.textAlignment = 1 ;
    
    NSString * returnStr = [DBcommonUtils dateWithDays:[_newmodel.maxRentalDay integerValue] frome:[_newmodel.takeCarDateStart substringWithRange:NSMakeRange(0, 11)]];

    
    returnTime.text = [returnStr substringWithRange:NSMakeRange(5, 5)];
    returnTime.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];

    returnTime.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:returnTime];
    returnTime.tag = 121 ;

    
    //    星期
    UILabel * returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4 - 10, week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    returnWeek.text =[NSString stringWithFormat:@"%@ 08:00",[DBcommonUtils weekdayStringFromDate:nil withDateStr:_newmodel.takeCarDateEnd]];
    

    returnWeek.font = [UIFont systemFontOfSize:12];
    returnWeek.textAlignment = 1 ;
    returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [baseView addSubview:returnWeek];

    returnWeek.tag = 122 ;
    
    
    NSLog(@"%f",CGRectGetMaxY(returnWeek.frame));
    
    //中间图标
    UIImageView * imageV = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 60, CGRectGetMaxY(takeTime.frame) -takeTime.frame.size.height/2 - 11,120 , 22 )];
    
    imageV.image = [UIImage imageNamed:@"tailwindDays"];
    [baseView addSubview:imageV];
    

    
    
    //天数结果
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 0 , imageV.frame.size.width , 22)];
    number.text =[NSString stringWithFormat:@"限租%@天",_newmodel.maxRentalDay];
    number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    number.textAlignment =1 ;
    number.font = [UIFont systemFontOfSize:10 ];
    [imageV addSubview:number];

    
    
    
    UILabel * secionDate = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(returnWeek.frame)+10, ScreenWidth, 20)];
    secionDate.font= [UIFont systemFontOfSize:12];
    secionDate.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];

    secionDate.text =[NSString stringWithFormat:@"取车区间:%@ 至 %@",[_newmodel.takeCarDateStart substringWithRange:NSMakeRange(0, 16)],[_newmodel.takeCarDateEnd substringWithRange:NSMakeRange(0, 16)]];
    [baseView addSubview:secionDate];

    
 

    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(returnWeek.frame) + 39.5  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine];

    
    
    
    
    
    UIButton * showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(50, CGRectGetMaxY(baseView.frame)+20 , ScreenWidth - 100  , 30 );
    [showCarBt setTitle:@"立即预定" forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [showCarBt addTarget:self action:@selector(sumbitBt) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:showCarBt];

    
    
       

}

#pragma mark 点击事件


-(void)setCityPickerView:(UIControl*)control withData:(NSArray *)array
{
    NSMutableArray * store = [NSMutableArray array];
    

    
    for (DBFreeRideReturnCarStoreShowsModel * storeModel in _newmodel.returnCarStoreShows)
    {
        [store addObject:storeModel.storeName];
    }
    

    [_carTypePicker removeFromParentViewController];
    [_carTypePicker.view removeFromSuperview];
    _carTypePicker = nil ;
    
    
    if (_carTypePicker == nil)
    {
        _carTypePicker = [[DBDatePickViewController alloc]init];
        [_carTypePicker initWithProData:store withCityData:nil];
    }
    
    
    _carTypePicker.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240 * ScreenHeight / 667);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _datePicker.view.frame ;
        frame = CGRectMake(0, ScreenHeight - 250 * ScreenHeight / 667, ScreenWidth, 250 * ScreenHeight / 667);
        
        _carTypePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    _carTypePicker.pickerView.frame = CGRectMake(0 , 50 * ScreenHeight / 667, ScreenWidth, 200 * ScreenHeight / 667);
    
    
    
    [self addChildViewController:_carTypePicker];
    [self.view addSubview:_carTypePicker.view];
    
    
    //门店
    UILabel * rantalTime = [self.view viewWithTag:104];
    

    __weak typeof(_carTypePicker)weak_carTypePicker = _carTypePicker;
    
//    __weak typeof(self)weak_self= self;

    
    __weak typeof(self)weak_self = self;
    weak_carTypePicker.btBlock = ^(NSString * str,NSInteger index)
    {
        
        
        rantalTime.text = str ;
        
        weak_self.returnStoreId = index;
        
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _datePicker.view.frame ;
            frame = CGRectMake(0, ScreenHeight , ScreenWidth, 250 * ScreenHeight / 667);
            
            weak_carTypePicker.view.frame = frame ;
            
        } completion:^(BOOL finished) {
            [weak_carTypePicker removeFromParentViewController];
            [weak_carTypePicker.view removeFromSuperview];
            
            
        }];
        
        
        
    };
}



#pragma mark ----选车时间点击事件
//设置取车时间选择pickerView
-(void)setTakeDatePickerView:(UIButton*)button withData:(DBFreeRideModel *)model
{
    
    
    
    [_datePicker removeFromParentViewController];
    [_datePicker.view removeFromSuperview];
    
    _datePicker = nil ;
    
    if (_datePicker == nil)
    {
        _datePicker = [[DBFreeRideDateViewController alloc]init];
        [_datePicker initWithProData:self.model withCityData:nil];
    }
    
    _datePicker.index = 0 ;
    
    _datePicker.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240 * ScreenHeight / 667);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _datePicker.view.frame ;
        frame = CGRectMake(0, ScreenHeight - 240 * ScreenHeight / 667, ScreenWidth, 240 * ScreenHeight / 667);
        
        _datePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    _datePicker.label.text = @"取车时间";
    
    _datePicker.pickerView.frame = CGRectMake(0 , 40 * ScreenHeight / 667, ScreenWidth, 200 * ScreenHeight / 667);
    
    [self addChildViewController:_datePicker];
    [self.view addSubview:_datePicker.view];
    
    
    //    [user setObject:@"" forKey:@"carGroup"];
    
    //时间回调
    
    
    __weak typeof(_datePicker)weak_datePicker = _datePicker;
    __weak typeof(self)weak_self = self ;
    _datePicker.freeRidedateBlock = ^(NSString * str,NSString * hour)
    {
        
        [weak_self.tipView removeFromSuperview];
        NSLog(@"%@",str);
        NSLog(@"%@",hour);
        
        //存储取车时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString =  [str substringWithRange:NSMakeRange(0, 10)];

        
        

        NSString* taketimeStr =[NSString stringWithFormat:@"%@",str];
            NSLog(@"taketimeStr:%@",taketimeStr);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        
        
        
        [weak_self checkDateWithDate:str withHour:hour];
        
//        //判断选择时间是否正确
//        
//        if ([DBcommonUtils compareOneDay:[weak_self.model.takeCarDateStart substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 1)
//        {
//
//            [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//            return ;
//
//        }
//        
//        
//        else
//        {
//            //当日期相同
//            if ([DBcommonUtils compareOneDay:[weak_self.model.takeCarDateStart substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 0)
//            {
//                
// 
//                if ([[weak_self.model.takeCarDateStart substringWithRange:NSMakeRange(11, 2)]integerValue]>[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
//                {
//                    [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//                    return ;
//
//                }
//                
//                //放小时相同
//                else  if ([[weak_self.model.takeCarDateStart substringWithRange:NSMakeRange(11, 2)]integerValue]==[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
//                {
//                   
//                    if ([[weak_self.model.takeCarDateStart substringWithRange:NSMakeRange(14, 2)]integerValue]>=[[hour substringWithRange:NSMakeRange(3, 2)]integerValue]) {
//                        [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//                        return ;
//                    }
//                    
//                }
//                
// 
//            }
//            
//            
//
//            //判断最迟取车时间
//            if ([DBcommonUtils compareOneDay:dateString withAnotherDay: [weak_self.model.takeCarDateEnd substringWithRange:NSMakeRange(0, 10)]] == 1)
//            {
//                
//                
//
//                [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//                return ;
//                
//            }
//            
//            
//            else
//            {
//                
//                
//                
//                //当日期相同
//                if ([DBcommonUtils compareOneDay:[weak_self.model.takeCarDateEnd substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 0)
//                {
//                    
//                    
//                    
//                    if ([[weak_self.model.takeCarDateEnd substringWithRange:NSMakeRange(11, 2)]integerValue]<[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
//                    {
//                        [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//                        return ;
//                        
//                    }
//                    
//                    //放小时相同
//                    else  if ([[weak_self.model.takeCarDateEnd substringWithRange:NSMakeRange(11, 2)]integerValue]==[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
//                    {
//                        
//                        if ([[weak_self.model.takeCarDateEnd substringWithRange:NSMakeRange(14, 2)]integerValue]<=[[hour substringWithRange:NSMakeRange(3, 2)]integerValue]) {
//                            [weak_self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
//                            return ;
//                        }
//                        
//                    }
//
//                }
//
//            }
//
//        }

        if ([weak_self checkDateWithDate:str withHour:hour])
        {
            
            
            UILabel * takeTime = [weak_self.view viewWithTag:119];
            UILabel * takeWeek = [weak_self.view viewWithTag:120];
            
            UILabel * returnTime = [weak_self.view viewWithTag:121];
            UILabel * returnWeek = [weak_self.view viewWithTag:122];

            takeTime.text = [str substringWithRange:NSMakeRange(5, 5)];
            NSString * week =[str substringWithRange:NSMakeRange(12,2)];

            takeWeek.text = [NSString stringWithFormat:@"%@ %@",week,hour];

            NSString * returnStr = [DBcommonUtils dateWithDays:[weak_self.model.maxRentalDay integerValue]  frome:dateString];

            NSDate * returnDate = [dateFormatter dateFromString:returnStr];
            
            NSString * returnweek = [DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil];
            
            returnTime.text = [returnStr substringWithRange:NSMakeRange(5, 5)];
            returnWeek.text =[NSString stringWithFormat:@"%@ %@",returnweek,hour];

            _takeStart =[NSString stringWithFormat:@"%@ %@:00",dateString ,hour];
            _takeEnd = [NSString stringWithFormat:@"%@ %@:00",returnStr ,hour];
            
            
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = weak_datePicker.view.frame ;
                frame = CGRectMake(0, ScreenHeight , ScreenWidth, 240 * ScreenHeight / 667);
                
                weak_datePicker.view.frame = frame ;
                
            } completion:^(BOOL finished) {
                
                [weak_datePicker removeFromParentViewController];
                [weak_datePicker.view removeFromSuperview];
                
            }];

        }
        
        

    };
}

#pragma mark  提交订单


-(BOOL)checkDateWithDate:(NSString*)date withHour:(NSString *)hour
{
    
    [self.tipView removeFromSuperview];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString =  [date substringWithRange:NSMakeRange(0, 10)];
    

    NSString* taketimeStr =[NSString stringWithFormat:@"%@",date];
    NSLog(@"taketimeStr:%@",taketimeStr);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    //判断选择时间是否正确
    
    if ([DBcommonUtils compareOneDay:[self.model.takeCarDateStart substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 1)
    {
        
        [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
        return NO;
        
    }
    
    
    else
    {
        //当日期相同
        if ([DBcommonUtils compareOneDay:[self.model.takeCarDateStart substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 0)
        {
            
            
            if ([[self.model.takeCarDateStart substringWithRange:NSMakeRange(11, 2)]integerValue]>[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
            {
                [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
                return NO;
                
            }
            
            //放小时相同
            else  if ([[self.model.takeCarDateStart substringWithRange:NSMakeRange(11, 2)]integerValue]==[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
            {
                
                if ([[self.model.takeCarDateStart substringWithRange:NSMakeRange(14, 2)]integerValue]>=[[hour substringWithRange:NSMakeRange(3, 2)]integerValue]) {
                    [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
                   return NO;
                }
                
            }
            
            
        }
        

        //判断最迟取车时间
        if ([DBcommonUtils compareOneDay:dateString withAnotherDay: [self.model.takeCarDateEnd substringWithRange:NSMakeRange(0, 10)]] == 1)
        {
            
            
            
            [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
            return NO;
            
        }
        
        
        else
        {
            
            
            
            //当日期相同
            if ([DBcommonUtils compareOneDay:[self.model.takeCarDateEnd substringWithRange:NSMakeRange(0, 10)] withAnotherDay:dateString] == 0)
            {
                
                
                
                if ([[self.model.takeCarDateEnd substringWithRange:NSMakeRange(11, 2)]integerValue]<[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
                {
                    [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
                    return NO;
                    
                }
                
                //放小时相同
                else  if ([[self.model.takeCarDateEnd substringWithRange:NSMakeRange(11, 2)]integerValue]==[[hour substringWithRange:NSMakeRange(0, 2)]integerValue])
                {
                    
                    if ([[self.model.takeCarDateEnd substringWithRange:NSMakeRange(14, 2)]integerValue]<=[[hour substringWithRange:NSMakeRange(3, 2)]integerValue]) {
                        [self tipShow:@"取车时间不在规定时间范围内,请重新选择!"];
                        return NO;
                    }
                    
                }
                
            }
            
        }
    }
    return YES;
}


#pragma mark  ---提交订单按钮点击
-(void)sumbitBt
{
    
    
    
    
    if (![self checkDateWithDate:[_takeStart substringWithRange:NSMakeRange(0, 10)] withHour:[_takeStart substringWithRange:NSMakeRange(11, 5)]])
    {
        return;
    }
    

    [self.tipView removeFromSuperview];
    
    
    [self addProgress];
    
    if ([userInfoDic objectForKey:@"credentialNumber"]==nil || [[userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] || [userInfoDic objectForKey:@"realName"]==nil || [[userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"realName"]isEqualToString:@""])
    {


        
        [self sumbitUserInfo];
        
    }
    
    else
    {

        [self sumbitOrder];
        
    }
    
    
    
    
    
}


#pragma mark  ---提交身份信息
-(void)sumbitUserInfo
{
    NSString * url =[NSString stringWithFormat:@"%@/api/me",Host];
    //    NSString * url = @"http://www.rental.hpecar.com/api/me";
    
    
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    if (![self validateIdentityCard])
    {
        [self removeProgress];
        
        [self tipShow:@"请输入有效号码"];
        return ;
    }
    else if (![pred evaluateWithObject: nameFiled.field.text])
    {
        
        [self removeProgress];
        
        [self tipShow:@"请输入有效中文名"];
        return;
    }
    
    
    
    [userInfoDic setValue:[NSString stringWithFormat:@"%@",cardNumberFiled.field.text] forKey:@"credentialNumber"];
    
    [userInfoDic setValue:[NSString stringWithFormat:@"%@",nameFiled.field.text] forKey:@"realName"];
    
    
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:userInfoDic];
    
    
    DBNetworkTool *net = [[DBNetworkTool alloc]init];

    
    
    [net changePwdPUT:url parameters:dic];
    
    net.changePwBlock = ^(NSDictionary *dic)
    {
        
        [self removeProgress];
        
        if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            
            
            
            
            [self sumbitOrder];
        }
        else
        {
            [UIView animateWithDuration:2 animations:^{
                
                [self tipShow:@"数据错误"];
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
    };
    
}

//判断证件是否有效
//身份证号
-(BOOL)validateIdentityCard
{
    
    
    //    BOOL flag;
    //    if(nameFiled.field.text.length != 18){
    //        flag =NO;
    //        return flag;
    //    }
    
    NSString * regex2=@"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    
    return [regextestmobile evaluateWithObject:cardNumberFiled.field.text];
    
    
}






-(void)sumbitOrder
{
    
   

    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * url = [NSString stringWithFormat:@"%@/api/user/%@/freeRideOrder",Host,[user objectForKey:@"userId"]];
    
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    
    
    DBFreeRideReturnCarStoreShowsModel * storeModel =_newmodel.returnCarStoreShows[_returnStoreId];
    
    

    
    
    parDic[@"basicInsuranceAmount"] = @"0";
    
    parDic[@"brandId"] = _newmodel.vehicleShow.vehicleModelShow.brandId;
    parDic[@"modelId"] = _newmodel.vehicleShow.modelId;
    parDic[@"orderState"] = @"1";
    parDic[@"orderType"] = @"3";

    parDic[@"payAmount"] = _newmodel.price;
    parDic[@"payWay"] = @"3";
    parDic[@"poundageAmount"] = @"0";
    parDic[@"rentalAmount"] = _newmodel.price;

    [user objectForKey:@"rentalIds"];
    
    
    
    NSArray * array =@[_newmodel.id];
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate* takeStart = [formatter dateFromString:_takeStart];

    NSString *takeStartSp = [NSString stringWithFormat:@"%ld", (long)[takeStart timeIntervalSince1970]*1000];

    
    NSDate* takeEnd = [formatter dateFromString:_takeEnd];
    
    NSString *takeEndSp = [NSString stringWithFormat:@"%ld", (long)[takeEnd timeIntervalSince1970]*1000];
    

    NSLog(@"%@    %@",takeStartSp,takeEndSp);

    
    
    
    

    parDic[@"rentalId"] = array;
    

    parDic[@"returnCarAddress"] = storeModel.storeName;
    parDic[@"returnCarCity"] = _newmodel.returnCarCityShow.id;
   
    parDic[@"returnCarDate"] = takeEndSp;
    parDic[@"returnCarStoreId"] = storeModel.id ;
    parDic[@"serviceType"] = @"0";
    
    parDic[@"takeCarAddress"] = _newmodel.takeCarStoreShow.storeName;
    parDic[@"takeCarCity"] = _newmodel.takeCarCityShow.id;
    
    parDic[@"takeCarDate"] =takeStartSp;
    parDic[@"takeCarStoreId"] = _newmodel.takeCarStoreId;
    parDic[@"tenancyDays"] = _newmodel.maxRentalDay;
    parDic[@"timeoutPrice"] = @"0";
    parDic[@"totalTasicInsuranceAmount"] = @"0";


    parDic[@"totalTimeoutPrice"] = @"0";
    parDic[@"userId"] = [user objectForKey:@"userId"];
    parDic[@"vehicleId"] = _newmodel.vehicleId;
    parDic[@"vendorId"] = @"1";


    

    
    
    
    [DBNetworkTool POST:url parameters:parDic success:^(id responseObject)
    {
        [self removeProgress];
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            [self tipShow:@"提交订单成功"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                DBMyOrderViewController * order = [[DBMyOrderViewController alloc]init];
//                 order.orderIndex = 3 ;
                
                
                DBOrderPayViewController * orderPay = [[DBOrderPayViewController alloc]init];
                
                orderPay.orderIndex = 3;
                orderPay.orderNumber = [responseObject objectForKey:@"message"];
                orderPay.totalCost = _newmodel.price ;
                orderPay.payWay = @"3";
                orderPay.freeRideModel = _newmodel ;
                
                [self.navigationController pushViewController:orderPay animated:YES];
                
                return ;
                
            });

            
        }
       else
       {

           [self tipShow:[responseObject objectForKey:@"message"] ];
       }
    
        NSLog(@"%@",responseObject);
 
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [self removeProgress];
    }];
    

}

- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
}


#pragma mark -----返回按钮点击
-(void)backBt
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"%@ free",self) ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
