//
//  DBOderInfoViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBFreeRideOrderViewController.h"


//支付
#import "Order.h"
//
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


#import "AliayInfo.h"
//@implementation Product
//
//@end



@interface DBFreeRideOrderViewController ()

@property (nonatomic,strong)UIScrollView * scrollView ;

//错误提示
@property (nonatomic,strong)UIView * tipView ;

@property (nonatomic,strong)NSDictionary * OrderDic ;

////下单成功生成订单
//@property(nonatomic,strong)Product *product ;


@end

@implementation DBFreeRideOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavgationView];
    
    
    
    
    //加载订单信息
    [self loadOrderData];
}

-(void)loadOrderData
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSString * url ;
    
    switch (self.orderIndex)
    {
        case 0:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/order/%@",Host,[user objectForKey:@"userId"],_model.orderId];
            
        }
            break;
        case 1:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/doortodoororder/%@",Host,[user objectForKey:@"userId"],_model.orderId];
            
        }
            break;
        case 2:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/doortodoororder/%@",Host,[user objectForKey:@"userId"],_model.orderId];
            
        }
            break;
        case 3:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/freeRideOrder/%@",Host,[user objectForKey:@"userId"],_model.orderId];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    _OrderDic = [NSDictionary dictionary];
    [DBNetworkTool checkOrderGET:url parameters:nil success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
         {
             
             _OrderDic = [responseObject objectForKey:@"message"];
             
             
             [self performSelectorOnMainThread:@selector(screateScrollerView) withObject:nil waitUntilDone:YES];
             
         }
         
         else
         {
             
         }
         
         
     } failure:^(NSError *error) {
         [self tipShow:@"没有数据"];
         
     }];
    
    
}

#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    
    NSString * title ;
    
    switch (self.orderIndex)
    {
        case 0:
            title = @"自驾订单" ;
            break;
        case 1:
            title = @"门到门订单" ;
            break;
            
        case 2:
            title = @"带驾订单" ;
            break;
            
        case 3:
            title = @"顺风车订单" ;
            break;
            
        default:
            break;
    }
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:title withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    
    [self.view addSubview:nav];
   
    


    
}

#pragma mark ---创建背景scrol
-(void)screateScrollerView
{
    
    
    NSArray * severs = [NSArray array];
    if ([[_OrderDic allKeys] containsObject:@"orderValueAddedServiceRelativeShow"])
    {
        
        if (![[_OrderDic objectForKey:@"orderValueAddedServiceRelativeShow"] isKindOfClass:[NSNull class]])
        {
            severs = [NSArray arrayWithArray:[_OrderDic objectForKey:@"orderValueAddedServiceRelativeShow"]];
            
        }
        
    }
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 )];
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight +100 );
        

    _scrollView.showsVerticalScrollIndicator = NO ;
    _scrollView.showsHorizontalScrollIndicator = NO ;
    
    
    [self.view addSubview:_scrollView];
    
    
    //创建订单界面
    [self setCarInfoView:severs];
    
    
    
}


#pragma mark ---创建车辆信息页面
-(void)setCarInfoView:(NSArray*)array
{
    UIView *topView  =[[UIView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 10)];
    
    topView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [_scrollView addSubview:topView ];
    
    
    
    
    //订单状态
    UILabel *  orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(50 , 10, ScreenWidth - 100 , 30)];
    
    
    NSString * status ;
    
    
    switch ([_model.orderState integerValue])
    {
        case 0:
        {
            status = @"订单状态: 待支付";
        }
            break;
        case 1:
        {
            status = @"订单状态: 已下单";
        }
            break;
            
        case 2:
        {
            status = @"订单状态: 租赁中";
        }
            break;
            
        case 3:
        {
            status = @"订单状态: 已还车";
        }
            break;

        case 5:
        {
            status = @"订单状态: 已取消";
        }
            break;
    }

    
    
    orderStatus.text = status;
    
    
    orderStatus.font = [UIFont systemFontOfSize:14];
    orderStatus.textAlignment = 1 ;
    orderStatus.textColor =  [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [_scrollView addSubview:orderStatus];
    
    
    //横线
    UIView * orderStatuslineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(orderStatus.frame)-0.5 , ScreenWidth, 0.5)];
    orderStatuslineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:orderStatuslineView];

    
    
    
    //取车证件
    UILabel * cardNumber = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(orderStatuslineView.frame), ScreenWidth - 20, 30)];
    cardNumber.text = @"取车证件    身份证" ;
    cardNumber.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:cardNumber];
    
    
    //横线
    UIView * cardNumberlineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(cardNumber.frame)-0.5 , ScreenWidth, 0.5)];
    cardNumberlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:cardNumberlineView];
    
    
    //支付金额
    //取车证件
    UILabel * paylabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cardNumber.frame), ScreenWidth - 20, 30)];
//    paylabel.text = [NSString stringWithFormat:@"支付金额    %@",_model.payAmount] ;
    paylabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:paylabel];

    NSString * totalPrice = [NSString stringWithFormat:@"%@",_model.payAmount];
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额    ￥%@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(8,totalPrice.length + 1)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(8,totalPrice.length + 1)];
//    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length+ 1)];
    
    paylabel.attributedText = totleCostStr;

    
    
    
    
    
    
    
    
    //横线
    UIView * paylabellineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(paylabel.frame)-0.5 , ScreenWidth, 0.5)];
   paylabellineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:paylabellineView];

    
    
    
    //付款按钮
    UIButton * payBt = [UIButton buttonWithType:UIButtonTypeCustom];
    payBt.frame = CGRectMake(50, CGRectGetMaxY(paylabel.frame)+10 , ScreenWidth - 100  ,0 );
   
    if ([_model.orderState integerValue]==0)
    {
//        [payBt setTitle:@"确定" forState:UIControlStateNormal];
        
        payBt.frame = CGRectMake(50, CGRectGetMaxY(paylabel.frame)+10 , ScreenWidth - 100  ,30 );
        [payBt setTitle:@"在线支付" forState:UIControlStateNormal];
        [_scrollView addSubview:payBt];
    }

    
    [payBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [payBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    payBt.layer.cornerRadius = 5 ;
    payBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [payBt addTarget:self action:@selector(payBt) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    
    
    //订单信息
    
    UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(payBt.frame)+10, ScreenWidth, 10)];
    
    backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [_scrollView addSubview:backView ];
    
    //横线
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(backView.frame) - 0.5 , ScreenWidth, 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:toplineView];
    
    
    //订单编号
    
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20, CGRectGetMaxY(backView.frame)+10, ScreenWidth / 5 , 30)];
    orderLabel.text = @"订单编号 :" ;
    orderLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:orderLabel];
    
    
    
    //订单号
    
    
    UILabel *  orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderLabel.frame),  orderLabel.frame.origin.y , ScreenWidth - CGRectGetMaxX(orderLabel.frame)  - 50, 30)];
    orderNumber.text =[NSString stringWithFormat:@"%@",_model.orderId]  ;
    orderNumber.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:orderNumber];
    
    
//    //订单状态
//    UILabel *  orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 50 , 10, 50 , 30)];
//    
//    
//    NSString * status ;
//    switch ([_model.orderState integerValue])
//    {
//        case 0:
//        {
//            status = @"待支付";
//        }
//            break;
//        case 1:
//        {
//            status = @"已下单";
//        }
//            break;
//            
//        case 2:
//        {
//            status = @"租赁中";
//        }
//            break;
//            
//        case 3:
//        {
//            status = @"已还车";
//        }
//            break;
//        case 4:
//        {
//            status = @"已完成";
//        }
//            break;
//        case 5:
//        {
//            status = @"已取消";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    orderStatus.text = status;
//    
//    
//    orderStatus.font = [UIFont systemFontOfSize:12];
//    [_scrollView addSubview:orderStatus];
    
    
    //横线
    UIView * orderlineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(orderLabel.frame)-0.5 , ScreenWidth, 0.5)];
    orderlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:orderlineView];
    
    
    
    
    //创建车辆图片
    UIImageView * imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(orderlineView.frame)+10, 80, 50)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:
                                [NSString stringWithFormat:@"%@%@",Host,_model.picture]] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
    [_scrollView addSubview:imageV];
    
    
    
    //车辆名称
    UILabel * carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y + 10 , ScreenWidth - CGRectGetMaxX(imageV.frame) , 15)];
    
    
    carName.text =  _model.model ;
    //    if (_indexControl == 0 )
    //    {
    //        carName.text = [[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carName.text = [[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    
    
    carName.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:carName];
    
    
    //车辆类型
    UILabel * carkind = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carName.frame)+5, carName.frame.size.width, 11 )];
    
    
    
    
    
    
    
    NSString * carGroup ;
    if (_model.carGroupstr == nil)
    {
        carGroup = @"" ;
    }
    else
    {
        carGroup = _model.carGroupstr;
    }
    
    
    NSString * trunk ;
    if (_model.carTrunkStr == nil)
    {
        trunk = @"" ;
    }
    else
    {
        trunk = _model.carTrunkStr ;
    }
    
    NSString * seats ;
    if (_model.seatsStr == nil)
    {
        seats = @"" ;
    }
    else
    {
        seats = _model.seatsStr ;
    }
    
    carkind.text =[NSString stringWithFormat:@"%@ | %@ | %@",carGroup,trunk,seats];
    

    
    //    if (_indexControl == 0 )
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //
    //    }
    
    
    
    carkind.font = [UIFont systemFontOfSize:11];
    carkind.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [_scrollView addSubview:carkind];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(imageV.frame)+10 , ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:lineView];
    
    
    
    
    
    //用车时间
    
    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(lineView.frame)+20, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_scrollView addSubview:takeCar];
    
    //获取却车时间
    
    
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate * takeDate =[NSDate dateWithTimeIntervalSince1970:[_model.takeCarDate doubleValue]/1000];
    
    NSDate * returnDate =[NSDate dateWithTimeIntervalSince1970:[_model.returnCarDate doubleValue]/1000];
    
    
    
    NSString * takeTimeStr =[formatter stringFromDate:takeDate];
    NSString * returnTimeStr =[formatter stringFromDate:returnDate];
    
    
    UIButton *  takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    takeTime.frame =CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20);
    
    [takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [takeTime setTitle:[takeTimeStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    //    [_takeTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_scrollView addSubview:takeTime];
    
    
    //星期
    UILabel * week = [[UILabel alloc]initWithFrame:CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    week.text =[NSString stringWithFormat:@"%@ %@",[DBcommonUtils weekdayStringFromDate:takeDate withDateStr:nil],[takeTimeStr substringWithRange:NSMakeRange(11, 5)]];
    week.textAlignment = 1 ;
    week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    week.font = [UIFont systemFontOfSize:12 ];
    [_scrollView addSubview:week];
    
    
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
    [_scrollView addSubview:returnCartime];
    
    //时间
    
    UIButton *  returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    returnTime.frame =CGRectMake(returnCartime.frame.origin.x ,takeTime.frame.origin.y, ScreenWidth/4  , 20);
    returnTime.titleLabel.textAlignment = 1 ;
    
    
    //获取还车时间
    [returnTime setTitle:[returnTimeStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    [returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    //    [_returnTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [_scrollView addSubview:returnTime];
    
    
    
    //    星期
    UILabel * returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(returnCartime.frame.origin.x , week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    returnWeek.text =[NSString stringWithFormat:@"%@ %@",[DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil],[returnTimeStr substringWithRange:NSMakeRange(11, 5)]];
    
    returnWeek.font = [UIFont systemFontOfSize:12];
    returnWeek.textAlignment = 1 ;
    returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_scrollView addSubview:returnWeek];
    //
    
    
    //租车天数
    
    //中间图标
    UIImageView * imageView = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 4 + 10, CGRectGetMaxY(takeTime.frame) -5 -ScreenWidth / 4 * 47 / 136, ScreenWidth / 2 - 20 , (ScreenWidth / 2 - 20) * 47 / 136 )];
    imageView.image = [UIImage imageNamed:@"zcDays"];
    [_scrollView addSubview:imageView];
    
    
    //天数结果
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0 , 8, imageView.frame.size.width-2, 20)];
   
    
    if (_model.tenancyDays == nil)
    {
        number.text  =@"0";
    }
    else
    {
        number.text = [NSString stringWithFormat:@"%@",_model.tenancyDays];
        
    }

 
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
    [_scrollView addSubview:lineView1];
    
    
    
    //取还车
    
    
    [self createPlace:lineView1.frame with:array];
    
}

//创建取车地点
-(void)createPlace:(CGRect)frame with:(NSArray*)array
{
    
    
    //取车地点
    
    UILabel * takeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+10, CGRectGetMaxY(frame), ScreenWidth/4 , 40)];
    takeLabel.text = @"取车地点";
    takeLabel.font = [ UIFont systemFontOfSize:12];
    
    takeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_scrollView addSubview:takeLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeLabel addSubview:lineView1];
    
    
    //取车地点
    
    UILabel * takePlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(takeLabel.frame) , takeLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(takeLabel.frame) - 10, takeLabel.frame.size.height)];
    takePlace.text = _model.takeCarAddress ;
    
    
    //    takePlace.adjustsFontSizeToFitWidth = YES;
    takePlace.font = [ UIFont systemFontOfSize:10];
    
    takePlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_scrollView addSubview:takePlace];
    
    
    
    //取还车分割线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(takeLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:lineView2];
    
    
    
    //**************************还车地点
    
    //还车地点
    
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(takeLabel.frame.origin.x, CGRectGetMaxY(takeLabel.frame), takeLabel.frame.size.width, 40)];
    returnLabel.text = @"还车地点";
    returnLabel.font = [ UIFont systemFontOfSize:12];
    
    returnLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_scrollView addSubview:returnLabel];
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( returnLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [returnLabel addSubview:lineView3];
    
    
    //还车地点
    
    UILabel *  retuenPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame) , returnLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(returnLabel.frame) - 10, returnLabel.frame.size.height)];
    
    retuenPlace.text = _model.returnCarAddress;
    retuenPlace.font = [ UIFont systemFontOfSize:10];
    
    retuenPlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_scrollView addSubview:retuenPlace];
    
    
    //取还车分割线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(returnLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:lineView4];
    
    
    //取还车分割线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView4.frame)+20 , ScreenWidth  , 0.5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:lineView5];
    
    
    NSLog(@"%f",CGRectGetMaxY(lineView5.frame));
    
    [self setCostViewWithFrame:lineView5.frame with:array];
    
}


#pragma mark ---创建费用View
-(void)setCostViewWithFrame:(CGRect)frame with:(NSArray *)array
{
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [_scrollView addSubview:mustCost];
    
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"费用明细";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    
    
    
    //车辆费用
    UILabel * carCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(mustCost.frame), ScreenWidth / 3 - 40 , 40)];
    carCostLabel.text = @"车辆租金";
    carCostLabel.numberOfLines = 2 ;
    carCostLabel.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_scrollView addSubview:carCostLabel];
    
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(carCostLabel.frame)+10,CGRectGetMaxY(mustCost.frame) + 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView1];
    
    
//    //车辆费用
//    UILabel * carCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+20 , carCostLabel.frame.origin.y, ScreenWidth / 3  + 50, carCostLabel.frame.size.height)];
//    
//    [_scrollView addSubview:carCost];
//    
//    carCost.font = [UIFont systemFontOfSize:12];
//    
//    NSString * averagePrice = [NSString stringWithFormat:@"%@",_model.averagePrice];
//    
//    NSString *  daySum = [NSString stringWithFormat:@"%@",_model.tenancyDays];
//    
//    
//    NSString *commissionStr = [NSString stringWithFormat:@"均价%@元/天,共%@天",averagePrice,daySum];
//    //
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    //    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
//    //    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, averagePrice.length + daySum.length + 2)];
//    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
//    carCost.text = commissionStr;
    
    
    
    //车辆总费用
    UILabel * carCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , carCostLabel.frame.origin.y, ScreenWidth / 3 - 20, carCostLabel.frame.size.height)];
    
    carCostTotal.textAlignment = 2;
    
    
    [_scrollView addSubview:carCostTotal];
    
    
    NSString * totalAmount = [NSString stringWithFormat:@"%@",_model.rentalAmount];
    
    NSMutableAttributedString *carCostTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalAmount]];
    
    
    [carCostTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalAmount.length + 2)];
    
    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalAmount.length + 1)];
    carCostTotal.attributedText = carCostTotalStr;
    
    
    //
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(carCostLabel.frame) , ScreenWidth , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView2];
    
    

    
    
    
    //费用合计
    UILabel * totleCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(carCostLabel.frame.origin.x, CGRectGetMaxY(carCostLabel.frame), ScreenWidth / 3 - 40 , 40)];
    
    totleCostLabel.text = @"订单总额";
    totleCostLabel.numberOfLines = 2 ;
    totleCostLabel.font = [ UIFont systemFontOfSize:12];
    
    totleCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_scrollView addSubview:totleCostLabel];
    
    
    
    //
    UIView * lineView7 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(totleCostLabel.frame)+10,totleCostLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView7.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView7];
    
    
    //费用合计
    UILabel * totleCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , totleCostLabel.frame.origin.y, ScreenWidth / 3 - 20,  carCostLabel.frame.size.height)];
    
    totleCost.textAlignment = 2;
    
    
    [_scrollView addSubview:totleCost];
    
    
    
    
    NSString * totalPrice = [NSString stringWithFormat:@"%@",_model.payAmount];
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalPrice.length + 2)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length+ 1)];
    
    totleCost.attributedText = totleCostStr;
    
    
    //
    UIView * lineView8 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(totleCost.frame) , ScreenWidth , 0.5)];
    lineView8.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView8];
    
    
    //确认订单
    
    
    //显示更多车辆按钮
    UIButton * showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(50, CGRectGetMaxY(lineView8.frame)+20 , ScreenWidth - 100  , 30 );
  
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [showCarBt addTarget:self action:@selector(cancelBt:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:showCarBt];
    
    
    
    if ([_model.orderState integerValue] == 0 || [_model.orderState integerValue] == 1)
    {
        if ([_model.hasContract integerValue]== 1)
        {
            
            [showCarBt setTitle:@"确定" forState:UIControlStateNormal];
            
        }
        
        else
        {
            [showCarBt setTitle:@"取消订单" forState:UIControlStateNormal];
            
        }
        
    }
    else
    {
        [showCarBt setTitle:@"确定" forState:UIControlStateNormal];
        
    }
    
    
    
}
#pragma mark 点击事件


-(void)cancelBt:(UIButton*)button
{
    if ([_model.orderState integerValue] == 0 || [_model.orderState integerValue] == 1)
    {
        if ([_model.hasContract integerValue]== 1)
        {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        else
        {
            [self cancelOrder:button];
        }
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}




//确定按钮点击
-(void)cancelOrder:(UIButton*)button
{

    [self.tipView removeFromSuperview];
    

    
    NSString * url = [NSString stringWithFormat:@"%@/api/freeRideOrder/%@/cancelOrder",Host,self.model.orderId];
    
    DBNetworkTool * netWork = [[DBNetworkTool alloc]init];
    
    
    button.userInteractionEnabled = NO ;
    
    [netWork cancelOrderPUT:url parameters:nil];
    
    
    __weak typeof(self)weak_self= self ;
    netWork.cancelOrderBlcok = ^(NSDictionary * dic)
    {
        
        button.userInteractionEnabled = YES ;

        if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            [weak_self tipShow:[dic objectForKey:@"message"]];
            
            
            
            [UIView animateWithDuration:2 animations:^{
        
                
            } completion:^(BOOL finished) {
                
                [weak_self.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        else
        {
            [weak_self tipShow:[dic objectForKey:@"message"]];
        }
        
    };


    
}

//支付按钮点击
-(void)payBt
{
    
    
    if ([_model.orderState integerValue]==0)
    {
        AliayInfo * pay  =[[AliayInfo alloc]init];
        [pay generateData:(NSDictionary*)_OrderDic with:nil];
        
        
        //        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

//支付完成跳转
-(void)presentView
{
    NSLog(@"支付成功");
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView) name:@"PresentView" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PresentView" object:nil];
    
}

-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tipShow:(NSString *)str
{
    
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
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
