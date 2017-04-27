//
//  DBVipLvlViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/5.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBVipLvlViewController.h"
#import "DBUserInfoModel.h"
#import "DBExplainView.h"
@interface DBVipLvlViewController ()<UIScrollViewDelegate>

{
    NSDictionary * _userInfoDic ;
    DBUserInfoModel * _userInfo ;
    
}

@end

@implementation DBVipLvlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavigation];

    [self loadUserInfo];
    
}

#pragma mark 加载个人信息
//加载个人信息
-(void)loadUserInfo
{
    _userInfoDic = [NSDictionary dictionary];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * url = [NSString stringWithFormat:@"%@/api/me",Host];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _userInfoDic = [responseObject objectForKey:@"message"];
            _userInfo = [[DBUserInfoModel alloc]initWithDictionary:[responseObject objectForKey:@"message"] error:nil];
     
            [self performSelectorOnMainThread:@selector(createUI) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
   
        NSLog(@"%@",error);
    }];
}




#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"会员等级" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --创建界面
-(void)createUI
{
    
    DBExplainView * explainView = [[DBExplainView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth,225) withData:_userInfo];
    [self.view addSubview:explainView];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(explainView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(explainView.frame))];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"level" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    [self.view addSubview:webView];

    
    

}

-(void)config
{
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    NSLog(@"%@ free",self);
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"会员等级页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"会员等级页面"];
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
