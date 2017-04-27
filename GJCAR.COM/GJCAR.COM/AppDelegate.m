//
//  AppDelegate.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/24.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "AppDelegate.h"
#import "DBNetManager.h"

#import "DBNetwork.h"
//首页
#import "DBmainViewController.h"

//登录界面
#import "DBSignInViewController.h"


//相册测试
#import "DBUserViewController.h"



//跟随键盘移动测试
#import "DBLongRentInfoViewController.h"

//顺风车预定
#import "DBFreeRideViewController.h"

//支付宝
#import <AlipaySDK/AlipaySDK.h>
//百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

//测试用首页
#import "DBRootViewController.h"

//短租带驾
#import "DBSecendViewController.h"

//修改身份证
#import "DBSetCardInfoViewController.h"

#import "DBSurveillance.h"

@interface AppDelegate ()<BMKGeneralDelegate>

{
    NSDictionary *_launchDict;
    
    BMKMapManager* _mapManager;
    
    CLLocationManager * _locationManger;
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    
    //百度统计
    [self baiduMobStat];

    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"e6G2Ph7L8BxSru8AQ7cZndgliC12BeG3" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

   
    //监测是否是最新版本
    [self checkFirstVersion];
    
    //设置网络监测
    [AppDelegate netWorkStatus];
    
    //设置数据库
    [self setDBFM];
    
#pragma mark 首次激活申报
    [self activateReport];

    
    
    return YES;
}
-(void)baiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    
    [statTracker startWithAppId:@"dfbafc3372"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

#pragma mark 检测是否最新版本
-(void)checkFirstVersion
{
//分模块测试
//根视图控制器
    
    DBRootViewController * root = [[DBRootViewController alloc]init];
    
//短租代驾
  
    //DBSecendViewController * root= [[DBSecendViewController alloc]init];
    
//    root.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);

//    DBSetCardInfoViewController * car = [[DBSetCardInfoViewController alloc]init];
//    self.window.rootViewController = car;
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:root];
    nav.navigationBarHidden = YES ;
    
    self.window.rootViewController = nav;

    
//    DBFreeRideViewController * tabBar = [[DBFreeRideViewController alloc]init];
//        DBLongRentInfoViewController * tabBar = [[DBLongRentInfoViewController alloc]init];

}



#pragma mark 设置数据库

-(void)setDBFM
{
//    DBManager * manager = [DBManager shareManager];

}
#pragma mark 首次激活申报
-(void)activateReport{

    DBSurveillance * surveillance =   [[DBSurveillance alloc] init];

    [surveillance activateReport];
    

}

#pragma mark 设置网络监控
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */

    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        DBNetManager * netManager =[DBNetManager sharedManager];

        netManager.netStatu = status ;
        
        if (status != 0 ) {
        
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"netChange" object:nil];
        }
        NSLog(@"*********************************************网络状态  %ld",status);

    }];
}

//支付宝

#pragma mark ---支付宝delegate


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]isEqualToString:@"9000"])
                
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PresentView" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PopView" object:nil];
                
            }

        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
          
            
            NSLog(@"result = %@",resultDic);
            
            
            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]isEqualToString:@"9000"])
            
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PresentView" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PopView" object:nil];

            }
           
            //result = {
            //            memo = "";
            //            result = "partner=\"2088221353698177\"&seller_id=\"zucheyun@b-car.cn\"&out_trade_no=\"KW11WQBELFWEZ3Y\"&subject=\"\U79df\U8f66\U76d2\U5b50\"&body=\"\U5e03\U52a0\U8fea\U5a01\U9f99\"&total_fee=\"0.01\"&notify_url=\"http://www.xxx.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"pe4+Og1JIqFakQCLB09XHBniQ3POAGfbf1D3FditheyU8GwV1lN685HdP3boSOSldw1hEpeBuzPeg5MP22hMUCnWtmUFrXHeXxQKVUp8P7ck0EZvZy/hbacoSyGIa6zxX1BVxeqqKT08QHHGNfcz3zCebNylbiInfjbPIhVq47I=\"";
            //            resultStatus = 9000;
 
        }];
    }
    
    return YES;
}



- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock
{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
