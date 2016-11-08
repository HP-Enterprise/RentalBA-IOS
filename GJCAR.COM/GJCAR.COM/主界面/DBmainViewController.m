//
//  DBmainViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/25.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBmainViewController.h"
#import "DBMapViewController.h"
#import "DBChooseDateViewController.h"

//城市列表
#import "DBCityListViewController.h"

//取还车地点
#import "DBChoosePlaceViewController.h"

//门店列表
#import "DBCityStoreViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


#import "DBmainData.h"


//车辆列表
#import "DBCarListViewController.h"

@interface DBmainViewController ()

{
    //记录上一次点击按钮
    UIButton * lastBt;
    
    //取还车范围
    BMKPolygon * polygon;
    
    //判断选择城市是否支持门到门
    BOOL supportDoortodoor;
    
    //定位地址
    UILabel * positionLabel ;
    
}
//@property(nonatomic,strong)UIPageViewController *pageController;


@property (strong, nonatomic) NSArray *pageContent;

@property (nonatomic,strong)DBMapViewController * MapViewC;


@property (nonatomic,strong)UILabel * placeLabel;

//选择的城市名
@property (nonatomic,strong)NSString * takeCityName ;
//选择的城市名
@property (nonatomic,strong)NSString * returnCityName ;


//选择的城市Id
//@property (nonatomic,strong)NSString * takeCityId;

@property (nonatomic,strong)NSString * returnCityId;


//取车时间选择
@property (nonatomic,strong)UIButton * takeTime;

//还车时间选择
@property (nonatomic,strong)UIButton * returnTime;

@property (nonatomic,strong)DBChooseDateViewController * datePicker;

@property (nonatomic,strong)DBManager * sqlManager;

//租车天数
@property (nonatomic)long long days;

//超时小时
@property (nonatomic)NSInteger delayHours;

//取车方式
@property (nonatomic,strong)NSString * takeState ;

@property(nonatomic,strong)UIView * tipView ;



//所有城市
@property (nonatomic,strong)NSArray * cityArray;


//门店加载
@property (nonatomic,strong)NSArray * storeArray;

@property (nonatomic,strong)NSDictionary * takeCityInfoDic ;

@property (nonatomic,strong)NSDictionary * returnCityInfoDic ;


@property (nonatomic,strong)NSDictionary * takePlaceInfoDic ;

@property (nonatomic,strong)NSDictionary * storeDic ;

@property (nonatomic,strong)NSDictionary * takeStoreDic ;

@property (nonatomic,strong)NSDictionary * returnStoreDic ;

//当前位置坐标
@property (nonatomic)CLLocationCoordinate2D coor ;

//搜索范围经纬度
@property (nonatomic,strong)NSArray * serveScopeArray;

@property (nonatomic,strong)DBProgressAnimation * progress;

@end

@implementation DBmainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    //设置地图页面
    [self setMapView];


    //设置导航栏
//    [self setNavigation];

    
    
//    [self createContentPages];
    
    
    
//    [self createView];
    
    
    //创建筛选界面
    [self setSiftView];
    
    //创建个人信息页面
//    [self setUserView];


        //加载城市信息
    [self loadCitys];


    //加载个人信息
//    [self loadInfoData];


    //加载订单信息
    //[self loadOrderData];

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

#pragma mark ******************************加载数据
-(void)loadCitys
{
    
    
    
    if (_cityArray == nil)
    {
        _cityArray = [NSArray array];
        
        _takeCityInfoDic = [NSDictionary dictionary];
        
        _returnCityInfoDic = [NSDictionary dictionary];
        
        _takePlaceInfoDic = [NSDictionary dictionary];
        
        
        
        _takeStoreDic  = [ NSDictionary dictionary];
        
        
        NSString  * url =[NSString stringWithFormat:@"%@/api/china/city",Host];
        
        __weak typeof(self)weak_self = self;
        
        [DBNetworkTool getAllCitysGET:url parameters:nil success:^(id responseObject) {
            
            
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
            {
                weak_self.cityArray = [responseObject objectForKey:@"message"];
                
                if (weak_self.cityArray.count > 0 )
                {
                    
                    if (self.takeCityName !=nil)
                    {
                        
                        [self matchCity:nil];
                        NSLog(@"%@",self.takeCityName);
                        
                    }
                    
                }
                
                else if (weak_self.cityArray.count == 0)
                {
                    
                    
                    NSLog(@"没有数据");
                }
                
                NSLog(@"%@",responseObject);

            }
            
            
        } failure:^(NSError *error) {
            
            weak_self.cityArray = nil ;
        }];
        
        
    }
    
    else
    {
        if (self.takeCityName !=nil)
        {
            
            
            
            [self matchCity:nil];
            NSLog(@"%@",self.takeCityName);
            
        }

    }
    
    
    
    

}


#pragma mark ---家在门店数据
-(void)loadStoreDatawithStr:(NSString*)str;
{
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    NSString * url;
    
    _storeDic = [NSDictionary dictionary];
    
    if ([str isEqualToString:@"take"])
    {
        url = [NSString stringWithFormat:@"%@/api/china/province/city/%@/store?available=1",Host,[NSString stringWithFormat:@"%@",[_takeCityInfoDic objectForKey:@"id"]]];

        
        [self takeStoreWithUrl:url withdStr:str];
        
    }
    else
    {
        url = [NSString stringWithFormat:@"%@/api/china/province/city/%@/store?available=1",Host,self.returnCityId];

        [self returnStoreWithUrl:url withdStr:str];
    }
    
    
}

#pragma mark 加载范围经纬度
-(void)loadSearchPoints:(NSDictionary*)dic
{
    //    http://www.feeling.hpecar.com/api/serviceCity/view?cityId=13
    
    
    
    
    
    _serveScopeArray = [NSArray array];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/serviceCity/view?cityId=%@",Host,[dic objectForKey:@"id"]];
    
    
    [self addProgress];
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
        
        [self removeProgress];
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
            
        {

            _serveScopeArray  = [[responseObject objectForKey:@"message"]objectForKey:@"serveScope"];

            
            [self performSelectorOnMainThread:@selector(setSearchScope:) withObject:_serveScopeArray waitUntilDone:YES];
            
            
        }

    } failure:^(NSError *error) {
        
        
        
        [self removeProgress];
        
        
        NSLog(@"%@",error);
    }];
    
    
}




#pragma mark 加载范围经纬度但不显示
-(void)SearchPoints:(NSDictionary*)dic
{
    //    http://www.feeling.hpecar.com/api/serviceCity/view?cityId=13
    
    
    
    
    
    _serveScopeArray = [NSArray array];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/serviceCity/view?cityId=%@",Host,[dic objectForKey:@"id"]];
    
    
    [self addProgress];
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
        
        [self removeProgress];
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
            
        {
            
            _serveScopeArray  = [[responseObject objectForKey:@"message"]objectForKey:@"serveScope"];
            
            
            
        }
        
    } failure:^(NSError *error) {
        
        
        
        [self removeProgress];
        
        
        NSLog(@"%@",error);
    }];
    
 
}

//取车
-(void)takeStoreWithUrl:(NSString*)url withdStr:(NSString*)str

{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    __weak typeof(self)weak_self = self;
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
        UILabel * takeplace = [self.view viewWithTag:103];
        
//        UILabel * takeWeekTime = [self.view viewWithTag:120];
        
//        UILabel * returnplace = [self.view viewWithTag:104];
        
        
        NSArray * array = [NSArray array];
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"])
        {
            array = [responseObject objectForKey:@"message"];
            
            if (array.count > 0 )
            {
                
                weak_self.storeDic = [array firstObject];
                
                NSMutableDictionary * takedic =[NSMutableDictionary dictionary];
                //            NSMutableDictionary * returndic =[NSMutableDictionary dictionary];
                takedic[@"businessHoursStart"] = [[array firstObject] objectForKey:@"businessHoursStart"];
                takedic[@"businessHoursEnd"] = [[array firstObject] objectForKey:@"businessHoursEnd"];
                takedic[@"latitude"] = [[array firstObject] objectForKey:@"latitude"];
                takedic[@"longitude"] = [[array firstObject] objectForKey:@"longitude"];
                takedic[@"storeAddr"] = [[array firstObject] objectForKey:@"storeAddr"];
                takedic[@"storeName"] = [[array firstObject] objectForKey:@"storeName"];
                takedic[@"id"] = [weak_self.storeDic objectForKey:@"id"];
                
                weak_self.storeDic = takedic ;
                
                weak_self.takeStoreDic = takedic ;
                
                [user setObject:takedic forKey:@"takeStore"];
                //            [user setObject:returndic forKey:@"returnStore"];
                
                [weak_self.MapViewC setStoreAnnotationWith:takedic];
                
                takeplace.text =[weak_self.storeDic objectForKey:@"storeName"];
                //            takeWeekTime.text=[NSString stringWithFormat:@"%@ %@",[takeWeekTime.text substringWithRange:NSMakeRange(0, 2)],[[array firstObject] objectForKey:@"businessHoursStart"]];
                
                if (_returnStoreDic == nil || [_returnStoreDic isKindOfClass:[NSNull class]] || _returnStoreDic.count == 0) {
                    
                    weak_self.returnStoreDic = takedic ;
                }
                
            }
            else{
                weak_self.storeDic = nil ;
                takeplace.text =@"";

            }

        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}



//还车
-(void)returnStoreWithUrl:(NSString*)url withdStr:(NSString*)str

{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    __weak typeof(self)weak_self = self;
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
//        UILabel * takeplace = [self.view viewWithTag:103];
        
        UILabel * returnplace = [self.view viewWithTag:104];
        
        
        NSArray * array = [NSArray array];
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"])
        {
            array = [responseObject objectForKey:@"message"];
            if (array.count > 0 )
            {
                weak_self.storeDic = [array firstObject];
                
                
                //            NSMutableDictionary * takedic =[NSMutableDictionary dictionary];
                NSMutableDictionary * returndic =[NSMutableDictionary dictionary];
                
                
                returndic[@"businessHoursStart"] = [[array firstObject] objectForKey:@"businessHoursStart"];
                returndic[@"businessHoursEnd"] = [[array firstObject] objectForKey:@"businessHoursEnd"];
                returndic[@"latitude"] = [[array firstObject] objectForKey:@"latitude"];
                returndic[@"longitude"] = [[array firstObject] objectForKey:@"longitude"];
                returndic[@"storeAddr"] = [[array firstObject] objectForKey:@"storeAddr"];
                returndic[@"storeName"] = [[array firstObject] objectForKey:@"storeName"];
                returndic[@"id"] = [[array firstObject] objectForKey:@"id"];
                
                
                [user setObject:returndic forKey:@"returnStore"];
                
                
                returnplace.text =[weak_self.storeDic objectForKey:@"storeName"];
                
                
            }

            else{
                weak_self.storeDic = nil ;
                returnplace.text =@"";
                
            }

        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}



#pragma mark ---加载选择城市是否支持门到门
-(void)supportDoortodoor:(NSString*)cityId
{
    
    //http://www.feeling.hpecar.com/api/serviceCity/view?cityId=291
    NSString * url = [NSString stringWithFormat:@"%@api/serviceCity/view?cityId=%@",Host,cityId];
    

    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            supportDoortodoor = YES ;
        }
        else
        {
            supportDoortodoor = NO ;
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark ---匹配所有城市与定位城市


//加载所有城市 并与定位城市匹配  匹配成功则显示 不成功 提示用户



-(void)matchCity:(NSDictionary *)locationDic
{
    UILabel * takeCity = [self.view viewWithTag:101];
    UILabel * returnCity = [self.view viewWithTag:102];

    
    NSUserDefaults * user = [ NSUserDefaults standardUserDefaults];

    [self.tipView removeFromSuperview];
    
    if (self.takeCityName != nil)
    {
        
        
        for (NSDictionary * dic in self.cityArray)
        {
            
           
            NSLog(@"%@",self.takeCityName);

            
            if ([self.takeCityName isEqualToString:[NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]]])
            {
                
                
                 NSLog(@"%@",[NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]]);

                takeCity.text = [dic objectForKey:@"cityName"] ;
                returnCity.text = [dic objectForKey:@"cityName"] ;


                _takeCityInfoDic = dic ;
                _returnCityInfoDic = dic ;
            
                
                
                [user setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] forKey:@"takeCityId"];
                [user setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] forKey:@"returnCityId"];
                
                
                
                self.takeCityName  = [NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]];
                
                
                [self loadStoreDatawithStr:@"take"];
                
                
                self.returnCityId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                self.returnCityName  = [NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]];
                
                
                
                [self loadStoreDatawithStr:@"return"];
                
//测试用... 暂时不加经纬度范围
                
//                static dispatch_once_t onceToken;
//                dispatch_once(&onceToken, ^{
//                    
//                    [self loadSearchPoints:dic];
//                    
//                });

                
                
                return ;
            }
            
        }
        
        [self tipShow:@"当前城市暂无服务"];
        
        takeCity.text = @"请选择城市" ;
        returnCity.text = @"请选择城市";

        NSLog(@"没有相同的城市");

        //                }
    }
    else
    {
        [self tipShow:@"当前城市暂无服务"];
        
        takeCity.text = @"请选择城市" ;
        returnCity.text = @"请选择城市";
    }
}





-(BOOL)judgeCity
{
    

    [self.tipView removeFromSuperview];
    
    if (self.takeCityName != nil)
    {

        for (NSDictionary * dic in self.cityArray)
        {
            
            
            NSLog(@"%@",self.takeCityName);
            
            
            if ([self.takeCityName isEqualToString:[NSString stringWithFormat:@"%@市",[dic objectForKey:@"cityName"]]])
            {
                
                return YES ;

            }
            
        }

    }
    return NO ;

}


#pragma mark ******************************创建界面

#pragma mark ----创建导航栏界面

#pragma mark ----创建城市筛选页面

//创建详情选项
-(void)setSiftView
{


    
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, ControlHeight /2 - 20, ScreenWidth, ControlHeight /2 +20 )];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    header.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] ;
    [baseView addSubview:header];
    

    UIView * header1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, ScreenWidth, 0.5)];
    header1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] ;
//    [baseView addSubview:header1];

    
    //取还车方式 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenWidth, 20)];
    mustCostLabel.text = @"门到门服务";
    mustCostLabel.font = [UIFont systemFontOfSize:12];
    mustCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] ;
    mustCostLabel.tag = 100 ;
//    [baseView addSubview:mustCostLabel];

//    //取还车方式 标题
//    positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenWidth, 20)];
//    positionLabel.text = @"定位失败";
//    positionLabel.font = [UIFont systemFontOfSize:12];
//    positionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] ;
//    [baseView addSubview:positionLabel];
//    

    
    
    //选择开关
    UISwitch * invoiceSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 ,0, 51, 15)];
    
    invoiceSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    invoiceSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
//    [baseView addSubview:invoiceSwitch];
    [invoiceSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
    [invoiceSwitch setOn:YES animated:NO] ;
    
    //送车上门
     self.takeState = @"1" ;

    [user setObject:@"1" forKey:@"takeState"];
    

    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:12];
    
    //定位图片
    UIImageView * cityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,15  , 10 , 10 )];
    cityImage.image = [UIImage imageNamed:@"position"];
    [baseView addSubview:cityImage];

    
    
    //展开的小箭头
    
    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , cityImage.frame.origin.y + 3, 7 , 4 )];
    moreImage.image = [UIImage imageNamed:@"more-image"];
    [baseView addSubview:moreImage];

    
    //取车城市
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 ,  cityImage.frame.origin.y-5 ,four.width + 5, 20 )];
    takeCityLabel.text = @"取车城市";
    takeCityLabel.textAlignment = 1 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:takeCityLabel];
    
    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView];

    
    //定位城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 20)];
    cityLabel.text = @"城市加载中...";
    cityLabel.textAlignment = 0 ;
    cityLabel.textColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:12 ];

    [baseView addSubview:cityLabel];
    cityLabel.tag = 101 ;
    

    //城市选择点击事件
    UIControl * takeCity = [[UIControl alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x, cityLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(takeCityLabel.frame) - 20, cityLabel.frame.size.height)];
    takeCity.tag = 111 ;
    [takeCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:takeCity];
    
    cityLabel.userInteractionEnabled = YES;
    
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 5  ,ScreenWidth - 2 * takeCityLabel.frame.origin.x , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];

    
    //取车地点
    UILabel * takePlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView1.frame)+5 ,four.width + 5, 20 )];
    takePlaceLabel.text = @"取车门店";
    takePlaceLabel.textAlignment = 1 ;
    takePlaceLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takePlaceLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:takePlaceLabel];
    takePlaceLabel.tag = 105 ;
    
    
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takePlaceLabel.frame)+5,  takePlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView2];
    
    
    //取车地点
    _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, takePlaceLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20)];
    _placeLabel.text = @"请输入地址";
    _placeLabel.textAlignment = 0 ;
    _placeLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    _placeLabel.font = [UIFont systemFontOfSize:12 ];
    _placeLabel.adjustsFontSizeToFitWidth = YES ;
    [baseView addSubview:_placeLabel];
    _placeLabel.tag = 103 ;


    
    //取车地点选择
    UIControl * takePlace = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, _placeLabel.frame.size.width, _placeLabel.frame.size.height)];
    takePlace.tag = 113 ;
    [takePlace addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [_placeLabel addSubview:takePlace];
    
    _placeLabel.userInteractionEnabled = YES;

    //取还车分割线

    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView2.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine];

    //还车位置图片
    UIImageView * returnCityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 , CGRectGetMaxY(carveLine.frame) + 10 , 10 , 10 )];
    returnCityImage.image = [UIImage imageNamed:@"position-1"];
    [baseView addSubview:returnCityImage];
    
    
    //展开的小箭头
    
    UIImageView * returnMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -27 ,returnCityImage.frame.origin.y  +3, 7 , 4 )];
    returnMoreImage.image = [UIImage imageNamed:@"more-image"];
//    [baseView addSubview:returnMoreImage];
    
    
    //取车城市
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnCityImage.frame)+5 ,  CGRectGetMaxY(carveLine.frame)+5 ,four.width + 5, 20 )];
    returnCityLabel.text = @"还车城市";
    returnCityLabel.textAlignment = 1 ;
    returnCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCityLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:returnCityLabel];
    
    
    
    //竖线
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnCityLabel.frame)+5,  returnCityLabel.frame.origin.y , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView3];
    
    
    //定位城市
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView3.frame) - 5  - 50, 20)];
    returnLabel.text = @"城市加载中...";
    returnLabel.textAlignment = 0 ;
    returnLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnLabel.font = [UIFont systemFontOfSize:12 ];
    
    [baseView addSubview:returnLabel];
    returnLabel.tag = 102 ;
    
    
    
    
//暂时只支持同城同店
    
    
    //城市选择点击事件
    UIControl * returnCity = [[UIControl alloc]initWithFrame:CGRectMake(returnLabel.frame.origin.x,returnLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(lineView3.frame) - 20, cityLabel.frame.size.height)];
    returnCity.tag = 112 ;
    [returnCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:returnCity];
    
    returnLabel.userInteractionEnabled = YES;
    
    
    //横线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( returnCityLabel.frame.origin.x, CGRectGetMaxY(lineView3.frame) + 5  ,lineView1.frame.size.width, 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView4];
    
    
    //还车地点
    UILabel * returnPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView4.frame)+5 ,four.width + 5, 20 )];
    returnPlaceLabel.text = @"还车门店";
    returnPlaceLabel.textAlignment = 1 ;
    returnPlaceLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnPlaceLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:returnPlaceLabel];
    returnPlaceLabel.tag = 106 ;
    
    
    
    //竖线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnPlaceLabel.frame)+5,  returnPlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView5];

    
    //还车地点
    UILabel * returnPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+5 , returnPlaceLabel.frame.origin.y,ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20 )];
    returnPlace.text = @"请输入地址";
    returnPlace.textAlignment = 0 ;
    returnPlace.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnPlace.font = [UIFont systemFontOfSize:12 ];
    returnPlace.adjustsFontSizeToFitWidth = YES ;
    [baseView  addSubview:returnPlace];
    returnPlace.tag = 104 ;
    
    
    //取车地点选择
    UIControl * returnPlaceC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, returnPlace.frame.size.width, returnPlace.frame.size.height)];
    returnPlaceC.tag = 114 ;
    [returnPlaceC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [returnPlace addSubview:returnPlaceC];
    
    returnPlace.userInteractionEnabled = YES;
    
//    取还车与时间分割线
    
    UIView * carveLine1 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView5.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine1];


    [self setTimeWithBaseView:baseView and:carveLine1.frame];
    

}


#pragma mark ----创建地图页面
-(void)setMapView
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    _MapViewC = [[DBMapViewController alloc]initMapViewWithFrame:CGRectMake(0,0, ScreenWidth, ControlHeight / 2 -20)];
    
    _MapViewC.index = @"main";

    [self addChildViewController:_MapViewC];
    [self.view addSubview:_MapViewC.view];
    
    
//    [_MapViewC searchCity];
    
    
    __weak typeof(self)weak_self = self ;
    
    //定位城市回调
    _MapViewC.cityBlock = ^(NSDictionary* dic)
    {
        
        NSArray* array = [NSArray arrayWithArray:weak_self.MapViewC.mapView.annotations];
        
        
        NSLog(@"清除前地图标注的个数%ld",weak_self.MapViewC.mapView.annotations.count);
        
        
        [weak_self.MapViewC.mapView removeAnnotations:array];


        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
//            
//            //门店显示
//            UILabel * takeStore = [weak_self.view viewWithTag:103];
//            UILabel * returnStore = [weak_self.view viewWithTag:104]  ;
//            
//            
//            UILabel * takeCity = [weak_self.view viewWithTag:101];
//            UILabel * returnCity = [weak_self.view viewWithTag:102];
//            
//            
//            
            weak_self.takeCityName =[dic objectForKey:@"city"] ;
            
            weak_self.returnCityName = [dic objectForKey:@"city"] ;
//
//            
//            [user setObject:[dic objectForKey:@"city"] forKey:@"locationCity"];
//            
//            NSLog(@"%@",[dic objectForKey:@"cityName"]);
//            
//            takeStore.text = [dic objectForKey:@"address"];
//            returnStore.text = [dic objectForKey:@"address"];
//            
//            takeCity.text = [dic objectForKey:@"city"] ;
//            returnCity.text = [dic objectForKey:@"city"] ;
//            
//        
//            
//            //第一次定位得到位置坐标
//            weak_self.coor =  CLLocationCoordinate2DMake([[[dic objectForKey:@"location"]objectForKey:@"latitude"]doubleValue], [[[dic objectForKey:@"location"]objectForKey:@"longitude"]doubleValue]);
//            
//            
            [user setObject:[dic objectForKey:@"city"] forKey:@"locationCity"];

            
            
            [weak_self loadCitys];
//            if (weak_self.cityArray.count > 0 )
//            {
//                
//                [weak_self matchCity:dic];
//            }

            
        });
        
    };

}


#pragma mark ----创建时间筛选页面
-(void)setTimeWithBaseView:(UIView*)baseView and:(CGRect)lineFrame
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineFrame)+10, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [baseView addSubview:takeCar];

    //获取却车时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];


    NSString * dateString = [DBcommonUtils dateWithDays:1] ;

    NSDate * date = [formatter dateFromString:dateString];
    
    _takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _takeTime.frame =CGRectMake(0,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20);

    [_takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_takeTime setTitle:[dateString substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];

    [_takeTime addTarget:self action:@selector(chooseTakeTime:) forControlEvents:UIControlEventTouchUpInside];

    
    _takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
   
    [user setObject:[dateString substringWithRange:NSMakeRange(0, 10)] forKey:@"takeCarDate"];
    
    
    [baseView addSubview:_takeTime];
    
    
    //星期
    UILabel * week = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    week.text =[NSString stringWithFormat:@"%@ 10:00",[DBcommonUtils weekdayStringFromDate:date withDateStr:nil]];
    
    week.textAlignment = 1 ;
    week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    week.font = [UIFont systemFontOfSize:12 ];
    [baseView addSubview:week];
    week.tag = 120 ;
    
    
    [user setObject:@"10:00:00" forKey:@"takeHour"];
    [user setObject:week.text forKey:@"takeWeek"];
    
    //添加选取时间点击事件
    
//    UIControl * takeDateChontrol = [[UIControl alloc]initWithFrame:CGRectMake(0, self.takeTime.frame.origin.y, ScreenWidth/4, 20)];
//    [takeDateChontrol addTarget:self action:@selector(setTakeDatePickerView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:takeDateChontrol];
    
    
    //还车时间
    UILabel * returnCartime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4 ,takeCar.frame.origin.y, ScreenWidth/4, 10)];
    returnCartime.text = @"还车时间";
    returnCartime.textAlignment = 1 ;
    returnCartime.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCartime.font = [UIFont systemFontOfSize:12 ];
    [baseView addSubview:returnCartime];
    
    //时间

    _returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _returnTime.frame =CGRectMake
    (ScreenWidth * 3/4  ,_takeTime.frame.origin.y, ScreenWidth/4  , 20);
    _returnTime.titleLabel.textAlignment = 1 ;
    

    NSDate * returnDate = [formatter dateFromString:[DBcommonUtils dateWithDays:3]];
    
    NSString * returnStr = [DBcommonUtils dateWithDays:3];

    //获取还车时间
    [_returnTime setTitle:[returnStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    [user setObject:[returnStr substringWithRange:NSMakeRange(0, 10)] forKey:@"returnCarDate"];
    
    
     [_returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_returnTime addTarget:self action:@selector(chooseReturnTime:) forControlEvents:UIControlEventTouchUpInside];
    _returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [baseView addSubview:_returnTime];
    
    
    
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    
    

//    星期
    UILabel * returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4, week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    returnWeek.text =[NSString stringWithFormat:@"%@ 10:00",[DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil]];
    
    returnWeek.font = [UIFont systemFontOfSize:12];
    returnWeek.textAlignment = 1 ;
    returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [baseView addSubview:returnWeek];
    returnWeek.tag = 121 ;
    
//
    
    [user setObject:@"10:00:00" forKey:@"returnHour"];
    [user setObject:returnWeek.text forKey:@"returnWeek"];
    //租车天数
    
    //中间图标
    UIImageView * imageV = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 4 + 10, CGRectGetMaxY(_takeTime.frame) -5 -ScreenWidth / 4 * 47 / 136, ScreenWidth / 2 - 20 , (ScreenWidth / 2 - 20) * 47 / 136 )];

    imageV.image = [UIImage imageNamed:@"zcDays"];
    [baseView addSubview:imageV];
    
    
    
    //计算天数
    NSString *taketimeSp = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]*1000];
    
    NSString *returntimeSp = [NSString stringWithFormat:@"%lld", (long long)[returnDate timeIntervalSince1970]*1000];
    
    long long time = [returntimeSp doubleValue] - [taketimeSp doubleValue];
    //
    long long hour = time/ 1000 /60/60 ;
    
    long long days ;
    
    
    
//    NSString *taketimeSp = [NSString stringWithFormat:@"%lld", (long long)[takedate timeIntervalSince1970]*1000];
//    NSString *returntimeSp = [NSString stringWithFormat:@"%lld", (long long)[returndate timeIntervalSince1970] *1000];
//    
//    long long time = (long long)[returndate timeIntervalSince1970]*1000 - (long long)[takedate timeIntervalSince1970] *1000;
//    long long hours = time/ 1000 /60/60 ;
//    
//    long long days ;
//    
//    
//    
//    if (hours % 24 >= 5)
//    {
//        days = hours /24 +1 ;
//        [user setObject:@"0" forKey:@"hours"];
//    }
//    else if (hours % 24 < 5 )
//    {
//        days = hours /24 ;
//        [user setObject:[NSString stringWithFormat:@"%lld",hours % 24] forKey:@"hours"];
//        
//    }
    
    
    
    
    if (hour % 24 >= 5)
    {
        days = hour /24 +1 ;
    }
    else if (hour % 24 < 5 )
    {
        days = hour /24 ;
        
        _delayHours = hour % 24 ;
    }
    
    NSLog(@"%lld",days);
    
    
    _days = days;
    
    
    //天数结果
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0 , 6, imageV.frame.size.width-2, 20)];
    number.text =[NSString stringWithFormat:@"%lld",_days];
    number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    number.textAlignment =1 ;
    number.font = [UIFont systemFontOfSize:24 ];
    [imageV addSubview:number];
    number.tag = 122 ;
    
    
    UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(number.frame)+5, number.frame.size.width, 10)];
    day.text = @"天";
    day.textAlignment =1 ;
    day.textColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    day.font = [UIFont systemFontOfSize:12 ];
    [imageV addSubview:day];
    
    
    
    //显示更多车辆按钮
    UIButton * showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(baseView.frame.size.width / 2 - 100 , CGRectGetMaxY(imageV.frame)+10 , 200  , 30 );
    [showCarBt setTitle:@"立即去选车" forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [showCarBt addTarget:self action:@selector(showCarInfo) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:showCarBt];
    

    
    
    NSString* taketimeStr =[NSString stringWithFormat:@"%@ %@",[user objectForKey:@"takeCarDate"],[user objectForKey:@"takeHour"]];
    //
    //    NSLog(@"taketimeStr:%@",taketimeStr);
    NSString* returntimeStr =[NSString stringWithFormat:@"%@ %@",[user objectForKey:@"returnCarDate"],[user objectForKey:@"returnHour"]];
    

    NSDate* takedate = [formatter dateFromString:taketimeStr];
    NSDate*returndate = [formatter dateFromString:returntimeStr];
    
    
    NSString *takeTime = [NSString stringWithFormat:@"%lld", (long long)[takedate timeIntervalSince1970]*1000];
    NSString *returnTime = [NSString stringWithFormat:@"%lld", (long long)[returndate timeIntervalSince1970]*1000];
    
    NSLog(@"11timeSp:%@",takeTime);
    NSLog(@"22timeSp:%@",returnTime);
    
    
    //储存时间戳
    [user setObject:takeTime forKey:@"takeTime"];
    [user setObject:returnTime forKey:@"returnTime"];
    
    NSNumber * rentalDay = [NSNumber numberWithLongLong:_days];
    
    [user setObject:rentalDay forKey:@"rentalDay"];
    
    
}




#pragma mark ******************************点击事件

#pragma mark ----个人信息点击事件
-(void)UserBt
{
    

    NSLog(@"进入个人信息页面");
}


#pragma mark ----导航栏点击事件
-(void)BtClick:(UIButton * )button
{
    lastBt.backgroundColor = [UIColor whiteColor];
   [lastBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
   
    lastBt = button;
    
    button.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
    switch (button.tag-100) {
        case 1:
        {
            
            NSLog(@"短租自驾点击");
        }
            break;
            
        case 2:
        {
            NSLog(@"短租代驾点击");
        }
            break;
            
        case 3:
        {
            NSLog(@"国内接送机专车");
        }
            
            break;
            
        case 4:
        {
            NSLog(@"近期活动");
        }
            break;
            
            
        default:
            break;
    }

}


#pragma mark ----取还车方式选择
-(void)switchIsOn:(UISwitch*)chooseSwitch
{
    
//    __weak typeof(self)weak_self = self ;
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    UILabel * takepCarKind = [self.view viewWithTag:100];
    

    UILabel * takeLabel = [self.view viewWithTag:105];
    
    UILabel * returnLabel = [self.view viewWithTag:106];
    
    
    UILabel * takeplace = [self.view viewWithTag:103];
    
    UILabel * returnplace = [self.view viewWithTag:104];
  
    UILabel * takeWeekTime = [self.view viewWithTag:120];

   
    
//    城市显示
//    UILabel * takeCityLabel = [self.view viewWithTag:101];
    UILabel * returnCitLabel = [self.view viewWithTag:102]  ;
   
    
    if (chooseSwitch.isOn == NO)
    {
        takeLabel.text = @"取车门店";
        returnLabel.text = @"还车门店";
        takepCarKind.text = @"门店自助取还车服务";
        
        
        [_MapViewC.mapView removeOverlay:polygon];
        

        
        if (self.takeCityName!= nil)
        {
            [self loadStoreDatawithStr:@"take"];
            
            
            self.returnCityName = self.takeCityName ;
            self.returnCityId = [NSString stringWithFormat:@"%@",[_takeCityInfoDic objectForKey:@"id"]] ;
            
            returnCitLabel.text = self.takeCityName;
            


        }
        else
        {
            takeplace.text = @"门店加载中...";

        }
        
        
        if (self.returnCityName != nil)
        {
            
            
            [self loadStoreDatawithStr:@"return"];
        }
        
        else
        {
            returnplace.text = @"门店加载中...";

        }
        
        self.takeState = @"1" ;
        [user setObject:@"1" forKey:@"takeState"];
        
    }
    else
    {
        
        
        [_MapViewC.mapView addOverlay:polygon];

        
//        [UIView animateWithDuration:1 animations:^{
//            [weak_self.MapViewC.mapView setZoomLevel:13];
//            
//        } completion:^(BOOL finished) {
//            
//        }];
        
        takeLabel.text = @"送车地点";
        returnLabel.text = @"取车地点";
        takepCarKind.text = @"门到门服务";
        
        takeplace.text = @"请输入地址" ;
        returnplace.text = @"请输入地址" ;
        self.takeState = @"0" ;

        [user setObject:@"0" forKey:@"takeState"];
        
        
        
        takeWeekTime.text=[NSString stringWithFormat:@"%@ 10:00",[takeWeekTime.text substringWithRange:NSMakeRange(0, 2)]];

        
    }

}

#pragma mark ----选车城市点击事件

//需要储存选择的门店或地址  作为订单提交的选项

-(void)takeCity:(UIControl*)control
{
    

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    [self.tipView removeFromSuperview];
    
    DBCityListViewController * cityList = [[DBCityListViewController alloc]init];
    
    
    DBChoosePlaceViewController * choosePlace = [[DBChoosePlaceViewController alloc]init];
    
    DBCityStoreViewController * store = [[DBCityStoreViewController alloc]init];
    
    
    switch (control.tag)
    {
        case 111:
        {
            
            //index 用来标记取车 还车之分
            cityList.indexKind = 0;
            cityList.index = @"take";
             [self.navigationController pushViewController:cityList animated:YES];
            
        }
            break;
        case 112:
        {
            cityList.indexKind = 0;
            cityList.index = @"return";
             [self.navigationController pushViewController:cityList animated:YES];
        }
            break;
      
        case 113:
        {
            
            // takeState 用来标记门店取车还是送车上门
            
            if (self.takeCityName != nil)
            {
            
                if ([self.takeState isEqualToString:@"0"])
                {
                    
                    choosePlace.index = @"take";
                    if ([[_takeCityInfoDic objectForKey:@"latitude"]isKindOfClass:[NSNull class]])
                    {
                        [self tipShow:@"数据错误"];
                    }
                    else
                    {
                        choosePlace.takeCityInfoDic = _takeCityInfoDic ;
                        if (self.coor.latitude != 0)
                        {
                            choosePlace.coor = self.coor ;

                        }
                        else{
                            choosePlace.coor = CLLocationCoordinate2DMake(0, 0);
                        }

                        [self.navigationController pushViewController:choosePlace animated:YES];

                    }
                    
                }
                else if ([self.takeState isEqualToString:@"1"])
                {
                    store.index = @"take";
                    store.cityName = self.takeCityName ;
                    store.cityId = [NSString stringWithFormat:@"%@",[_takeCityInfoDic objectForKey:@"id"]] ;

                    [self.navigationController pushViewController:store animated:YES];
                    
                }
            }
            else
            {
                [self tipShow:@"请先选择城市"];
            }
            
        }
            break;
        case 114:
        {

            if (self.returnCityName != nil)

            {
                
                
                if ([self.takeState isEqualToString:@"0"])
                {
                    
                    
                    
                    choosePlace.index = @"return";
                    
                    if ([[_returnCityInfoDic objectForKey:@"latitude"]isKindOfClass:[NSNull class]])
                    {
                        [self tipShow:@"数据错误"];
                    }
                    else
                    {
                        choosePlace.takeCityInfoDic = _returnCityInfoDic ;
                        if (self.coor.latitude != 0)
                        {
                            choosePlace.coor = self.coor ;
                            
                        }
                        else{
                            choosePlace.coor = CLLocationCoordinate2DMake(0, 0);
                        }

                        
                        [self.navigationController pushViewController:choosePlace animated:YES];
                        
                    }
                    
                }
                else if ([self.takeState isEqualToString:@"1"])
                {
                    store.index = @"return";
                    store.cityName = self.returnCityName;
                    store.cityId = self.returnCityId;
                    
                    
                    [self.navigationController pushViewController:store animated:YES];
                    
                    
                }
            }
             else
            {
                [self tipShow:@"请先选择城市"];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    //城市显示
    UILabel * takeLabel = [self.view viewWithTag:101];
    UILabel * returnLabel = [self.view viewWithTag:102]  ;
    
    
    //门店显示
    UILabel * takeStore = [self.view viewWithTag:103];
    UILabel * returnStore = [self.view viewWithTag:104]  ;
    
    __weak typeof(self)weak_self = self;
    cityList.cityChooseBlock = ^(NSDictionary * city,NSString * index)
    {
        
        NSLog(@"%@",city);
        
//        [weak_self.MapViewC.mapView removeOverlay:polygon];
        

         //门店
        if ([weak_self.takeState isEqualToString:@"1"])
        {
            
            
            
            if ([index isEqualToString:@"take"])
            {
                
                //城市信息
                weak_self.takeCityInfoDic = city ;
                
                takeLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                returnLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"takeCityId"];
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"returnCityId"];

                

                weak_self.takeCityName  = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                
                
                [self loadStoreDatawithStr:@"take"];


                weak_self.returnCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
                weak_self.returnCityName  = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                
                
              
                [self loadStoreDatawithStr:@"return"];

                
//                [weak_self.MapViewC loactionCitylatitude:[NSString stringWithFormat:@"%@",[city objectForKey:@"latitude"]] withlongitude:[NSString stringWithFormat:@"%@",[city objectForKey:@"longitude"]]];
                
            }
            else if ([index isEqualToString:@"return"])
            {

                returnLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                
                
                weak_self.returnCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
                weak_self.returnCityName  = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];

                weak_self.returnCityInfoDic = city ;
                
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"returnCityId"];
                
                if ([weak_self.takeState isEqualToString:@"1"])
                {
                     [weak_self loadStoreDatawithStr:@"return"];
                }

            }
            
            [weak_self SearchPoints:city];
        
        }
   
        else
        {
            
           

            if ([index isEqualToString:@"take"])
            {
                

                takeStore.text = @"请输入地址" ;
                returnStore.text = @"请输入地址" ;
                
                //城市信息
                weak_self.takeCityInfoDic = city ;
                

                takeLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                returnLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
               
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"takeCityId"];
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"returnCityId"];
                
                
//                weak_self.takeCityId = [city objectForKey:@"id"];
                
                weak_self.takeCityName  =[NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];


                weak_self.returnCityInfoDic = city ;
                weak_self.returnCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
                
                weak_self.returnCityName  = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
 
                
            }
            else if ([index isEqualToString:@"return"])
            {
                returnStore.text = @"请输入地址" ;
                 weak_self.returnCityInfoDic = city ;
                
                returnLabel.text = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];
                
                weak_self.returnCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
               
                weak_self.returnCityName  = [NSString stringWithFormat:@"%@市",[city objectForKey:@"cityName"]];

                
                [user setObject:[NSString stringWithFormat:@"%@",[city objectForKey:@"id"]] forKey:@"returnCityId"];
  
            }
            
            
            [weak_self loadSearchPoints:city];

        }
        
    
    };
    

    store.storeChooseBlock = ^(NSDictionary *store,NSString * index)
    {
        
        
        
        if ([[store objectForKey:@"latitude"]isKindOfClass:[NSNull class]]|| [store objectForKey:@"latitude"] ==nil )
        {
            return ;
        }
        else
        {
            
        
            [weak_self.MapViewC setStoreAnnotationWith:store];

        }
        
        
        
        if ([index isEqualToString:@"take"])
        {

            takeStore.text = [store objectForKey:@"storeName"];
            
            //储存取还车门店

            NSMutableDictionary * takedic =[NSMutableDictionary dictionary];
             NSMutableDictionary * returndic =[NSMutableDictionary dictionary];
            takedic[@"businessHoursStart"] = [store objectForKey:@"businessHoursStart"];
            takedic[@"businessHoursEnd"] = [store objectForKey:@"businessHoursEnd"];

            takedic[@"latitude"] = [store objectForKey:@"latitude"];
            takedic[@"longitude"] = [store objectForKey:@"longitude"];
            takedic[@"storeAddr"] = [store objectForKey:@"storeAddr"];
            takedic[@"storeName"] = [store objectForKey:@"storeName"];
            takedic[@"id"] = [NSString stringWithFormat:@"%@",[store objectForKey:@"id"]];
            [user setObject:takedic forKey:@"takeStore"];
            

            if ([[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[weak_self.takeCityInfoDic objectForKey:@"id"]]] isEqualToString:[NSString stringWithFormat:@"%@",weak_self.returnCityId]])
            {
                
                
                returnStore.text = [store objectForKey:@"storeName"];
                
                returnLabel.text = takeLabel.text;

                returndic[@"businessHoursStart"] = [store objectForKey:@"businessHoursStart"];
                returndic[@"businessHoursEnd"] = [store objectForKey:@"businessHoursEnd"];
                returndic[@"latitude"] = [store objectForKey:@"latitude"];
                returndic[@"longitude"] = [store objectForKey:@"longitude"];
                returndic[@"storeAddr"] = [store objectForKey:@"storeAddr"];
                returndic[@"storeName"] = [store objectForKey:@"storeName"];
                returndic[@"id"] = [NSString stringWithFormat:@"%@",[store objectForKey:@"id"]];
                
                [user setObject:returndic forKey:@"returnStore"];
                
                weak_self.returnStoreDic = returndic ;


            }

            
            weak_self.takeStoreDic = takedic;
            weak_self.storeDic = takedic ;
 

        }
        
        else if ([index isEqualToString:@"return"])
        {
            returnStore.text = [store objectForKey:@"storeName"];
           //储存还车门店

            NSMutableDictionary * returndic =[NSMutableDictionary dictionary];
            
            returndic[@"businessHoursStart"] = [store objectForKey:@"businessHoursStart"];
            returndic[@"businessHoursEnd"] = [store objectForKey:@"businessHoursEnd"];

            returndic[@"latitude"] = [store objectForKey:@"latitude"];
            returndic[@"longitude"] = [store objectForKey:@"longitude"];
            returndic[@"storeAddr"] = [store objectForKey:@"storeAddr"];
            returndic[@"storeName"] = [store objectForKey:@"storeName"];
            returndic[@"id"] = [NSString stringWithFormat:@"%@",[store objectForKey:@"id"]];

           
            
            weak_self.returnStoreDic = returndic ;
            [user setObject:returndic forKey:@"returnStore"];

        }
    };
    
    
    //地点显示

    choosePlace.placeChooseBlock = ^(NSDictionary * place,NSString *index)
    {
        
        
        
        //定位到当前地址
        [weak_self.MapViewC loactionCitylatitude:[NSString stringWithFormat:@"%@",[place objectForKey:@"latitude"]] withlongitude:[NSString stringWithFormat:@"%@",[place objectForKey:@"longitude"]]];
       
        
        
        if ([index isEqualToString:@"take"])
        {
            
            
            weak_self.takePlaceInfoDic = place ;
           
            
            
            weak_self.coor = CLLocationCoordinate2DMake(0, 0);

            
            
            
            //储存取还车地址
            takeStore.text = [place objectForKey:@"name"];
            
            
            
            [user setObject:place forKey:@"takePlace"];
            
            
            //取还车城市相同时改变
            
            if ([[NSString stringWithFormat:@"%@",[_takeCityInfoDic objectForKey:@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",[_returnCityInfoDic objectForKey:@"id"]]])
            {
                
                
                
                returnStore.text = [place objectForKey:@"name"];
                [user setObject:place forKey:@"returnPlace"];
                NSLog(@"@@@@@@@");

            }

           
            
            
            
        }
        
        else if ([index isEqualToString:@"return"])
        {
            
            returnStore.text = [place objectForKey:@"name"];
        
            //储存还车地址
            [user setObject:place forKey:@"returnPlace"];
            
            
        }

    };
    
    
    
}



#pragma mark ----选车时间点击事件

-(void)chooseTakeTime:(UIButton*)button
{
    
    [self.tipView removeFromSuperview];
    
    
    NSMutableArray * chooseTImeArray= [NSMutableArray array];
    
    
    //城市显示
    UILabel * takeLabel = [self.view viewWithTag:101];
    
    if ([takeLabel.text isEqualToString:@"城市加载中..."]|| [takeLabel.text isEqualToString:@"请选择城市"])
    {
        [self tipShow:@"请选择城市"];
        return;
    }
    
    
    if ([_takeState isEqualToString:@"1"] &&  _takeStoreDic != nil && ![_takeStoreDic isKindOfClass:[NSNull class]] && _takeStoreDic.count > 0)
    {
        
        
        
        NSInteger minHour = [[NSString stringWithFormat:@"%@",[[_takeStoreDic objectForKey:@"businessHoursStart"] substringWithRange:NSMakeRange(0, 2)]]integerValue];
        NSInteger maxHour = [[NSString stringWithFormat:@"%@",[[_takeStoreDic objectForKey:@"businessHoursEnd"]substringWithRange:NSMakeRange(0, 2)]]integerValue];
        
        for (NSInteger i = minHour; i <= maxHour; i ++)
        {
            NSString * hour = [NSString stringWithFormat:@"%02ld:00",i];
            [chooseTImeArray addObject:hour];
        }
        
        [self setTakeDatePickerView:button withData:chooseTImeArray];

        
    }
    
    else
    {
  
        [self setTakeDatePickerView:button withData:nil];
    }
 

}


-(void)chooseReturnTime:(UIButton*)button
{
    [self.tipView removeFromSuperview];
    NSMutableArray * chooseTImeArray= [NSMutableArray array];
    
    //城市显示
    UILabel * takeLabel = [self.view viewWithTag:101];

    if ([takeLabel.text isEqualToString:@"城市加载中..."]|| [takeLabel.text isEqualToString:@"请选择城市"])
    {
        [self tipShow:@"请选择城市"];
        return;
    }
    
    
    if (_returnStoreDic != nil && ![_returnStoreDic isKindOfClass:[NSNull class]] && _returnStoreDic.count > 0)
    {
        

        NSInteger minHour = [[NSString stringWithFormat:@"%@",[[_returnStoreDic objectForKey:@"businessHoursStart"] substringWithRange:NSMakeRange(0, 2)]]integerValue];
        NSInteger maxHour = [[NSString stringWithFormat:@"%@",[[_returnStoreDic objectForKey:@"businessHoursEnd"]substringWithRange:NSMakeRange(0, 2)]]integerValue];
        
        for (NSInteger i = minHour; i <= maxHour; i ++)
        {
            NSString * hour = [NSString stringWithFormat:@"%02ld:00",i];
            [chooseTImeArray addObject:hour];
        }
        
        [self setReturnDatePickerView:button withData:chooseTImeArray];
        
    }
    
    else
    {

        [self setReturnDatePickerView:button withData:nil];
    }

}


//设置取车时间选择pickerView
-(void)setTakeDatePickerView:(UIButton*)button withData:(NSArray *)array
{
    
     __weak typeof(self)weak_self = self ;
    
    
//    [_datePicker removeFromParentViewController];
//    [_datePicker.view removeFromSuperview];
//    
//    _datePicker = nil ;
    
    if (_datePicker == nil)
    {
        _datePicker = [[DBChooseDateViewController alloc]init];
        
        
        _datePicker.view.frame = CGRectMake(0, ControlHeight , ScreenWidth, 240);

    }
    
    _datePicker.index = 0 ;
    
    [_datePicker initWithProData:array withCityData:nil];

    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = weak_self.datePicker.view.frame ;
        frame = CGRectMake(0, ControlHeight - 240, ScreenWidth, 240);
        
        weak_self.datePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
    _datePicker.label.text = @"取车时间";
    
    _datePicker.pickerView.frame = CGRectMake(0 , 40 , ScreenWidth, 200 );
    
    [self addChildViewController:_datePicker];
    [self.view addSubview:_datePicker.view];
    
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //    [user setObject:@"" forKey:@"carGroup"];
    
    //时间回调
    
    
    __weak typeof(_datePicker)weak_datePicker = _datePicker;
   
    _datePicker.DateBlock = ^(NSString * str,NSString * hour,NSInteger index)
    {
        
        [weak_self.tipView removeFromSuperview];
        
        NSLog(@"选的时间%@",str);
        NSLog(@"选的小时%@",hour);
        
        //存储取车时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"nowtimeStr:%@",dateString);
        NSLog(@"taketimeStr:%@",str);

        if (index == 1) {
            if ([DBcommonUtils compareOneDay:dateString withAnotherDay:str] != 1 )
                
            {
                
                if ([DBcommonUtils compareOneDay:dateString withAnotherDay:str] == 0 )
                    
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyyMMddHHmm"];
                    NSDate * date = [NSDate date];
                    NSString *dateString = [formatter stringFromDate:date];
                    NSLog(@"%@",dateString);
                    
                    //获取当前时间
                    NSString * NowHour = [dateString substringWithRange:NSMakeRange(8, 2)];
                    
                    //获取选择的小时
                    NSInteger chooseHour = [[hour substringWithRange:NSMakeRange(0, 2)]integerValue];
                    
                    
                    //判断小于2小时不能下单
                    NSLog(@"%ld",chooseHour - [NowHour integerValue]);
                    
                    if (chooseHour - [NowHour integerValue] < 2 )
                    {
                        
                        NSLog(@"%ld",chooseHour - [NowHour integerValue]);
                        
                        
                        [weak_self tipShow:@"请选择有效时间"];
                        
                        return ;
                    }
                    
                    
                }
                
                
                NSString* taketimeStr =[NSString stringWithFormat:@"%@ %@",str,[NSString stringWithFormat:@"%@:00",hour]];
                NSLog(@"taketimeStr:%@",taketimeStr);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                
                NSDate* takedate = [formatter dateFromString:taketimeStr];
                NSDate*nowdate = [NSDate date] ;
                
                
                NSString *taketimeSp = [NSString stringWithFormat:@"%lld", (long long)[takedate timeIntervalSince1970]*1000];
                NSString *nowtimeSp = [NSString stringWithFormat:@"%lld", (long long)[nowdate timeIntervalSince1970]*1000];
                
                
                NSInteger time = [taketimeSp doubleValue] - [nowtimeSp doubleValue];
                NSInteger hours = time/ 1000 /60/60 ;
                
                NSInteger days ;
                
                
                
                if (hours % 24 >= 5)
                {
                    days = hours /24 +1 ;
                    [user setObject:@"0" forKey:@"hours"];
                }
                else if (hours % 24 < 5 )
                {
                    days = hours /24 ;
                    [user setObject:[NSString stringWithFormat:@"%ld",hours % 24] forKey:@"hours"];
                    
                }
                
                
                //取车日期大于当前是88天不能下单
                if (days > 88)
                    
                {
                    [weak_self.tipView removeFromSuperview];
                    
                    [weak_self tipShow:@"取车日期应小于当前88天"];
                    
                    return;
                    
                }
                
                NSLog(@"今天日期%@",dateString);
                NSLog(@"当前日期%@",str);
                
                
                [user setObject:str forKey:@"takeCarDate"];
                
                
                [user setObject:[NSString stringWithFormat:@"%@:00",hour] forKey:@"takeHour"];
                
                
                //取车时间改变
                [weak_self.takeTime setTitle:[str substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
                
                
                //时间 星期改变
                
                UILabel * takeWeek = [weak_self.view viewWithTag:120];
                
                NSString * week =[DBcommonUtils weekdayStringFromDate:takedate withDateStr:nil];
                
                takeWeek.text = [NSString stringWithFormat:@"%@ %@",week,hour];
                
                [user setObject:[NSString stringWithFormat:@"%@ %@",week,hour] forKey:@"takeWeek"];
                
                
                
                if (days == 88)
                {
                    [user setObject:[DBcommonUtils dateWithDays:1 frome:str] forKey:@"returnCarDate"];
                }
                else if(days < 88){
                    
                    [user setObject:[DBcommonUtils dateWithDays:2 frome:str] forKey:@"returnCarDate"];
                }
                
                
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = weak_datePicker.view.frame ;
                    frame = CGRectMake(0, ControlHeight , ScreenWidth, 240);
                    
                    weak_datePicker.view.frame = frame ;
                    
                } completion:^(BOOL finished) {
                    
                    [weak_datePicker removeFromParentViewController];
                    [weak_datePicker.view removeFromSuperview];
                    
                    
                    [weak_self chooseReturnTime:nil];
                    
                }];
                
            }
            
            else
            {
                [weak_self.tipView removeFromSuperview];
                [weak_self tipShow:@"请选择有效时间"];
                NSLog(@"输入时间无效");
            }

        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = weak_datePicker.view.frame ;
                frame = CGRectMake(0, ControlHeight , ScreenWidth, 240);
                
                weak_datePicker.view.frame = frame ;
                
            } completion:^(BOOL finished) {
                
                [weak_datePicker removeFromParentViewController];
                [weak_datePicker.view removeFromSuperview];

                
            }];

        }
        
    };

}




//设置还车时间选择pickerView
-(void)setReturnDatePickerView:(UIButton*)button withData:(NSArray *)array
{
    

    
    if (_datePicker == nil)
    {
        _datePicker = [[DBChooseDateViewController alloc]init];
        _datePicker.view.frame = CGRectMake(0, ControlHeight , ScreenWidth, 240);

    }

    _datePicker.index = 1;
    
    [_datePicker initWithProData:array withCityData:nil];


    __weak typeof(self)weak_self =self ;
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = weak_self.datePicker.view.frame ;
        frame = CGRectMake(0, ControlHeight - 240, ScreenWidth, 240);
        
        weak_self.datePicker.view.frame = frame ;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    _datePicker.label.text = @"还车时间";
    
    [self addChildViewController:_datePicker];
    [self.view addSubview:_datePicker.view];
    

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    //时间回调
 
    __weak typeof(_datePicker)weak_datePicker = _datePicker;
    _datePicker.DateBlock = ^(NSString * str,NSString * newhour,NSInteger index)
    {
        [weak_self.tipView removeFromSuperview];
        
        NSLog(@"taketimeStr:%@",[user objectForKey:@"takeCarDate"]);
        NSLog(@"returntimeStr:%@",str);
        NSString * hour  ;
        
        if (index == 1) {
            hour = newhour ;
        }
        else{
            hour = [newhour substringWithRange:NSMakeRange(0, 5)];
        }
        
        if ([DBcommonUtils compareOneDay:str withAnotherDay:[user objectForKey:@"takeCarDate"]] == 1)
            
        {
            
            NSLog(@"2222222%d",[DBcommonUtils compareOneDay:str withAnotherDay:[user objectForKey:@"takeCarDate"]]);
            
            //计算租车天数
            
            NSString* taketimeStr =[NSString stringWithFormat:@"%@ %@",[user objectForKey:@"takeCarDate"],[user objectForKey:@"takeHour"]];
            
            NSLog(@"taketimeStr:%@",taketimeStr);

            NSString* returntimeStr =[NSString stringWithFormat:@"%@ %@",str,[NSString stringWithFormat:@"%@:00",hour]];
//            NSString* timeStr =[NSString stringWithFormat:@"%@ %@",[user objectForKey:@"returnCarDate"],[user objectForKey:@"treturneHour"]];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            
            NSDate* takedate = [formatter dateFromString:taketimeStr];
            NSDate*returndate = [formatter dateFromString:returntimeStr];
            NSDate*nowdate = [NSDate date] ;
//            NSDate* timedate = [formatter dateFromString:timeStr];

            
            NSString *nowtimeSp = [NSString stringWithFormat:@"%lld", (long long)[nowdate timeIntervalSince1970]*1000];
            NSString *taketimeSp = [NSString stringWithFormat:@"%lld", (long long)[takedate timeIntervalSince1970]*1000];
            NSString *returntimeSp = [NSString stringWithFormat:@"%lld", (long long)[returndate timeIntervalSince1970] *1000];
//            NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[timedate timeIntervalSince1970] *1000];
            
            
            //租车天数
            NSInteger time = [returntimeSp doubleValue] - [taketimeSp doubleValue];
            NSInteger hours = time/ 1000 /60/60 ;
            NSInteger days ;
            
            if (hours % 24 >= 5)
            {
                days = hours /24 +1 ;
                [user setObject:@"0" forKey:@"hours"];
            }
            else if (hours % 24 < 5 )
            {
                days = hours /24 ;
                [user setObject:[NSString stringWithFormat:@"%ld",hours % 24] forKey:@"hours"];
                
            }

            //还车日期不能大于当前日期89天
            NSInteger maxTime = [returntimeSp doubleValue] - [nowtimeSp doubleValue];

       
            NSInteger maxHours = maxTime/ 1000 /60/60 ;
            NSInteger maxDays ;
            
            if (maxHours % 24 >= 5)
            {
                maxDays = maxHours /24 +1 ;
            }
            else if (maxHours % 24 < 5 )
            {
                maxDays = maxHours /24 ;
            }

            if (maxDays > 89)
            {
                [weak_self.tipView removeFromSuperview];
                [weak_self tipShow:@"取车日期应小于当前89天"];
            }
            
            else
            {
                
                //时间 星期改变
                
                UILabel * takeWeek = [weak_self.view viewWithTag:121];
                
                UILabel * dayLabel = [weak_self.view viewWithTag:122];

    
                //储存还车时间
                [user setObject:str forKey:@"returnCarDate"];
                [user setObject:[NSString stringWithFormat:@"%@:00",hour] forKey:@"returnHour"];
                
                //储存时间戳
                [user setObject:taketimeSp forKey:@"takeTime"];
                [user setObject:returntimeSp forKey:@"returnTime"];
                
                
                NSLog(@"%@",[NSString stringWithFormat:@"%@:00",hour]);
                
                //改变日期
                
                [weak_self.returnTime setTitle:[str substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
                
                
                NSString * week =[DBcommonUtils weekdayStringFromDate:returndate withDateStr:nil];
                
                takeWeek.text = [NSString stringWithFormat:@"%@ %@",week,hour];
                
                [user setObject:[NSString stringWithFormat:@"%@ %@",week,hour] forKey:@"returnWeek"];
                
                
                
                dayLabel.text =[NSString stringWithFormat:@"%ld",(long)days] ;
                    

                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = weak_datePicker.view.frame ;
                    frame  = CGRectMake(0, ControlHeight , ScreenWidth, 240);
                    
                    weak_datePicker.view.frame = frame ;
                    
                } completion:^(BOOL finished) {
                    

                    [weak_datePicker removeFromParentViewController];
                    [weak_datePicker.view removeFromSuperview];
                    
                }];
                
                
            }
            
        }
        
        else
        {
            [weak_self.tipView removeFromSuperview];
            
            [weak_self tipShow:@"请选择有效时间"];
            NSLog(@"输入时间无效");
            
            
            
        }
        
    };
    
    
}


#pragma mark ----选车页面点击事件
-(void)showCarInfo
{
    [self.tipView removeFromSuperview];
    
    
    DBCarListViewController * carList = [[DBCarListViewController alloc]init];
    
    carList.takeCityInfoDic = self.takeCityInfoDic ;
    carList.takePlaceInfoDic = self.takePlaceInfoDic ;
    
    carList.storeIndoDic = self.takeStoreDic;
    
    NSLog(@"%@",self.takeCityInfoDic);

    //城市显示
    UILabel * takeLabel = [self.view viewWithTag:101];
//    UILabel * returnLabel = [self.view viewWithTag:102]  ;
    
    //门店显示
    UILabel * takeStore = [self.view viewWithTag:103];
//    UILabel * returnStore = [self.view viewWithTag:104]  ;

    
    if (_cityArray != nil)
    {
        
        
        
        
        if (![self judgeCity])
        {
            [self tipShow:@"当前城市暂无服务"];
            
            return ;
        }

    }
    else
    {
        [self loadCitys];
    }

    
    
    
    if ([takeLabel.text isEqualToString:@"城市加载中..."])
    {
        [self tipShow:@"请选择城市"];
    }
    else if ([takeStore.text isEqualToString:@"请输入地址"])
    {
        [self tipShow:@"请选择地点"];
    }
    else if ([takeStore.text isEqualToString:@""])
    {
        [self tipShow:@"当前城市无服务"];
    }
    
    
    
    
//    else if (![self isInCity:_coor])
//    {
//        
//        [self tipShow:@"当前位置不在服务范围内"];
//
//    }
    
    else
    {
 
        [self.navigationController pushViewController:carList animated:YES];
        
        NSLog(@"进入选车界面");

    }
    
}


-(void)setSearchScope:(NSArray *)array
{

    CLLocationCoordinate2D coords[30] = {0};
    
    if (array.count >= 3)
    {
        for (int i = 0 ; i < _serveScopeArray.count; i ++)
        {
            coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
            coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
            
        }
        
    }
    
    
    
    
    polygon = [BMKPolygon polygonWithCoordinates:coords count:_serveScopeArray.count];
    [_MapViewC.mapView addOverlay:polygon];
    
}


//判断断续地点是否在范围内
-(BOOL)isInCity:(CLLocationCoordinate2D)coor;
{
    
    if ([self.takeState isEqualToString:@"1"])
    {
        return YES;
    }
    else if (coor.latitude == 0)
    {
        return YES;
    }
    

    CLLocationCoordinate2D coords[30] = {0};
    
    if (_serveScopeArray.count >= 3)
    {
        for (int i = 0 ; i < _serveScopeArray.count; i ++)
        {
            
            coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
            coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
            
        }
        
    }
    
    
    
    BOOL isIn =  BMKPolygonContainsCoordinate(CLLocationCoordinate2DMake(coor.latitude, coor.longitude), coords,_serveScopeArray.count );
    
    
    
    
    return isIn;
    
    
}



- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"短租自驾首页"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"短租自驾首页"];
}


-(void)dealloc
{
    NSLog(@"%@ free",self);
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
