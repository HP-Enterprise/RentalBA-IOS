//
//  DBOrderPayViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/4/21.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBOrderPayViewController.h"

#import "DBMyOrderViewController.h"

#import "DBCarListViewController.h"

//#import "DBStoreInfoViewController.h"

//
#import "Order.h"
//
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//
//

@implementation Product

@end

@interface DBOrderPayViewController ()


//创建计时控制器
@property (nonatomic, strong)NSTimer *timer ;
@property (nonatomic)NSInteger time ;


//下单成功生成订单
@property(nonatomic,strong)Product *product ;
//显示时间label
@property (nonatomic,strong)UILabel * timeLabel;

@property (nonatomic,strong)NSDictionary * OrderDic ;

@end


@implementation DBOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavgationView];
    
    [self setOrder];
    
    
    [self setTimer];
    

}
#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults]  ;
    
    NSString * title ;
    if (self.orderIndex == 3)
    {
        title = @"顺风车订单";
    }
    else
    {
        if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
        {
            title = @"门到门订单";
        }else
        {
            title = @"自驾订单";
        }
    }
    

    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:title withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    [self.view addSubview:nav];
    

    
}


-(void)presentView
{
    NSLog(@"支付成功");
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    DBMyOrderViewController * order = [[DBMyOrderViewController alloc]init];
    
    if (self.orderIndex == 3)
    {
        order.orderIndex = 3 ;
    }
    else
    {
        if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
        {
//            title = @"门到门订单";
            order.orderIndex = 1;
        }else
        {
//            title = @"自驾订单";
            order.orderIndex = 0 ;
        }

    }
    
    
    [self.navigationController pushViewController:order animated:YES];
}

//创建view
-(void)setOrder
{
    
    //创建递交成功
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(20, 74, ScreenWidth - 40 , 200)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    baseView.layer.cornerRadius = 5 ;
    baseView.layer.masksToBounds = YES;
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height/2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [baseView addSubview:whiteView];
    

    NSString * str = @"60秒后跳转到个人订单中心";
    
    CGSize widthSize =[DBcommonUtils calculateStringLenth:str withWidth:ScreenWidth withFontSize:10];
    
    
    UIImageView * imageV  = [[ UIImageView alloc]initWithFrame:CGRectMake((baseView.frame.size.width - 40 - 10 - widthSize.width)/2 , 30, 40, 40)];
    imageV.image = [UIImage imageNamed:@"orderOver"];
    [whiteView addSubview:imageV];
    
    
    
    
    
    UILabel * orderOver = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y, baseView.frame.size.width - CGRectGetMaxX(imageV.frame), 20)];
    orderOver.text  = @"订单提交成功!" ;
    orderOver.font = [UIFont systemFontOfSize:14];
    orderOver.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    [whiteView addSubview:orderOver];
    
    
    CGSize timeSize = [DBcommonUtils calculateStringLenth:@"52" withWidth:ScreenWidth withFontSize:11];
    
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderOver.frame.origin.x, CGRectGetMaxY(orderOver.frame)+5, timeSize.width+2, timeSize.height)];
    _timeLabel.text = @"5";
    _timeLabel.font = [UIFont systemFontOfSize:11];
    _timeLabel.textColor = [DBcommonUtils getColor:@"eb6001"];
 
    
    
    [whiteView addSubview:_timeLabel];
    
    
    CGSize blockSize = [DBcommonUtils calculateStringLenth:@"秒后跳转到" withWidth:ScreenWidth withFontSize:10];
    
    UILabel * blockLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_timeLabel.frame), _timeLabel.frame.origin.y, blockSize.width , timeSize.height)];
    blockLable.text = @"秒后跳转到";
    blockLable.font = [UIFont systemFontOfSize:10];
    blockLable.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    
    

    UIButton * myOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    myOrder.frame = CGRectMake(CGRectGetMaxX(blockLable.frame), blockLable.frame.origin.y,blockSize.width+20, timeSize.height);
    myOrder.backgroundColor = [UIColor clearColor];
    [myOrder setTitle:@"个人订单中心" forState:UIControlStateNormal];
   
    myOrder.titleLabel.font = [UIFont systemFontOfSize:11];
    [myOrder setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [myOrder addTarget:self action:@selector(myOrderClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([self.payWay isEqualToString:@"0"])
    {
               //跳转文字添加到view
        [whiteView addSubview:blockLable];
        
        
        //个人中心按钮 添加到view
        [whiteView addSubview:myOrder];
    }
    else if ([self.payWay isEqualToString:@"3"])
    {
        //提交订单成功提示
        orderOver.frame = CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y + 10, baseView.frame.size.width - CGRectGetMaxX(imageV.frame), 20);
    
    }
    

    //创建下班变灰色
    UIView * grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, baseView.frame.size.width, 100)];
    grayView.backgroundColor = [DBcommonUtils getColor:@"c9caca"];
    [baseView addSubview:grayView];
    
    
    //创建车辆信息
    UILabel * carInfo  =[[ UILabel alloc]initWithFrame:CGRectMake( 30, 10, grayView.frame.size.width - 40, 20)];
  
    if (self.orderIndex  == 3 )
    {
       carInfo.text =[NSString stringWithFormat:@"%@,租期为%@天",self.freeRideModel.vehicleShow.vehicleModelShow.model,self.freeRideModel.maxRentalDay];
    }
    else
    {
        carInfo.text =[NSString stringWithFormat:@"%@,租期为%@天",self.model.vehicleModelShow.model,[self.priceDic objectForKey:@"daySum"]];

    }
    
    carInfo.textColor = [DBcommonUtils getColor:@"333333"];
    carInfo.font = [UIFont systemFontOfSize:12];
    [grayView addSubview:carInfo];
    
    
    //订单编号
    UILabel * orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(carInfo.frame.origin.x, CGRectGetMaxY(carInfo.frame), carInfo.frame.size.width, 20)];
    orderNumber.text =[NSString stringWithFormat:@"订单号: %@",self.orderNumber] ;
    orderNumber.textColor = [DBcommonUtils getColor:@"333333"];
    orderNumber.font = [UIFont systemFontOfSize:12];
    [grayView addSubview:orderNumber];
    
    
    //支付方式
    UILabel * payClass = [[UILabel alloc]initWithFrame:CGRectMake(carInfo.frame.origin.x, CGRectGetMaxY(orderNumber.frame), carInfo.frame.size.width, 20)];
   
    if ([self.payWay isEqualToString:@"3"]) {
        payClass.text = @"支付方式: 在线支付" ;

    }
    else
    {
        payClass.text = @"支付方式: 门店支付" ;

    }
    payClass.textColor = [DBcommonUtils getColor:@"333333"];
    payClass.font = [UIFont systemFontOfSize:12];
    [grayView addSubview:payClass];

    
    //订单总价
    UILabel * payCost = [[UILabel alloc]initWithFrame:CGRectMake(carInfo.frame.origin.x, CGRectGetMaxY(payClass.frame), carInfo.frame.size.width, 20)];
    payCost.text =[NSString stringWithFormat:@"订单总价: ￥%@",self.totalCost] ;
    payCost.textColor = [DBcommonUtils getColor:@"333333"];
    payCost.font = [UIFont systemFontOfSize:12];
    [grayView addSubview:payCost];

}


//设置控制器
#pragma mark ---门店支付则倒计时 支付宝则弹窗
-(void)setTimer
{
    
    if ([self.payWay isEqualToString:@"3"])
    {
        _timeLabel.text = nil ;
        
        
        [self createAlipay];
        
    }
    else if ([self.payWay isEqualToString:@"0"])
    {
    
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanege) userInfo:nil repeats:YES];
        _time = 5 ;
    }
}


-(void)createAlipay
{
    
    //创建背景
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 290, ScreenWidth, 48)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,0 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [baseView addSubview:lineView];
    
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,47.5 , ScreenWidth , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [baseView addSubview:lineView1];
    
    
    
    UIImageView * alipayImage = [[UIImageView alloc]initWithFrame:CGRectMake( 20  , 10, 28, 28)];
    alipayImage.image = [UIImage imageNamed:@"alipay_logo"];
    [baseView addSubview:alipayImage];
    
    UILabel * alipay = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(alipayImage.frame)+20, 10, ScreenWidth/2 - 78 , 28)];

    alipay.text =@"支付宝付款" ;
    alipay.font = [UIFont systemFontOfSize:14];
    

    [baseView addSubview:alipay];
    

    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 35, 16.5, 15, 15)];
    image.image = [UIImage imageNamed:@"choosePay"];
    [baseView addSubview:image];
    

    
    //显示更多车辆按钮
    UIButton * alipayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBt.frame = CGRectMake( 50 , CGRectGetMaxY(baseView.frame)+60 ,ScreenWidth - 100  , 30 );
    [alipayBt setTitle:@"去支付" forState:UIControlStateNormal];
    [alipayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alipayBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [alipayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alipayBt.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    alipayBt.layer.cornerRadius = 5 ;
    alipayBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [alipayBt addTarget:self action:@selector(alipayBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayBt];

    

}


//开始倒计时
-(void)timeChanege
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    if(_time != 0 /*&& userNameField.field.text.length == 11*/) {
        
        _time--;
        _timeLabel.text = [NSString stringWithFormat:@"%ld", _time];
        
    }else
    {
       
        [_timer invalidate];
        _timer = nil;
        
        
        DBMyOrderViewController * myOrder = [[DBMyOrderViewController  alloc]init];

        if (self.orderIndex == 3)
        {
            
             myOrder.orderIndex = 3 ;
            

        }
        else
        {
            //判断是门店取车还是送车上门
            if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
            {
                
                myOrder.orderIndex = 1 ;
                
            }
            else
            {
                myOrder.orderIndex = 0 ;
                
            }
            
            [self.navigationController pushViewController:myOrder animated:YES];

        }
        
        
    }
}

-(void)myOrderClick
{
    NSLog(@"我的订单点击了");
    [_timer invalidate];
    _timer = nil;
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    DBMyOrderViewController * myOrder = [[DBMyOrderViewController  alloc]init];
    
    
    
    
    // 0 门到门服务
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        
        myOrder.orderIndex = 1 ;
        
    }
    else
    {
        
        myOrder.orderIndex = 0 ;
        
    }
    
    [self.navigationController pushViewController:myOrder animated:YES];

}

-(void)backBt
{
    
    //跳转到制定控制器
    
    [self.navigationController popToRootViewControllerAnimated:YES];


}


#pragma mark -

-(void )alipayBt
{
    
    

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSString * url ;
    
    if (self.orderIndex == 3)
    {
        url = [NSString stringWithFormat:@"%@/api/user/%@/freeRideOrder/%@",Host,[user objectForKey:@"userId"],self.orderNumber];
    }
    else
    {
        //门到门
        if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/doorToDoorOrder/%@",Host,[user objectForKey:@"userId"],self.orderNumber];

        }
        
        else
        {

            url = [NSString stringWithFormat:@"%@/api/user/%@/order/%@",Host,[user objectForKey:@"userId"],self.orderNumber];
            
        }

    }
    
    
    _OrderDic = [NSDictionary dictionary];
    
    
    
    [DBNetworkTool checkOrderGET:url parameters:nil success:^(id responseObject){
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]){
             
             _OrderDic = [responseObject objectForKey:@"message"];
             

             [self performSelectorOnMainThread:@selector(generateData) withObject:nil waitUntilDone:YES];
             
         }
         else{
             
         }
         
     } failure:^(NSError *error) {

     }];
}



#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{

    return [_OrderDic objectForKey:@"orderIdToAlipay"];
    
}

 
#pragma mark   ==============产生订单信息==============

- (void)generateData
{
    _product = [[Product alloc] init];
    _product.subject = @"赶脚租车";
    _product.body = [_OrderDic objectForKey:@"model"];
    _product.price = (float)[self.totalCost integerValue];
//    _product.price = 0.01f;
    [self clickAlipay];
    
}

#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)clickAlipay
{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //新支付宝账号
    
    NSString *partner = @"2088311106439495";
    NSString *seller = @"huachen_zulin@163.com";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALfGjge8qE7k+7aZxRyrDHxynviQSRp1awTt6uuQrYJr6XbVZZJcYf39tOMiRE2AzksZVWlZcq/sQKRUwC9yVqZzNq4Ke2vVdfftkNk+6oNSvG10HSUSTDKhCxDwluO2+NqCoCAQw1P/168V/7YdcyvptOuP1vgPWH2s/X63j7flAgMBAAECgYAC93+ffFozO9scbYsTFWfUMn2CgcHMXYzmvXiHaQSEEH3qXzOOk1M5qHjdGdaEccniyHvqgXkqgePhQ0T+/xeK/Vq3npBMyTPg2BbuFi/fRCErcOpdQOXmtbze/FKsSS0HJ7QeNgLnGjrJ5KhknKQmGNEFjQXBdE+44TDHf11T2QJBAOJQCb5WjhZ2tSz5D3XNtrGf7CFyTLQVFklUS0YABYtXIZ9QPJaZkaNtEMxr8PeEnL462pBhrDnaQlZuvoaulHMCQQDP4g0AL6uJmpdyvApcuMH7gEyNwRCuwKRqNGtdugwuN6k5oLnT56zLQ2Pdl1WX9Kv44JIycFdunWYv7PNz8kRHAkAbcGzeAQyVOKta2o+/TsPZ4XP10i/unafoGCpQQGxrqpLPCCFweQopcG3a+zNqL0/52JTrcIw7L3VfmWnMVpp1AkBdczvu6n8NY65TSI7L8c5aFenUC4dJV5ZRm/Dr+FfDawgqvMLsrIfz8/5vvbkfj0DDp4hxHilfs2gdgUJLzAu/AkAyZj56I8sJ/2DK+e0xRivwDNcNepp7ZbgUTgQSZGl8cNH3gqWmd3CG4MYLrHXZC0vrnNdAhU+lqFcvN3w4TSB/";
    
//    NSString *partner = @"2088221353698177";
//    NSString *seller = @"zucheyun@b-car.cn";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALTC/6PbrpCw2IK5pNFwfJ9xmR5tpRkbcLcGHbuu0mB9cBeK5mzvGiCSQp1SYXaaNIsffA1wkKtuwTD2KXYraG1wh2bYNb8WtBTUtwJxLEHaPtMV9/uBrbqDfOtddp96KR+GnQEAF/6HkKsMfxf8mHzfrBv2kyQCbhiAVBrx6PzdAgMBAAECgYB+aYBuD0vdVE+V3E4vSgNdXgw/A17aWB5TYKuafYASiqbBUBolRHF5JdAARYRzdRQZ10LiAz6pJSNmIkCMq36zHXK6WakLn4iNmxKYuwkCvz0Jmk1EBurBIvrcmlESW1IPTp/EFVoD/6m4q133d3XsxjlVUCGZ5AFKX9+9eVWd4QJBANv8D9Af2zzPzhXyIQ4ajQnnC8yHaTWGTFHRk/+Nn114dpZNEfXZNs3Pog4I6epz+VgSw2du/0Dyafgmn2kmKoMCQQDSWwljq7BqYSRcuqvHPjmSRtaSo9WdQ5TnYW9J/mDgByfAMRYFeX0Xpls7BHDjo+MK+7jvth4zUpSnIeyJUx0fAkEAg/dzOQRTTejPlaS6Ja7R2xXqoxi8iap2EEMsiIraBoWkhkfXtWdIFDEx4z9/q/FErIwdAui4YarK3V22FasapwJBAIlLwAIc8mVMiCY59Jpz47G0qKJHaspdbNfkgXXDIUm3gdtwblYeaGZCPzNy/5ekxTDLAXb74BRRZxL7El7DL7MCQAN+bV2TmstYA7Ea2osPloAMZHuKZNhcgPr4gxMNLeWPlKjnnydY7Xg2xFvmmSfJ6Wh5et1wdpleXGeMArsx8YM=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.subject = _product.subject; //商品标题
    order.body = _product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",_product.price]; //商品价格
    
    order.notifyURL =[NSString stringWithFormat:@"%@/api/alipay/notify",Host];; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"GJCAR.COM";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
         
            NSLog(@"reslut = %@",resultDic);

            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]isEqualToString:@"9000"])
                
            {
                
                [self presentView];

            }

        }];

    }
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"短租自驾下单成功"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"短租自驾下单成功"];
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
