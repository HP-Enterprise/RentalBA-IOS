//
//  DBFourthViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBFourthViewController.h"

//城市选择
#import "DBCityListViewController.h"

#import "DBLongRentInfoViewController.h"

#import "DBChooseDateViewController.h"

#import "DBDatePickViewController.h"

@interface DBFourthViewController ()

{
    NSArray * _brandArray ;
    
    NSArray * _enterpriseArray ;
}
@property (nonatomic,strong)UIView * tipView ;
@property (nonatomic,strong)DBChooseDateViewController * datePicker;

//车型选择控件
@property (nonatomic,strong)DBDatePickViewController * carTypePicker;

//价格选择控件
@property (nonatomic,strong)DBDatePickViewController * carPricePicker;


//筛选的数据
@property (nonatomic,strong)NSMutableDictionary * infoDic ;

////品牌
//@property (nonatomic,strong)NSArray * brandArray ;
//
////车型
//@property (nonatomic,strong)NSArray * enterpriseArray ;

@end

@implementation DBFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建UI
    [self setUI];
    
    //加载数据
    [self loadBrandData];
    
    
}

#pragma mark 创建界面
-(void)setUI
{
    
    
    _infoDic = [NSMutableDictionary dictionary];
    
    

    [_infoDic setObject:@"" forKey:@"takeTime"];
    [_infoDic setObject:@"" forKey:@"rentalTime"];
    [_infoDic setObject:@"" forKey:@"carNumber"];

    
    
    //添加背景图片

    self.view.backgroundColor =[UIColor whiteColor];
    
    UIImageView * imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenWidth*571/777)];
    imageV.image = [UIImage imageNamed:@"截图.jpeg"];
    
    imageV.userInteractionEnabled = YES ;
    [self.view addSubview:imageV];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSafari)];
    
    [imageV addGestureRecognizer:tap];

    
    
    
    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:12];
    
    //定位图片
    UIImageView * cityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,CGRectGetMaxY(imageV.frame) + 15 , 10 , 10 )];
    cityImage.image = [UIImage imageNamed:@"position"];
    [self.view  addSubview:cityImage];
    
    
    
    //展开的小箭头
    
    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , cityImage.frame.origin.y + 3, 7 , 4 )];
    moreImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:moreImage];
    
    
    //取车城市
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 ,  cityImage.frame.origin.y-5 ,four.width + 5, 20 )];
    takeCityLabel.text = @"取车城市";
    takeCityLabel.textAlignment = 1 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:takeCityLabel];
    
    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView];
    
    
    //定位城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 20)];
    cityLabel.text = @"取车城市";
    cityLabel.textAlignment = 0 ;
    cityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:12 ];
    
    [self.view addSubview:cityLabel];
    cityLabel.tag = 601 ;
    
    
    //城市选择点击事件
    UIControl * takeCity = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 5, 20)];
    takeCity.tag = 611 ;
    [takeCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeCity];
    
    cityLabel.userInteractionEnabled = YES;
    
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 5  ,ScreenWidth - 2 * takeCityLabel.frame.origin.x , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView1];
    
    
    //取车时间
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView1.frame)+5 ,four.width + 5, 20 )];
    returnCityLabel.text = @"取车时间";
    returnCityLabel.textAlignment = 1 ;
    returnCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCityLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:returnCityLabel];

    
    
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnCityLabel.frame)+5,  returnCityLabel.frame.origin.y , 0.5 , 20)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView2];
    
    
    
    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    
//    NSString* takeStr = [formatter stringFromDate:[NSDate date]];

    NSString * dateString = [[DBcommonUtils dateWithDays:1] substringWithRange:NSMakeRange(0, 10)] ;
    
    
    //取车时间
    UILabel * placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20)];
    placeLabel.text =[NSString stringWithFormat:@"%@",dateString];
    placeLabel.textAlignment = 0 ;
    placeLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    placeLabel.font = [UIFont systemFontOfSize:12 ];
    placeLabel.adjustsFontSizeToFitWidth = YES ;
    [self.view addSubview:placeLabel];
    placeLabel.tag = 602 ;
    
    [_infoDic setObject:placeLabel.text forKey:@"takeTime"];
    
    //展开的小箭头
    
    UIImageView * timeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , placeLabel.frame.origin.y + 8, 7 , 4 )];
    timeImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:timeImage];

    
    //取车地点选择
    UIControl * takePlace = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, placeLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 5, 20)];
    takePlace.tag = 612 ;
    [takePlace addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePlace];
    
    placeLabel.userInteractionEnabled = YES;
    
    
    
    
    //取还车分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView2.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:carveLine];
    
    
    //租期  用车数量 品牌 车型 等条件筛选
    
    [self createView:carveLine.frame];
    
    
    
    
}

-(void)createView:(CGRect)frame
{
    
    
    CGFloat height = 30 ;
    
    
    //租期选择
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake( 25, CGRectGetMaxY(frame), ScreenWidth / 2  - 25   , height )];
    takeCityLabel.text = @"租期";
    takeCityLabel.textAlignment = 0 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:takeCityLabel];
    takeCityLabel.tag = 603 ;
    

    //横线
    UIView * takeCitylineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,  height - 0.5, ScreenWidth / 2 - 35 , 0.5)];
    takeCitylineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeCityLabel addSubview:takeCitylineView];
    
    
    
    
    //展开的小箭头
    
    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth / 2 -17 , CGRectGetMaxY(frame) + 13 , 7   , 4 )];
    moreImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:moreImage];
    

    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( ScreenWidth/ 2,  CGRectGetMaxY(frame), 0.5 , 2*height)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView];
    

    //租期选择
    UIControl * takeTimeC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeCityLabel.frame.size.width, takeCityLabel.frame.size.height)];
    takeTimeC.tag = 613 ;
    [takeTimeC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [takeCityLabel addSubview:takeTimeC];
    
    takeCityLabel.userInteractionEnabled = YES;
    
    
    
    //用车数量
    UILabel * carNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWidth / 2 + 10 , CGRectGetMaxY(frame), ScreenWidth / 2  - 25   ,height )];
    carNumberLabel.text = @"用车数量";
    carNumberLabel.textAlignment = 0 ;
    carNumberLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    carNumberLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:carNumberLabel];
    carNumberLabel.tag = 604 ;
    
    //横线
    UIView * carNumberlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,  height -0.5, ScreenWidth / 2 - 35 , 0.5)];
    carNumberlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [carNumberLabel addSubview:carNumberlineView];

    
    
    //展开的小箭头
    
    UIImageView * carNumberImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth -27 , moreImage.frame.origin.y , 7   , 4 )];
    carNumberImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:carNumberImage];
    
    


    
    //取车地点选择
    UIControl * carNumberC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, carNumberLabel.frame.size.width, carNumberLabel.frame.size.height)];
    carNumberC.tag = 614 ;
    [carNumberC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [carNumberLabel addSubview:carNumberC];
    
    carNumberLabel.userInteractionEnabled = YES;

    
    
    
//品牌选择
    UILabel * brandLabel = [[UILabel alloc]initWithFrame:CGRectMake( 25, CGRectGetMaxY(takeCityLabel.frame), ScreenWidth / 2  - 25   , height)];
    brandLabel.text = @"品牌";
    brandLabel.textAlignment = 0 ;
    brandLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    brandLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:brandLabel];
    brandLabel.tag = 605 ;
    
    //展开的小箭头
    
    UIImageView * brandImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth / 2 -17 , CGRectGetMaxY(takeCityLabel.frame) + 13 , 7   , 4 )];
    brandImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:brandImage];
    

    
    //租期选择
    UIControl * brandC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeCityLabel.frame.size.width, takeCityLabel.frame.size.height)];
    brandC.tag = 615 ;
    [brandC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [brandLabel addSubview:brandC];
    
    brandLabel.userInteractionEnabled = YES;

    
//车型选择
    UILabel * carkindLabel = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWidth / 2 + 10, CGRectGetMaxY(takeCityLabel.frame), ScreenWidth / 2  - 25   , height )];
    carkindLabel.text = @"车型";
    carkindLabel.textAlignment = 0 ;
    carkindLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    carkindLabel.font = [UIFont systemFontOfSize:12 ];
    [self.view  addSubview:carkindLabel];
    carkindLabel.tag = 606 ;
    
    //展开的小箭头
    
    UIImageView * carkindImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth  -27 , CGRectGetMaxY(takeCityLabel.frame) + 13 , 7   , 4 )];
    carkindImage.image = [UIImage imageNamed:@"more-image"];
    [self.view addSubview:carkindImage];
    
    
    
    //车型选择
    UIControl * carkindC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeCityLabel.frame.size.width, takeCityLabel.frame.size.height)];
    carkindC.tag = 616 ;
    [carkindC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [carkindLabel addSubview:carkindC];
    
    carkindLabel.userInteractionEnabled = YES;
    
    
    //分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(carkindLabel.frame) ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:carveLine];

    
    //选车按钮
    
    UIButton * chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBt.frame = CGRectMake(50, CGRectGetMaxY(carveLine.frame)+50, ScreenWidth-100, 30);
    chooseBt.layer.cornerRadius = 3;
    chooseBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [chooseBt setTitle:@"去申请" forState:UIControlStateNormal];
    [chooseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    [chooseBt addTarget:self action:@selector(chooseBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBt];

    
    
    
    
}
#pragma mark ---加载品牌条件数据
-(void)loadBrandData
{
    
    _brandArray = [NSArray array];

    NSString * url = [NSString stringWithFormat:@"%@/api/vehicle/brand/enterprise",Host];
    
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _brandArray = [responseObject objectForKey:@"message"];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark ---加载车型条件数据
-(void)loadEnterpriseData:(NSInteger)index
{
    
    _enterpriseArray = [NSArray array];

    NSString * brandId = [_brandArray[index]objectForKey:@"id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@/api/vehicle/model/enterprise?brandId=%@",Host,brandId];

    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
      
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _enterpriseArray = [responseObject objectForKey:@"message"];
            
            NSLog(@"%@",_enterpriseArray);
            
   
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark ---筛选条件数据
-(NSArray*)createData:(NSInteger)tag
{
    
    NSArray * retalTime = @[@"90天-120天",@"120天-180天",@"180天-360天",@"360天以上"];
    
    NSMutableArray * carNumber = [NSMutableArray array];

    for (int i = 1; i < 51; i ++)
    {
        [carNumber addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    if (tag == 613)
    {
        return retalTime ;
    }
    else if (tag == 614)
    {
        return carNumber ;
    }

    else if (tag == 615)
    {
        if (_brandArray.count > 0 )
        {
            
            NSMutableArray * array = [NSMutableArray array];
            
            for (NSDictionary * dic in _brandArray)
            {
                [array addObject:[dic objectForKey:@"brand"]];
            }
            
 
            return array ;
        }
    }
    else if (tag == 616)
    {
        
        
        if (_enterpriseArray.count > 0 )
        {
            
            NSMutableArray * array = [NSMutableArray array];
            
            for (NSDictionary * dic in _enterpriseArray)
            {
                
                [array addObject:[dic objectForKey:@"model"]];
            }
            
            
            return array ;
        }
    }

    
    return nil;

    
}

#pragma mark ----选车城市点击事件
-(void)takeCity:(UIControl*)control
{
    
    [self.tipView removeFromSuperview];
    //创建筛选条件
    [self createData:(NSInteger)control.tag];
    
    
    
    
    
    
    DBCityListViewController * cityList = [[DBCityListViewController alloc]init];
    
    //城市选择
    UILabel * takeCity = [self.view viewWithTag:601];

    //时间选择
//    UILabel * takeTime = [self.view viewWithTag:602];

    
    
    switch (control.tag)
    {
        case 611:
        {
            //index 用来标记取车 还车之分
            
            cityList.index = @"take";
            [self.navigationController pushViewController:cityList animated:YES];
            
        }
            break;
        case 612:
        {
            //index 用来标记取车 还车之分
            
      
            [self setTakeDatePickerView:nil withData:nil];
            
        }
            break;

        case 613:
        {

            [self setCityPickerView:control withData:[self createData:control.tag]];
            
        }
            break;

        case 614:
        {

            
            [self setCityPickerView:control withData:[self createData:control.tag]];

            
        }
            break;

        case 615:
        {
            
            [self setCityPickerView:control withData:[self createData:control.tag]];
        }
            break;
            
        case 616:
        {
            
            if (_enterpriseArray.count > 0) {
                [self setCityPickerView:control withData:[self createData:control.tag]];

            }
            else
            {
                [self tipShow:@"该品牌暂无车型"];
            }
            
        }
            break;

            

        default:
            break;
    }
    
    __weak typeof(self)weak_self = self;
    cityList.cityChooseBlock = ^(NSDictionary * city,NSString * index)
    {
        
        
        if ([index isEqualToString:@"take"])
        {
            takeCity.text = [city objectForKey:@"cityName"];
        }

        [weak_self.infoDic setObject:city forKey:@"takeCity"];
        
        weak_self.cityId = [city objectForKey:@"id"];
        weak_self.cityName  = [city objectForKey:@"cityName"];
        
        
    };
    
}



//设置城市选择pickerView
-(void)setCityPickerView:(UIControl*)control withData:(NSArray *)array
{
    
//    [_carTypePicker removeFromParentViewController];
//    [_carTypePicker.view removeFromSuperview];
//    _carTypePicker = nil ;
    
    
    if (_carTypePicker == nil)
    {
        
        
        
        _carTypePicker = [[DBDatePickViewController alloc]init];
        
        
        _carTypePicker.view.frame = CGRectMake(0, ControlHeight, ScreenWidth, 240 * ControlHeight / 667);

           }
    
    [_carTypePicker initWithProData:array withCityData:nil];

    [self addChildViewController:_carTypePicker];
    [self.view addSubview:_carTypePicker.view];
    

    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _datePicker.view.frame ;
        frame = CGRectMake(0, ControlHeight - 250 * ControlHeight / 667, ScreenWidth, 250 * ControlHeight / 667);
        
        _carTypePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    _carTypePicker.pickerView.frame = CGRectMake(0 , 50 * ControlHeight / 667, ScreenWidth, 200 * ControlHeight / 667);

    
    //时间回调
    UILabel * rantalTime = [self.view viewWithTag:603];
    
    UILabel * carNumber = [self.view viewWithTag:604];
    
    UILabel * carBrand = [self.view viewWithTag:605];
    
    UILabel * carEnterprise = [self.view viewWithTag:606];

    
    __weak typeof(_carTypePicker)weak_carTypePicker = _carTypePicker;
    __weak typeof(self)weak_self = self;
    weak_carTypePicker.btBlock = ^(NSString * str,NSInteger index)
    {
        
        
        //租期
        if (control.tag == 613)
        {
            rantalTime.text = str ;
            
            
            [weak_self.infoDic setObject:str forKey:@"rentalTime"];
      
        }
       
        //用车数量
        else if (control.tag == 614)
        {
            carNumber.text = str ;
            [weak_self.infoDic setObject:str forKey:@"carNumber"];
        }
      
        //品牌
        else if (control.tag == 615)
        {
            
            carBrand.text = str ;
            
            [weak_self loadEnterpriseData:index];
            [weak_self.infoDic setObject:_brandArray[index] forKey:@"carBrand"];
            
 
        }
        //车型
        else if (control.tag == 616)
        {
            carEnterprise.text = str ;
             [weak_self.infoDic setObject:_enterpriseArray[index] forKey:@"carEnterprise"];
        }

        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _datePicker.view.frame ;
            frame = CGRectMake(0, ControlHeight , ScreenWidth, 250 * ControlHeight / 667);
            
            weak_carTypePicker.view.frame = frame ;
            
        } completion:^(BOOL finished) {
            [weak_carTypePicker removeFromParentViewController];
            [weak_carTypePicker.view removeFromSuperview];
            
            
        }];

        
        
    };
}


#pragma mark ----选车时间点击事件
//设置取车时间选择pickerView
-(void)setTakeDatePickerView:(UIButton*)button withData:(NSArray *)array
{
    [self.tipView removeFromSuperview];
    
    
//    [_datePicker removeFromParentViewController];
//    [_datePicker.view removeFromSuperview];
//    
//    _datePicker = nil ;
    
    if (_datePicker == nil)
    {
        _datePicker = [[DBChooseDateViewController alloc]init];
        [_datePicker initWithProData:array withCityData:nil];
        _datePicker.view.frame = CGRectMake(0, ControlHeight, ScreenWidth, 240 );

    }
    
    _datePicker.index = 0 ;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _datePicker.view.frame ;
        frame = CGRectMake(0, ControlHeight - 240 , ScreenWidth, 240 );
        
        _datePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
    _datePicker.label.text = @"取车时间";
    
    _datePicker.pickerView.frame = CGRectMake(0 , 40 , ScreenWidth, 200 );
    
    [self addChildViewController:_datePicker];
    [self.view addSubview:_datePicker.view];
    
    
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //    [user setObject:@"" forKey:@"carGroup"];
    
    //时间回调
    
    
    __weak typeof(_datePicker)weak_datePicker = _datePicker;
    __weak typeof(self)weak_self = self ;
    
    
    UILabel * time = [self.view viewWithTag:602];
    
    _datePicker.DateBlock = ^(NSString * str,NSString * hour,NSInteger index)
    {
        [weak_self.tipView removeFromSuperview];
        
        NSLog(@"%@",str);
        NSLog(@"%@",hour);
        
        //存储取车时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        
        if ([DBcommonUtils compareOneDay:dateString withAnotherDay:str] != 1 )
            
        {
//            if ([DBcommonUtils compareOneDay:dateString withAnotherDay:str] == 0 )
//                
//            {
//                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                [formatter setDateFormat:@"yyyyMMddHHmm"];
//                NSDate * date = [NSDate date];
//                NSString *dateString = [formatter stringFromDate:date];
//                NSLog(@"%@",dateString);
            
                //获取当前时间
            
//            NSString * NowYear = [dateString substringWithRange:NSMakeRange(0, 4)];
//            //
//            NSString * chooseYear  = [str substringWithRange:NSMakeRange(0, 4)];
//
//            
//            NSString * NowMonth = [dateString substringWithRange:NSMakeRange(5, 2)];
////
//            NSString * chooseMonth = [str substringWithRange:NSMakeRange(5, 2)];
//            
//            NSString * NowDay = [dateString substringWithRange:NSMakeRange(8, 2)];
//            //
//            NSString * chooseDay = [str substringWithRange:NSMakeRange(8, 2)];
            
//                //获取选择的小时
//                NSInteger chooseHour = [[hour substringWithRange:NSMakeRange(0, 2)]integerValue];
                
                
//                //判断小于2小时不能下单
//                NSLog(@"%ld",chooseHour - [NowHour integerValue]);
//                
//                if (chooseHour - [NowHour integerValue] < 0 )
//                {
//                    
//                    NSLog(@"%ld",chooseHour - [NowHour integerValue]);
//                    
//                    
//                    [weak_self tipShow:@"请选择有效时间"];
//                    
//                    return ;
//                }
                

//            }
            

            
                
            
            
            //有效期
            
            NSInteger userFulDay = 30 ;
            NSString *  userFulDate =   [DBcommonUtils dateWithDays:userFulDay frome:dateString] ;
            
            
            NSLog(@"========%@   %@",userFulDate , dateString);
            NSLog(@"========%d",[DBcommonUtils compareOneDay:str withAnotherDay:userFulDate]);

            if ([DBcommonUtils compareOneDay:str withAnotherDay:userFulDate] == 1 )
                
            {

                [weak_self tipShow:@"请选择有效时间"];

                
            }
            
            else
            {
                
                time.text = [str substringWithRange:NSMakeRange(0, 10)];

                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = weak_datePicker.view.frame ;
                    frame = CGRectMake(0, ControlHeight , ScreenWidth, 240 * ControlHeight / 667);
                    
                    weak_datePicker.view.frame = frame ;
                    
                } completion:^(BOOL finished) {
                    
                    [weak_datePicker removeFromParentViewController];
                    [weak_datePicker.view removeFromSuperview];
                    
                    
                    
                    
                }];

            }
            
            
            
        }
        
        else
        {
            
            [weak_self tipShow:@"请选择有效时间"];
            NSLog(@"输入时间无效");
        }
        
    };
    
    
    
}


- (void)tipShow:(NSString *)str
{
    

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];

    
}


-(void)chooseBt
{
    [self.tipView removeFromSuperview];

    if ([_infoDic objectForKey:@"takeCity"]== nil|| [[_infoDic objectForKey:@"rentalTime"]isEqualToString:@""] ||[[_infoDic objectForKey:@"carNumber"]isEqualToString:@""]||[_infoDic objectForKey:@"carBrand"]== nil||[_infoDic objectForKey:@"carEnterprise"]==nil)
    {
        [self tipShow:@"请完善信息"];
    }
    
    else
    {
        DBLongRentInfoViewController * longRent = [[DBLongRentInfoViewController alloc]init];
        
        longRent.infoDic = self.infoDic ;
        
        [self.navigationController pushViewController:longRent animated:YES];
        
    }
    
}

-(void)goSafari
{
    
    
    
    UIApplication *application = [UIApplication sharedApplication];
    
    [application openURL:[NSURL URLWithString:@"http://www.b-car.cn/Pages/8.jsp"]];
    
    
}

-(void)dealloc
{
    NSLog(@"%@ free",self);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"长租车首页"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"长租车首页"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
