//
//  DBServerDriveOderViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBServerDriveOderViewController.h"

@interface DBServerDriveOderViewController ()<UIScrollViewDelegate>

{
    UIScrollView * _orderScrollView ;
    UIButton * _takeTime ;
    UIButton * _returnTime ;
}

@end

@implementation DBServerDriveOderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavgationView];
    
    [self setOrderScrollview];
    
    
}
#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"确认订单" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    
    [self.view addSubview:nav];
    
    
}


#pragma mark ---创建scrollview
//创建scrollview
-(void)setOrderScrollview
{
    
    
    
    
    
    
    _orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight- 64)];
    


    _orderScrollView.delegate = self;
    
    
    _orderScrollView.showsVerticalScrollIndicator = NO;
    _orderScrollView.showsHorizontalScrollIndicator = NO;
    
    
    [self.view addSubview:_orderScrollView];
    
    
    //创建车辆信息页面
    
    [self setCarInfoView];
    
}

#pragma mark ---创建车辆信息页面
-(void)setCarInfoView
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    
    
    //创建车辆图片
    UIImageView * imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(50, 10, 80, 50)];
    imageV.image = [UIImage imageNamed:@"img-05.jpg"];
    [_orderScrollView addSubview:imageV];
    imageV.tag = 801 ;
    
    
    //车辆名称
    UILabel * carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y + 5 , ScreenWidth - CGRectGetMaxX(imageV.frame) , 15)];
    carName.tag = 802;
    
    carName.text = @"";
//    carName.text = self.model.vehicleModelShow.model ;

    
    carName.font = [UIFont systemFontOfSize:13];
    [_orderScrollView addSubview:carName];
    
    
    //车辆类型
    UILabel * carkind = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carName.frame)+5, carName.frame.size.width, 11 )];
    
    
//    NSString * carGroup ;
//    switch ([self.model.vehicleModelShow.carGroup integerValue])
//    {
//            case 1:
//            carGroup = @"经济型";
//            break;
//            case 2:
//            carGroup = @"舒适型";
//            break;
//            case 3:
//            carGroup = @"豪华型";
//            break;
//            case 4:
//            carGroup = @"SUV";
//            break;
//            case 5:
//            carGroup = @"MPV";
//            break;
//            
//        default:
//            break;
//    }
//    
    
    
    
//    carkind.text =[NSString stringWithFormat:@"%@ | %@厢 | %@人",carGroup,self.model.vehicleModelShow.carTrunk,self.model.vehicleModelShow.seats];
//    

    
    
    
    carkind.font = [UIFont systemFontOfSize:11];
    carkind.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [_orderScrollView addSubview:carkind];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(imageV.frame)+10 , ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView];
    
    
    
    
    
    //用车时间
    
    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(lineView.frame)+20, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_orderScrollView addSubview:takeCar];
    
    //获取却车时间
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    NSDate* date = [NSDate date];
    
    NSString * dateString = [user objectForKey:@"takeCarDate"] ;
    
    
    _takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _takeTime.frame =CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20);
    
    [_takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_takeTime setTitle:[dateString substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    //    [_takeTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_orderScrollView addSubview:_takeTime];
    
    
    //星期
    UILabel * week = [[UILabel alloc]initWithFrame:CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(_takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    week.text =[user objectForKey:@"takeWeek"];
    
    week.textAlignment = 1 ;
    week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    week.font = [UIFont systemFontOfSize:12 ];
    [_orderScrollView addSubview:week];
    
    
    //添加选取时间点击事件
    
    //    UIControl * takeDateChontrol = [[UIControl alloc]initWithFrame:CGRectMake(0, self.takeTime.frame.origin.y, ScreenWidth/4, 20)];
    //    [takeDateChontrol addTarget:self action:@selector(setTakeDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:takeDateChontrol];
    
    
    //还车时间
    UILabel * returnCartime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4 - 10 ,takeCar.frame.origin.y, ScreenWidth/4, 10)];
    returnCartime.text = @"还车时间";
    returnCartime.textAlignment = 1 ;
    returnCartime.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCartime.font = [UIFont systemFontOfSize:12 ];
    [_orderScrollView addSubview:returnCartime];
    
    //时间
    
    _returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _returnTime.frame =CGRectMake
    (returnCartime.frame.origin.x ,_takeTime.frame.origin.y, ScreenWidth/4  , 20);
    _returnTime.titleLabel.textAlignment = 1 ;
    
    NSString * returnStr = [user objectForKey:@"returnCarDate"];
    //获取还车时间
    [_returnTime setTitle:[returnStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    [_returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    //    [_returnTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    _returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [_orderScrollView addSubview:_returnTime];
    
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //    星期
    UILabel * returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(returnCartime.frame.origin.x , week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    returnWeek.text =[user objectForKey:@"returnWeek"];
    
    returnWeek.font = [UIFont systemFontOfSize:12];
    returnWeek.textAlignment = 1 ;
    returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_orderScrollView addSubview:returnWeek];
    //
    
    
    //租车天数
    
    //中间图标
    UIImageView * imageView = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 4 + 10, CGRectGetMaxY(_takeTime.frame) -5 -ScreenWidth / 4 * 47 / 136, ScreenWidth / 2 - 20 , (ScreenWidth / 2 - 20) * 47 / 136 )];
    imageView.image = [UIImage imageNamed:@"zcDays"];
    [_orderScrollView addSubview:imageView];
    
    
    //天数结果
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0 , 8, imageView.frame.size.width-2, 20)];
    number.text = @"";
//    number.text =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"daySum"]];
    number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    number.textAlignment =1 ;
    number.font = [UIFont systemFontOfSize:24 ];
    [imageView addSubview:number];
    
    
    UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(number.frame)+5, number.frame.size.width, 10)];
    day.text = @"天";
    day.textAlignment =1 ;
    day.textColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    day.font = [UIFont systemFontOfSize:12 ];
    [imageView addSubview:day];
    
    
    //时间地点分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( lineView.frame.origin.x , CGRectGetMaxY(returnWeek.frame)+20 , lineView.frame.size.width, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView1];
    
    
    
    //取还车
    
    
    [self createPlace:lineView1.frame];
    
}

//创建取车地点
-(void)createPlace:(CGRect)frame
{
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //取车地点
    
    UILabel * takeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+10, CGRectGetMaxY(frame), ScreenWidth/3 - frame.origin.x, 40)];
    takeLabel.text = @"取车地点";
    takeLabel.font = [ UIFont systemFontOfSize:12];
    
    takeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_orderScrollView addSubview:takeLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeLabel addSubview:lineView1];
    
    
    //取车地点
    
    UILabel * takePlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(takeLabel.frame) , takeLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(takeLabel.frame) - 40, takeLabel.frame.size.height)];
    

//    takePlace.text = [[user objectForKey:@"takePlace"]objectForKey:@"name"] ;
    takePlace.text = @"";
    
    takePlace.font = [ UIFont systemFontOfSize:14];
    
    takePlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_orderScrollView addSubview:takePlace];
    
    
    
    
    //地图图标
    
    UIImageView  * mapView = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth - 40, takePlace.frame.origin.y+11.5, 12, 17)];
    
    mapView.image = [UIImage imageNamed:@"mapCenter"];
    //    [_orderScrollView addSubview:mapView];
    
    //取车地点
    //地图点击事件
    UIControl * takeMap =[[UIControl alloc]initWithFrame:CGRectMake(mapView.frame.origin.x - 20, takePlace.frame.origin.y, 42, 40)];
    
//    [takeMap addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    takeMap.tag = 550 ;
    
    [_orderScrollView addSubview:takeMap];
    
    
    
    //取还车分割线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(takeLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView2];
    
    
    
    //**************************还车地点
    
    //还车地点
    
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(takeLabel.frame.origin.x, CGRectGetMaxY(takeLabel.frame), takeLabel.frame.size.width, 40)];
    returnLabel.text = @"还车地点";
    returnLabel.font = [ UIFont systemFontOfSize:12];
    
    returnLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_orderScrollView addSubview:returnLabel];
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( returnLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [returnLabel addSubview:lineView3];
    
    
    //还车地点
    
    UILabel * retuenPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame) , returnLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(returnLabel.frame) - 40, returnLabel.frame.size.height)];
    

//    retuenPlace.text = [[user objectForKey:@"returnPlace"]objectForKey:@"name"] ;

    retuenPlace.text = @"花果山";
    
    
    
    retuenPlace.font = [ UIFont systemFontOfSize:14];
    
    retuenPlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_orderScrollView addSubview:retuenPlace];
    
    
    //取还车分割线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(returnLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView4];
    
    
    //地图图标
    
    UIImageView  * mapView1 = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth - 40, returnLabel.frame.origin.y+11.5, 12, 17)];
    
    mapView1.image = [UIImage imageNamed:@"mapCenter"];
    //    [_orderScrollView addSubview:mapView1];-
    
    
    //取车地点
    //地图点击事件
//    UIControl * returnMap =[[UIControl alloc]initWithFrame:CGRectMake(mapView1.frame.origin.x - 20, returnLabel.frame.origin.y, 42, 40)];
//    
//    [returnMap addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
//    returnMap.tag = 551 ;
//    
//    [_orderScrollView addSubview:returnMap];
    
    
    
    //取还车分割线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView4.frame)+20 , ScreenWidth  , 0.5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView5];
    
    
    
    //创建费用view
    [self setCostViewWithFrame:lineView5.frame];
    
    
    
}
-(void)setCostViewWithFrame:(CGRect)frame
{

    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];

    [_orderScrollView addSubview:mustCost];


    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"费用明细";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];

    [mustCost addSubview:mustCostLabel];




    //车辆费用
    UILabel * carCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(mustCost.frame), ScreenWidth / 3 - 40 , 40)];
    carCostLabel.text = @"包车费用";
    carCostLabel.numberOfLines = 2 ;
    carCostLabel.font = [ UIFont systemFontOfSize:12];

    carCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];

    [_orderScrollView addSubview:carCostLabel];



    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(carCostLabel.frame)+10,CGRectGetMaxY(mustCost.frame) + 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];

    [_orderScrollView addSubview:lineView1];


    //车辆费用
    UILabel * carCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+20 , carCostLabel.frame.origin.y, ScreenWidth / 3 +50, carCostLabel.frame.size.height)];



    carCost.font = [UIFont systemFontOfSize:12];


    [_orderScrollView addSubview:carCost];


//    NSString * averagePrice = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"averagePrice"]];
//
//    NSString *  daySum = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"daySum"]];


    NSString *commissionStr = [NSString stringWithFormat:@"%@元/次,共%@次",@"500",@"1"];
    //
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    //    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, averagePrice.length + daySum.length + 2)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];



    carCost.text = commissionStr;


    //车辆总费用
    UILabel * carCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , carCostLabel.frame.origin.y, ScreenWidth / 3 - 20, carCostLabel.frame.size.height)];

    carCostTotal.textAlignment = 2;


    [_orderScrollView addSubview:carCostTotal];

    NSString * totalAmount = [NSString stringWithFormat:@"%@",@"500"];

    NSMutableAttributedString *carCostTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalAmount]];


    [carCostTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalAmount.length + 2)];

    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalAmount.length + 1)];
    carCostTotal.attributedText = carCostTotalStr;


    //
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(carCostLabel.frame) , ScreenWidth , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];

    [_orderScrollView addSubview:lineView2];




    //基本保险费
    UILabel * premiumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView2.frame), ScreenWidth / 3 - 40 , 40)];
    premiumLabel.text = @"超公里费用";
    premiumLabel.numberOfLines = 2 ;
    premiumLabel.font = [ UIFont systemFontOfSize:12];

    premiumLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];

    [_orderScrollView addSubview:premiumLabel];



    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(premiumLabel.frame)+10,premiumLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];

    [_orderScrollView addSubview:lineView3];


    //保险费用
    UILabel * premiumCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+20 , premiumLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];

    [_orderScrollView addSubview:premiumCost];



    NSString * basicInsuranceAmount =[NSString stringWithFormat:@"%@",@"600"];



    NSString*costPremiumStr = [NSString stringWithFormat:@"%@元",basicInsuranceAmount];

    NSLog(@"%@",costPremiumStr);

    premiumCost.font = [UIFont systemFontOfSize:11];



    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,basicInsuranceAmount.length + daySum.length + 2)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    premiumCost.text = costPremiumStr;


    //保险总费用
    UILabel * premiumCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , premiumLabel.frame.origin.y, ScreenWidth / 3 - 20, premiumLabel.frame.size.height)];

    premiumCostTotal.textAlignment = 2;


    [_orderScrollView addSubview:premiumCostTotal];


    NSString *  totalBasicInsuranceAmount =[NSString stringWithFormat:@"%@",@"600"];

    NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalBasicInsuranceAmount]];
    //

    [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalBasicInsuranceAmount.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalBasicInsuranceAmount.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    premiumCostTotal.attributedText = costPremiumTotalStr;


    //
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(premiumCostTotal.frame) , ScreenWidth , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];

    [_orderScrollView addSubview:lineView4];




    //驾驶员市外食宿费
    UILabel * timeOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(lineView4.frame), ScreenWidth / 3 - 40 , 40)];
    timeOutLabel.text = @"驾驶员市外食宿费";
    timeOutLabel.numberOfLines = 2 ;
    timeOutLabel.font = [ UIFont systemFontOfSize:12];

    timeOutLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [_orderScrollView addSubview:timeOutLabel];




    //
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(timeOutLabel.frame)+10,timeOutLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView5];





    //驾驶员市外食宿费
    UILabel * timeOutCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+20 , timeOutLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];

    [_orderScrollView addSubview:timeOutCost];


    NSString * timeOutprice =[NSString stringWithFormat:@"%@",@"300"];



    NSString* timeOutpriceStr = [NSString stringWithFormat:@"%@元/天,共%@天",timeOutprice,@"2"];

    NSLog(@"%@",costPremiumStr);

    timeOutCost.font = [UIFont systemFontOfSize:11];


    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,basicInsuranceAmount.length + daySum.length + 2)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    timeOutCost.text = timeOutpriceStr;




    //驾驶员市外食宿费
    UILabel * timeOutpriceTotalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , timeOutCost.frame.origin.y, ScreenWidth / 3 - 20, premiumLabel.frame.size.height)];

    timeOutpriceTotalLabel.textAlignment = 2;

    [_orderScrollView addSubview:timeOutpriceTotalLabel];




    NSString *  timeOutpriceTotal =[NSString stringWithFormat:@"%@",@"600"];

    NSMutableAttributedString *timeOutpriceTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",timeOutpriceTotal]];
    //

    [timeOutpriceTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,timeOutpriceTotal.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [timeOutpriceTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [timeOutpriceTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, timeOutpriceTotal.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    timeOutpriceTotalLabel.attributedText = timeOutpriceTotalStr;



    //
    UIView * lineView6 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(timeOutpriceTotalLabel.frame) , ScreenWidth , 0.5)];
    lineView6.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView6];
}



-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
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
