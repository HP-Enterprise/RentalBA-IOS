//
//  DBOderInfoViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

//支付
#import "Order.h"
//
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "DBOderInfoViewController.h"

#import "DBMyOrderViewController.h"

#import "AliayInfo.h"



@interface DBOderInfoViewController ()

{
    UIButton * showCarBt;
}
@property (nonatomic,strong)UIScrollView * scrollView ;

//错误提示
@property (nonatomic,strong)UIView * tipView ;

@property (nonatomic,strong)NSDictionary * OrderDic ;

@property (nonatomic,strong)DBProgressAnimation * progress ;
//下单成功生成订单
//@property(nonatomic,strong)Product *product ;

@end

@implementation DBOderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavgationView];
    
    //加载订单信息
    [self loadOrderData];
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
            url = [NSString stringWithFormat:@"%@/api/door/user/%@/order",Host,_model.orderId];
            
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

    __weak typeof(self)weak_self  = self ;
    
    [weak_self addProgress];

    [DBNetworkTool checkOrderGET:url parameters:nil success:^(id responseObject)
    {
        [weak_self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            if ([responseObject objectForKey:@"message"] != nil)
            {
                _OrderDic = [responseObject objectForKey:@"message"];

            }
        
            [self performSelectorOnMainThread:@selector(screateScrollerView) withObject:nil waitUntilDone:YES];
        }
        
        else
        {
            
        }
        
        
    } failure:^(NSError *error) {
        [self tipShow:@"没有数据"];
        
        [weak_self removeProgress];
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
    
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight +150 + severs.count* 40 );
   
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    if ([deviceType isEqualToString:@"iPad"]) {
        
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight +200 + severs.count* 40 );
    }
    
    
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
    
    //自驾
    if (self.orderIndex == 0)
    {
        switch ([_model.orderState integerValue])
        {
            case 0:
            {
                status = @"待支付";
            }
                break;
            case 1:
            {
                status = @"已下单";
            }
                break;
                
            case 2:
            {
                status = @"租赁中";
            }
                break;
                
            case 3:
            {
                status = @"已还车";
            }
                break;
                
            case 5:
            {
                status = @"已取消";
            }
                break;
        }
    }
    else if (self.orderIndex ==1)
    {
        switch ([_model.orderState integerValue])
        {
            case 0:
            {
                status = @"待支付";
            }
                break;
            case 1:
            {
                status = @"已下单";
            }
                break;
            case 2:
            {
                status = @"已下单";
            }
                break;
            case 3:
            {
                status = @"已下单";
            }
                break;
                
            case 4:
            {
                status = @"租赁中";
            }
                break;
            case 5:
            {
                status = @"租赁中";
            }
                break;
            case 6:
            {
                status = @"租赁中";
            }
                break;
                
            case 7:
            {
                status = @"已还车";
            }
                break;
                
            case 9:
            {
                status = @"已取消";
            }
                break;
        }
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
    UIView * paywaylineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(paylabel.frame)-0.5 , ScreenWidth, 0.5)];
    paywaylineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:paywaylineView];

    
    
    
    UILabel * payway = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(paywaylineView.frame), ScreenWidth - 20, 30)];
    
    if ([_model.payWay isEqualToString:@"0"])
    {
        payway.text = @"支付方式    门店支付";
    }
    else if([_model.payWay isEqualToString:@"3"])
        
    {
        payway.text = @"支付方式    在线支付宝";

    }
    
    
    payway.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:payway];

    
    
    
    
    
    
    //横线
    UIView * paylabellineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(payway.frame)-0.5 , ScreenWidth, 0.5)];
    paylabellineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:paylabellineView];
    
    
    
    
    

    UIButton * payBt = [UIButton buttonWithType:UIButtonTypeCustom];
    payBt.frame = CGRectMake(50, CGRectGetMaxY(payway.frame) , ScreenWidth - 100  ,0 );
    
    
    //显示现在支付
    if ([_model.orderState integerValue]==0)
    {
//        [payBt setTitle:@"确定" forState:UIControlStateNormal];
        [payBt setTitle:@"在线支付" forState:UIControlStateNormal];
        
        payBt.frame = CGRectMake(50, CGRectGetMaxY(payway.frame) +10, ScreenWidth - 100  ,30 );

        [_scrollView addSubview:payBt];
    }

    
    
    
    [payBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [payBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    payBt.layer.cornerRadius = 5 ;
    payBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [payBt addTarget:self action:@selector(payBt) forControlEvents:UIControlEventTouchUpInside];

    //横线
    UIView * orderStatusline= [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(payBt.frame)+9.5 , ScreenWidth, 0.5)];
    orderStatusline.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:orderStatusline];
    
    

    
    UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(payBt.frame)+10, ScreenWidth, 10)];
    
    backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [_scrollView addSubview:backView ];
    
    

    //横线
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(backView.frame) - 0.5 , ScreenWidth, 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:toplineView];
    
    
    //订单编号
    
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20, CGRectGetMaxY(backView.frame), ScreenWidth / 5 , 30)];
    orderLabel.text = @"订单编号 :" ;
    orderLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:orderLabel];
    
    
    
    //订单号
    
    
    UILabel *  orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderLabel.frame),  CGRectGetMaxY(backView.frame) , ScreenWidth - CGRectGetMaxX(orderLabel.frame)  - 50, 30)];
    orderNumber.text =[NSString stringWithFormat:@"%@",_model.orderId]  ;
    orderNumber.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:orderNumber];
    
    

    
    //横线
    UIView * orderlineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(orderLabel.frame)-0.5 , ScreenWidth, 0.5)];
    orderlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_scrollView addSubview:orderlineView];
    
    
    
    
    //创建车辆图片
    UIImageView * imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(orderlineView.frame)+10, 80, 50)];
    
    

    
    
  //    [imageV sd_setImageWithURL:[NSURL URLWithString:
//                                 [NSString stringWithFormat:@"%@%@",Host,_model.picture]] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
    [_scrollView addSubview:imageV];
    
    
    
    //车辆名称
    UILabel * carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y + 10 , ScreenWidth - CGRectGetMaxX(imageV.frame) , 15)];
    
    

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
    
    
    NSString* encodedString;
    
    if ([_model.orderType isEqualToString:@"2"]) {
        
        
        
        encodedString = [[NSString stringWithFormat:@"%@%@",Host,[_model.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        carName.text = _model.vehicleModelShow.model ;
        
        NSString * carGroup ;
        if (_model.vehicleModelShow.carGroup == nil)
        {
            carGroup = @"" ;
        }
        else
        {
            if ([_model.vehicleModelShow.carGroup isEqualToString:@"1"]) {
                carGroup = @"自动挡";
            }
            else{
                carGroup = @"手动挡";
            }
            
        }
        
        
        NSString * trunk ;
        if (_model.vehicleModelShow.carTrunk == nil)
        {
            trunk = @"" ;
        }
        
        else
        {
            if ([_model.vehicleModelShow.carTrunk isEqualToString:@"1"]) {
                trunk = @"3厢";
            }
            else{
                trunk = @"2厢";
            }
        }
        
        NSString * seats ;
        if (_model.vehicleModelShow.seats == nil)
        {
            seats = @"" ;
        }
        else
        {
            seats =[NSString stringWithFormat:@"%@座",_model.vehicleModelShow.seats];
            
        }
        
        carkind.text =[NSString stringWithFormat:@"%@ | %@ | %@",carGroup,trunk,seats];
        
        
    }
    else if ([_model.orderType isEqualToString:@"1"]){
        encodedString = [[NSString stringWithFormat:@"%@%@",Host,[_model.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        carName.text = _model.model ;
        
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
        
        
        
    }
    [imageV sd_setImageWithURL:[NSURL URLWithString:
                                 encodedString] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
    
    
 
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
    
    UILabel * takePlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(takeLabel.frame) , takeLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(takeLabel.frame) - 20, takeLabel.frame.size.height)];
   
    takePlace.text = [NSString stringWithFormat:@"%@(%@)",_model.takeCarAddress,[[_OrderDic objectForKey:@"takeCarStore"]objectForKey:@"detailAddress"]] ;


    takePlace.numberOfLines = 0 ,
    takePlace.font = [ UIFont systemFontOfSize:11];
    takePlace.adjustsFontSizeToFitWidth = YES;
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
    
    UILabel *  retuenPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame) , returnLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(returnLabel.frame) - 20, returnLabel.frame.size.height)];
    
    retuenPlace.text = [NSString stringWithFormat:@"%@(%@)",_model.returnCarAddress,[[_OrderDic objectForKey:@"returnCarStore"]objectForKey:@"detailAddress"]] ;

    retuenPlace.numberOfLines = 0 ;
    retuenPlace.font = [ UIFont systemFontOfSize:11];
    retuenPlace.adjustsFontSizeToFitWidth = YES ;
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
    
    
    //车辆费用
    UILabel * carCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+15 , carCostLabel.frame.origin.y, ScreenWidth / 3  + 50, carCostLabel.frame.size.height)];
    
    [_scrollView addSubview:carCost];
    
    carCost.font = [UIFont systemFontOfSize:11];
    
    if (_model.averagePrice == nil)
    {
        _model.averagePrice  =@"0";
    }
   
    if (_model.tenancyDays == nil)
    {
        _model.tenancyDays  =@"0";
    }
 
    NSString * averagePrice = [NSString stringWithFormat:@"%@",_model.averagePrice];
    
    NSString *  daySum = [NSString stringWithFormat:@"%@",_model.tenancyDays];
    
    
    NSString *commissionStr = [NSString stringWithFormat:@"均价%@元/天,共%@天",averagePrice,daySum];
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
    
    
    [_scrollView addSubview:carCostTotal];
    
    if (_model.rentalAmount == nil)
    {
        _model.rentalAmount  =@"0";
    }
    
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
    
    
    
    
    //基本保险费
    UILabel * premiumLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(lineView2.frame), ScreenWidth / 3 - 40 , 40)];
    premiumLabel.text = @"基本保险金额";
    premiumLabel.numberOfLines = 2 ;
    premiumLabel.font = [ UIFont systemFontOfSize:12];
    
    premiumLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_scrollView addSubview:premiumLabel];
    
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(premiumLabel.frame)+10,premiumLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView3];
    
    
    //保险费用
    UILabel * premiumCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+15 , premiumLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];
    
    [_scrollView addSubview:premiumCost];
    
    if (_model.basicInsuranceAmount == nil)
    {
        _model.basicInsuranceAmount  =@"0";
    }
    
    NSString * basicInsuranceAmount =[NSString stringWithFormat:@"%@",_model.basicInsuranceAmount];
    
    
    
    NSString*costPremiumStr = [NSString stringWithFormat:@"均价%@元/天,共%@天",basicInsuranceAmount,daySum];
    
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
    
    
    [_scrollView addSubview:premiumCostTotal];

    
    
    NSString *  totalBasicInsuranceAmount =[NSString stringWithFormat:@"%ld",[basicInsuranceAmount integerValue]*[daySum integerValue]];
        
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
    
    [_scrollView addSubview:lineView4];
    
    
    
    
    CGRect temporaryFrame  = lineView4.frame ;
    
    
    
//超时费用
    UILabel * timeOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(lineView4.frame), ScreenWidth / 3 - 40 , 40)];
    timeOutLabel.text = @"超时费";
    timeOutLabel.numberOfLines = 2 ;
    timeOutLabel.font = [ UIFont systemFontOfSize:12];
    
    timeOutLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    
    
    
    //
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(timeOutLabel.frame)+10,timeOutLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    
    
    
    
    //超时费
    UILabel * timeOutCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+15 , timeOutLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];
    
    
    if (_model.timeoutPrice == nil)
    {
        _model.timeoutPrice  =@"0";
    }
    NSString * timeOutprice =[NSString stringWithFormat:@"%@",_model.timeoutPrice];
    
    
    
    NSString* timeOutpriceStr = [NSString stringWithFormat:@"%@元/小时",timeOutprice];
    
    NSLog(@"%@",costPremiumStr);
    
    timeOutCost.font = [UIFont systemFontOfSize:11];
    
    
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    //    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,basicInsuranceAmount.length + daySum.length + 2)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    timeOutCost.text = timeOutpriceStr;
    
    
    
    
    //超时费用
    UILabel * timeOutpriceTotalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , timeOutCost.frame.origin.y, ScreenWidth / 3 - 20, premiumLabel.frame.size.height)];
    
    timeOutpriceTotalLabel.textAlignment = 2;
    
   
    
    if (self.model.totalTimeoutPrice == nil)
    {
        self.model.totalTimeoutPrice  =@"0";
    }
    
    NSString *  timeOutpriceTotal =[NSString stringWithFormat:@"%@",self.model.totalTimeoutPrice];
    
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
    
    
    if ([self.model.totalTimeoutPrice integerValue] > 0 )
    {
        
        
        
        
        [_scrollView addSubview:timeOutLabel];
        [_scrollView addSubview:lineView5];
        
        [_scrollView addSubview:timeOutCost];
        
        [_scrollView addSubview:timeOutpriceTotalLabel];
        [_scrollView addSubview:lineView6];

        temporaryFrame  = lineView6.frame ;
  
        
        CGSize newSize = _scrollView.contentSize ;
        newSize.height += 40 ;
        _scrollView.contentSize = newSize;

        
    }
    
    
//  //增值服务费
//    UIView * addbaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView6.frame), ScreenWidth, 40 * array.count )];
//    [_scrollView addSubview:addbaseView];
    
    //增值服务费
    UIView * addbaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(temporaryFrame), ScreenWidth, 0 )];
    [_scrollView addSubview:addbaseView];
    
    if (array.count>0)
    {
        
        for (int i = 0 ; i < array.count ; i ++)
        {
            
            if (![array[i] isKindOfClass:[NSNull class]])
                
            {
                CGRect frame = addbaseView.frame ;

                
                frame.size.height += 40 ;
                
                
                addbaseView.frame = frame ;
                
                UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, i*40, ScreenWidth/3 -40 , 40)];
                commissionLabel.text = [array[i]objectForKey:@"description"];
                commissionLabel.font = [ UIFont systemFontOfSize:12];
                
                commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
                
                [addbaseView addSubview:commissionLabel];
                
                
                //
                UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(commissionLabel.frame)+10 , 10 + i*40, 0.5 , 20)];
                lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                [addbaseView addSubview:lineView1];
                
                
                //不计免赔服务
                
                UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+15 , commissionLabel.frame.origin.y, ScreenWidth / 3 + 20, commissionLabel.frame.size.height)];
                
                commission.font = [UIFont systemFontOfSize:10];
                commission.numberOfLines = 2 ;
                commission.adjustsFontSizeToFitWidth = YES;
                
                [addbaseView addSubview:commission];
                

                NSString * commissionstr =[NSString stringWithFormat:@"%@",[array[i] objectForKey:@"serviceAmount"]];
        
                NSInteger  price;
                

                
                //总费用
                UILabel * premiumCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
                
                premiumCostTotal.textAlignment = 2;
                
                [addbaseView addSubview:premiumCostTotal];
                
                NSString * days = _model.tenancyDays ;
                NSString * dayPrice;
                
                price = [commissionstr integerValue];

                if ([[array[i]objectForKey:@"description"]isEqualToString:@"不计免赔"])
                {

//                    if ([days integerValue]<=7)
//
//                    {
//                        dayPrice  =[NSString stringWithFormat:@"%ld",[commissionstr integerValue]/[ days integerValue]];
//                        commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天),共%@天",dayPrice,days];
//                    }
//                    else
//                        
//                    {
//                        dayPrice  =[NSString stringWithFormat:@"%ld",[commissionstr integerValue]/7];
//                        commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天),共7天",dayPrice];
//                    }
                    
                    dayPrice =[NSString stringWithFormat:@"%ld",price /[DBcommonUtils calculateRegardless:[days integerValue]]]  ;
                    commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天,每30天一周期),共%@天",dayPrice,days];

                }

                else
                {
                    commission.text = [NSString stringWithFormat:@"均价%@元/次,共1次",commissionstr];
                }
                
                NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %ld",price]];
                //
                
                [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,costPremiumTotalStr.length )];
                //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
                [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, costPremiumTotalStr.length -1)];
                //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
                premiumCostTotal.attributedText = costPremiumTotalStr;
                
                
                
                //保险费分割线
                UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(commission.frame) , ScreenWidth  , 0.5)];
                lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                [addbaseView addSubview:lineView2];
            }
        }
        
    }


    CGRect ActivityTemporaryFrame = addbaseView.frame ;
    
    
    
    //优惠活动
    
    UILabel * activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(addbaseView.frame), ScreenWidth / 3 - 40 , 0)];
    
        activityLabel.numberOfLines = 2 ;
    activityLabel.font = [ UIFont systemFontOfSize:12];
    
    activityLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];

    //
    UIView * activitylineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(activityLabel.frame)+10,activityLabel.frame.origin.y + 10 , 0.5 , 20)];
    activitylineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    //优惠活动描述
    UILabel * activitydescription = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(activitylineView.frame)+15 , activityLabel.frame.origin.y, ScreenWidth / 3 + 10, carCostLabel.frame.size.height)];
    
    NSString * activityPrice ;
    
    activitydescription.font = [UIFont systemFontOfSize:11];
    activitydescription.numberOfLines = 2 ;
    activitydescription.adjustsFontSizeToFitWidth = YES ;

    //优惠金额
    UILabel * activityCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 +10, activityLabel.frame.origin.y, ScreenWidth / 3 - 30,  premiumLabel.frame.size.height)];
    
    activityCost.textAlignment = 2;
    

    
    //
    UIView * activityCostlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(activityCost.frame) , ScreenWidth , 0.5)];
    activityCostlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    if (![[_OrderDic objectForKey:@"couponShowForAdmin"] isKindOfClass:[NSNull class]] && [_OrderDic objectForKey:@"couponShowForAdmin"]!= nil)
    {
        activityLabel.text = @"优惠券";
        activityLabel.frame =CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(addbaseView.frame), ScreenWidth / 3 - 40 , 40);

        activitydescription.text = [[_OrderDic objectForKey:@"couponShowForAdmin"]objectForKey:@"title"];
        
        activityPrice = [NSString stringWithFormat:@"%@",[[_OrderDic objectForKey:@"couponShowForAdmin"]objectForKey:@"amount"]];

        
        [_scrollView addSubview:activityLabel];
        [_scrollView addSubview:activitylineView];
        [_scrollView addSubview:activityCost];
        [_scrollView addSubview:activitydescription];
        [_scrollView addSubview:activityCostlineView];

        
         ActivityTemporaryFrame = activityLabel.frame ;
        
        
        CGSize newsize = _scrollView.contentSize ;
        newsize.height += 40 ;
        _scrollView.contentSize = newsize ;
        
        
        
        
    }
    
    else if (![[_OrderDic objectForKey:@"activityShow"] isKindOfClass:[NSNull class]] && [_OrderDic objectForKey:@"activityShow"]!= nil)
    {
        
        activityLabel.text = @"优惠活动";
        activityLabel.frame =CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(addbaseView.frame), ScreenWidth / 3 - 40 , 40);
        
        activitydescription.text = [[_OrderDic objectForKey:@"activityShow"]objectForKey:@"activityDescription"];
        
        if ([[_OrderDic objectForKey:@"reduce"]isKindOfClass:[NSNull class]]) {
            activityPrice = @"";
        }
        else{
            activityPrice = [NSString stringWithFormat:@"%@",[_OrderDic objectForKey:@"reduce"]];

        }
        
        
        [_scrollView addSubview:activityLabel];
        [_scrollView addSubview:activitylineView];
        [_scrollView addSubview:activityCost];
        
        [_scrollView addSubview:activitydescription];
        [_scrollView addSubview:activityCostlineView];
        
        
        ActivityTemporaryFrame = activityLabel.frame ;
        
        
        CGSize newsize = _scrollView.contentSize ;
        newsize.height += 40 ;
        _scrollView.contentSize = newsize ;
    }
    
    
    NSMutableAttributedString *activityPriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",activityPrice]];
    
    [activityPriceStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,activityPrice.length + 2)];
    
    
    
    [activityPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
    [activityPriceStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , activityPrice.length+ 1)];
    
    activityCost.attributedText = activityPriceStr;
    
    activityCost.adjustsFontSizeToFitWidth = YES ;
   

    
    
//到店取车
    
    //    DBShowListModel * model = [[NSArray arrayWithArray:self.model.vendorStorePriceShowList]firstObject] ;
    
    
    //优惠价格
    UILabel * getCarStore = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(activityLabel.frame) , ScreenWidth / 3 - 40 , 40)];
    getCarStore.text = @"到店取车";
    getCarStore.font = [ UIFont systemFontOfSize:12];
    
    getCarStore.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //竖线
    UIView * getCarStorelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(getCarStore.frame)+10,getCarStore.frame.origin.y + 10 , 0.5 , 20)];
    getCarStorelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    //横线
    UIView * getCarStorelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(getCarStore.frame), ScreenWidth , 0.5)];
    getCarStorelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    
    //优惠说明
    UILabel * getCarStoreExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(getCarStorelineView.frame)+15 , getCarStore.frame.origin.y, ScreenWidth / 3 +20, getCarStore.frame.size.height)];
    getCarStoreExplace.font = [ UIFont systemFontOfSize:11];
    getCarStoreExplace.adjustsFontSizeToFitWidth = YES ;
    
    
    //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //优惠价格
    
    UILabel * getCarStorePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 10  , getCarStore.frame.origin.y, ScreenWidth / 3 - 30, getCarStore.frame.size.height)];
    
    
    getCarStorePrice.textAlignment = 2 ;
    
    NSString * getCarStoreStr;
    if (![[self.OrderDic objectForKey:@"toStoreReduce"]isKindOfClass:[NSNull class]]) {
        
        
        getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.OrderDic objectForKey:@"toStoreReduce"]];
        
        getCarStoreStr = [NSString stringWithFormat:@"%@",[self.OrderDic objectForKey:@"toStoreReduce"]] ;
        
        NSMutableAttributedString *getCarStorePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",[NSString stringWithFormat:@"%@",getCarStoreStr]]];
        
        
        
        [getCarStorePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,getCarStoreStr.length + 2)];
        //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
        [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
        [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, getCarStoreStr.length + 1)];
        //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
        getCarStorePrice.attributedText = getCarStorePricestr;
        getCarStorePrice.adjustsFontSizeToFitWidth = YES ;
        
        
    }
    
    if (![[self.OrderDic objectForKey:@"toStoreReduce"]isKindOfClass:[NSNull class]]) {
        
        
        
        [_scrollView addSubview:getCarStore];
        [_scrollView addSubview:getCarStorelineView];
        [_scrollView addSubview:getCarStorelastlineView];
        [_scrollView addSubview:getCarStoreExplace];
        
        [_scrollView addSubview:getCarStorePrice];
        
        CGSize scroller =_scrollView.contentSize ;
        
        scroller.height += 40 ;
        _scrollView.contentSize = scroller ;
        
        
        ActivityTemporaryFrame = getCarStore.frame ;

        
    }
    
    //费用合计
    UILabel * totleCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(ActivityTemporaryFrame), ScreenWidth / 3 - 40 , 40)];

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
    UILabel * totleCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , totleCostLabel.frame.origin.y, ScreenWidth / 3 - 20,  premiumLabel.frame.size.height)];
    
    totleCost.textAlignment = 2;
    
    
    [_scrollView addSubview:totleCost];
    
    
    
    NSString * totalPrice = [NSString stringWithFormat:@"%@",_model.payAmount];
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalPrice.length + 1)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length)];
    
    totleCost.attributedText = totleCostStr;
    
    
    //
    UIView * lineView8 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(totleCost.frame) , ScreenWidth , 0.5)];
    lineView8.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_scrollView addSubview:lineView8];
    

    //确认订单
    
    
    //显示更多车辆按钮
    showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(50, CGRectGetMaxY(lineView8.frame)+20 , ScreenWidth - 100  , 30 );
   
    
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

    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [showCarBt addTarget:self action:@selector(cancelBt:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:showCarBt];

}

//判断优惠券金额
//-(NSString*)getShowDicRental:(NSDictionary*)dic{
//
//    NSString * price;
//    if (![dic[@"genre"]isKindOfClass:[NSNull class]]) {
//        if ([dic[@"genre"]isEqualToString:@"subRental"]) {
//            if ([[dic objectForKey:@"amount"]floatValue] > [[self.priceDic objectForKey:@"totalAmount"]integerValue]) {
//                price = [self.priceDic objectForKey:@"totalAmount"];
//            }
//            else{
//                price = [showDic objectForKey:@"amount"];
//            }
//        }
//        else if ([showDic[@"genre"]isEqualToString:@"subTotal"]){
//            if (totalPrice == nil) {
//                return nil;
//            }
//            if ([[showDic objectForKey:@"amount"]floatValue] > [totalPrice integerValue]) {
//                price = totalPrice;
//            }
//            else{
//                price = [showDic objectForKey:@"amount"];
//            }
//        }
//    }
//    else{
//        price = [showDic objectForKey:@"amount"];
//    }
//    return price;
//}

-(void)addDifstore:(CGRect)frame{

}

#pragma mark ---取消订单
-(void)cancelBt:(UIButton*)button
{
    if ([showCarBt.titleLabel.text isEqualToString:@"确定"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.tipView removeFromSuperview];

        NSString * url;
        
        switch (self.orderIndex)
        {
            case 0:
            {
                url = [NSString stringWithFormat:@"%@/api/user/order/%@/cancelOrder",Host,self.model.orderId];
                
                
                [self cancelOrderPut:url];
                
            }
                break;
            case 1:
            {
                url = [NSString stringWithFormat:@"%@/api/door/clientcanle/%@/order",Host,self.model.orderId];
                
                [self cancelOrderDelet:url];
        
            
            }
                break;
        }
     

    }
}
-(void)cancelOrderPut:(NSString*)url{
    DBNetworkTool * netWork = [[DBNetworkTool alloc]init];
    
    [self addProgress];
    
    [netWork cancelOrderPUT:url parameters:nil];
    
    __weak typeof(self)weak_self = self ;
    netWork.cancelOrderBlcok = ^(id dic)
    {
        [self removeProgress];
        if ([dic isKindOfClass:[NSError class]]) {
            [self tipShow:@"数据加载失败"];
        }
        else{
            if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
            {
                [UIView animateWithDuration:2 animations:^{
                    
                    [weak_self tipShow:[dic objectForKey:@"message"]];
                    
                } completion:^(BOOL finished) {
                    
                    [weak_self.navigationController popViewControllerAnimated:YES];
                }];
                //                [showCarBt setTitle:@"确定" forState:UIControlStateNormal];
            }
            else
            {
                
                [weak_self tipShow:@"取消订单失败"];
            }
            
        }
        
    };
}

-(void)cancelOrderDelet:(NSString*)url{
    [self addProgress];
    __weak typeof(self)weak_self = self ;

    [DBNetworkTool DELETE:url parameters:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            [UIView animateWithDuration:2 animations:^{
                
                [weak_self tipShow:[responseObject objectForKey:@"message"]];
                
            } completion:^(BOOL finished) {
                
                [weak_self.navigationController popViewControllerAnimated:YES];
            }];
            //                [showCarBt setTitle:@"确定" forState:UIControlStateNormal];
        }
        else
        {
            
            [weak_self tipShow:@"取消订单失败"];
        }

    } failure:^(NSError *error) {
        [self tipShow:@"数据加载失败"];
    }];
    
}
//支付按钮点击
-(void)payBt
{
    if ([_model.orderState integerValue]==0)
    {
        AliayInfo * pay  =[[AliayInfo alloc]init];
        [pay generateData:(NSDictionary*)_OrderDic with:_model.payAmount];
        

        pay.payblock = ^(NSDictionary * dic)
        {
            [self PopView];
            
        };
        
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



//支付完成跳转
-(void)PopView
{
    NSLog(@"支付成功");
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view bringSubviewToFront:self.tipView];
    [self.view addSubview:self.tipView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PopView) name:@"PopView" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopView" object:nil];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
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
    [[BaiduMobStat defaultStat]pageviewStartWithName:title];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
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
    [[BaiduMobStat defaultStat]pageviewEndWithName:title];
}
-(void)dealloc
{
    NSLog(@"DBOderInfoViewController free");
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
