//
//  DBActiveDetailViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/18.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBNewActiveDetailViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "DBSignInViewController.h"

@interface DBNewActiveDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UMSocialShareMenuViewDelegate>
{
    BOOL _isLogin;
}
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic)CGFloat historyY;
@property (nonatomic,strong)JSContext * context ;

@end

@implementation DBNewActiveDetailViewController

- (void)viewDidAppear:(BOOL)animated{
    
    if (_isLogin) {
        [self setUI];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSString *phone = [userDefault objectForKey:@"phone"];
//        
//        
//        NSString *textJS = [NSString stringWithFormat:@"getTel(%@)",phone];
//        //    NSString *textJS = @"shareStatus(true)";
//        [_context evaluateScript:textJS];
    }else{
        NSLog(@"没有去登录页面");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    
    [self setUI];
    

    
}


#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"精彩活动" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
}



-(void)setUI
{
    

    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:_webView];
    
    _webView.scrollView.delegate = self ;
    
    _webView.delegate = self ;
    
    self.webView.scalesPageToFit = YES;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://182.61.22.80:8082/activity/mobile/nationalDay/index.html"]]];
    
//    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"nationalDayActivity/index" ofType:@"html"];

//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathString]]];
    
    if (_url) {//清除所有cookie
        NSArray * cookArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:_url]];
        for (NSHTTPCookie*cookie in cookArray) {
            if (![cookie.name isEqualToString:@"token"]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
        }
    
       //下边返回键
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"webView location =  %@ ", webView.request.URL.absoluteString);
    
    // 打印异常,由于JS的异常信息是不会在OC中被直接打印的,所以我们在这里添加打印异常信息,
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDefault objectForKey:@"phone"];
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *textJS = [NSString stringWithFormat:@"getTel(%@)",phone];
//    NSString *textJS = @"shareStatus(true)";
    [_context evaluateScript:textJS];
    
//    NSLog(@"---%@---",[_context evaluateScript:textJS]);
    
//    self.context.exceptionHandler =
//    ^(JSContext *context, JSValue *exceptionValue)
//    {
//        context.exception = exceptionValue;
//        DBLog(@"%@", exceptionValue);
//    };
    
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *shareURL = [request.URL.absoluteString componentsSeparatedByString:@"//"].lastObject;
    if ([shareURL isEqualToString:@"share.loginAddress"]) {
        DBSignInViewController *signInVC = [[DBSignInViewController alloc]init];
        signInVC.indexControl = 5;
        _isLogin = YES;
        [self.navigationController pushViewController:signInVC animated:true];
        
        return YES;
    }else if ([shareURL isEqualToString:@"share.shareAddress"]){
        [self shareBtnClick];
        return YES;
    }
    
    NSString *url = request.URL.absoluteString;
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        //拦截链接跳转到货源圈的动态详情
        if ([url rangeOfString:@"http://m.gjcar.com"].location != NSNotFound)
        {
            //跳转到你想跳转的页面
            
            [self.navigationController popViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"navChange" object:nil];
            
            return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
        }
    }
    return YES;
}


- (void)shareBtnClick{
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        [self shareWebPageToPlatformType:platformType];
//    }];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功后请立即返回赶脚APP领取红包" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDefault objectForKey:@"phone"];
    //创建网页内容对象b
//    UIImage *image = [UIImage imageNamed:@""];
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"high玩国庆" descr:[NSString stringWithFormat:@"国庆宅在家？ %@ 分享给你红包，快点出来high~",phone] thumImage:[UIImage imageNamed:@"ganjiaoLogo.png"]];
    NSString *str1 = [_webView stringByEvaluatingJavaScriptFromString:@"getAddress();"];
    NSLog(@"JS返回值 分享地址：%@",str1);
    //设置网页地址
//    shareObject.webpageUrl = @"http://www.baidu.com";
    shareObject.webpageUrl = str1;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [self performSelector:@selector(shareFail) withObject:nil afterDelay:1.0];
        }else{
            [self performSelector:@selector(shareSuccess) withObject:nil afterDelay:1.0];
//            [self shareStatus:@"true"];
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
        }
        
    }];
}


- (void)shareSuccess{
    
//    NSString *textJS = [NSString stringWithFormat:@"shareStatus(%@)",status];
    NSString *textJS = @"shareStatus(true)";
    [_context evaluateScript:textJS];
}

- (void)shareFail{
    
    //    NSString *textJS = [NSString stringWithFormat:@"shareStatus(%@)",status];
    NSString *textJS = @"shareStatus(false)";
    [_context evaluateScript:textJS];
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _webView.delegate = nil ;
    [_webView removeFromSuperview];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    NSLog(@"DBActiveDetailViewController free");
    
    _webView = nil ;
    
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
