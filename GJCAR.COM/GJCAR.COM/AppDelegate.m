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

//极光
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "DBJPUSHData.h"

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

// 友盟分享
#import <UMSocialCore/UMSocialCore.h>



@interface AppDelegate ()<BMKGeneralDelegate,JPUSHRegisterDelegate>

{
    NSDictionary *_launchDict;
    
    BMKMapManager* _mapManager;
    
    CLLocationManager * _locationManger;
    
}
@property (strong , nonatomic)  DBJPUSHData * pushdata;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    
    //百度统计
    [self baiduMobStat];
    
    //推送设置
    [self setJPushOptions:launchOptions];
    
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

    // 友盟
    [self runUMengSdk];
    
    return YES;
}

#pragma mark - 友盟分享
- (void)runUMengSdk {
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1c969569e3fce1c1" appSecret:@"3d4945a2fb14e5971353594855418bd1" redirectURL:nil];
    
    
    
}

-(void)baiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    
    [statTracker startWithAppId:@"dfbafc3372"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

-(void)setJPushOptions:(NSDictionary *)launchOptions{
    
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    //        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    //        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //#endif
    //    } else
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //6f93f92777938b23e5bcba49
    [JPUSHService setupWithOption:launchOptions appKey:@"a267bfd16979f6bea6e92208"
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //4056475cb550c79f2f30d95b
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    
    _pushdata = [DBJPUSHData shareDBJPUSHData];
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
            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]isEqualToString:@"9000"]){
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PresentView" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PopView" object:nil];
            }
           
            //result = {
            //            memo = "";
            //            result = "partner=\"2088221353698177\"&seller_id=\"zucheyun@b-car.cn\"&out_trade_no=\"KW11WQBELFWEZ3Y\"&subject=\"\U79df\U8f66\U76d2\U5b50\"&body=\"\U5e03\U52a0\U8fea\U5a01\U9f99\"&total_fee=\"0.01\"&notify_url=\"http://www.xxx.com\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"pe4+Og1JIqFakQCLB09XHBniQ3POAGfbf1D3FditheyU8GwV1lN685HdP3boSOSldw1hEpeBuzPeg5MP22hMUCnWtmUFrXHeXxQKVUp8P7ck0EZvZy/hbacoSyGIa6zxX1BVxeqqKT08QHHGNfcz3zCebNylbiInfjbPIhVq47I=\"";
            //            resultStatus = 9000;
        }];
    }
    else if ([url.host isEqualToString:@"platformId=wechat"]){
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    NSLog(@"openURLurl---%@---url.host-%@",url,url.host);
    return YES;
}



- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock{
    
    
}







#pragma mark ----推送相关设置
- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark- JPUSHRegisterDelegate
#pragma mark ----接收推送消息

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 取得 APNs 标准信息内容
    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"];                 // 推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];    // badge数量
    //    NSString *sound = [aps valueForKey:@"sound"];                   // 播放的声音
    //
    //    // 取得Extras字段内容
    //    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"];  // 服务端中Extras字段，key是自己定义的
    //    NSLog(@"\nAppDelegate:\ncontent =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    
    [self getCurrentVC:userInfo];
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    NSLog(@"iOS7及以上系统，收到通知");
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState==0) {
        
        NSLog(@"iOS7及以上系统，前台 %@",userInfo);
    }
    else{
        NSLog(@"iOS7及以上系统，后台 %@",userInfo);
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (UIViewController *)getCurrentVC:(NSDictionary*)dic{
    
    NSString * message = [[dic objectForKey:@"aps"]objectForKey:@"alert"];
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
        NSLog(@"当前控制器%@",result);
    }
    else{
        result = window.rootViewController;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"收到新的推送" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadOrder" object:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [result presentViewController:alertController animated:YES completion:nil];
    
    NSLog(@"%@",result);
    return result;
    
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
