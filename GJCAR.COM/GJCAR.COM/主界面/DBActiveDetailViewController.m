//
//  DBActiveDetailViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/18.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBActiveDetailViewController.h"



@interface DBActiveDetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic)CGFloat historyY;
//@property (nonatomic,strong)JSContext * context ;
@end

@implementation DBActiveDetailViewController

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
    
    // 打印异常,由于JS的异常信息是不会在OC中被直接打印的,所以我们在这里添加打印异常信息,
    
//    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.context.exceptionHandler =
//    ^(JSContext *context, JSValue *exceptionValue)
//    {
//        context.exception = exceptionValue;
//        DBLog(@"%@", exceptionValue);
//    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSString *url = [request.URL absoluteString];
        

        //拦截链接跳转到货源圈的动态详情
        if ([url rangeOfString:@"http://m.gjcar.com"].location != NSNotFound)
        {
            //跳转到你想跳转的页面
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"navChange" object:nil];
            
            return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
        }
    }
    return YES;
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
