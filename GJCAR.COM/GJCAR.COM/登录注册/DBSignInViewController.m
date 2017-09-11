//
//  DBSignInViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/6.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSignInViewController.h"


//注册页面头文件
#import "DBSignUpViewController.h"

//忘记密码
#import "DBForgetPwViewController.h"

//  订单信息
#import "DBOrderServeViewController.h"

//顺风车订单
#import "DBFreeRideViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"

@interface DBSignInViewController ()

{
    DBProgressAnimation * _progress;
}

@property (nonatomic,strong)UIView *tipView;


@end

@implementation DBSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CreateUI];
    
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


#pragma mark 创建UI界面
//创建UI界面
-(void)CreateUI
{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //设置logo图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - (117 * ScreenWidth / 320)/2, 80, 117 * ScreenWidth / 320 , 42 * ScreenWidth / 320)];
    imageView.image = [UIImage imageNamed:@"LOGO"];
    [self.view addSubview:imageView];
    
    

    //账号输入框
    userNameField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(imageView.frame)+60, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
    userNameField.layer.cornerRadius = 5;
//    userNameField.layer.borderWidth = 1;
//    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    userNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    userNameField.field.placeholder = @"请输入手机号";
    
    [userNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [userNameField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    userNameField.field.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:userNameField];	
    
    
    
    //密码输入
    passWordField =[[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame)+10, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
//    passWordField =[[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame)+10, ScreenWidth-50, 40*ScreenHeight/667) withLeftImage:nil withButtonImage:nil withButtonHighImage:nil];

    passWordField.layer.cornerRadius = 5;

    passWordField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

//    passWordField.button.frame = CGRectMake(passWordField.frame.size.width- 40,passWordField.frame.size.height/4,passWordField.frame.size.height/2*11/8,passWordField.frame.size.height/2);
//    
    
    passWordField.field.placeholder = @"请输入密码";
    [passWordField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passWordField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    passWordField.field.keyboardType = UIKeyboardTypeASCIICapable;
//    passWordField.field.clearButtonMode = 0;
    
    passWordField.field.secureTextEntry = YES;
    [passWordField.button addTarget:self action:@selector(passWordShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passWordField];
    
    
    
    //登录按钮
    UIButton * signInBt = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBt.frame = CGRectMake(25, CGRectGetMaxY(passWordField.frame)+20, ScreenWidth-50,40*ScreenHeight/667);
    signInBt.layer.cornerRadius = 5;
    signInBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [signInBt setTitle:@"登录" forState:UIControlStateNormal];
    [signInBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signInBt.titleLabel.font = [UIFont systemFontOfSize:19 / 320.0 *ScreenWidth];
    [signInBt addTarget:self action:@selector(SignInBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBt];
    
    
    
    //忘记密码
    UIButton *forgetBt = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBt.frame = CGRectMake(ScreenWidth/2 - ScreenWidth*0.15, CGRectGetMaxY(signInBt.frame)+10, ScreenWidth*0.3, 20);
    forgetBt.titleLabel.textAlignment = 1;
    forgetBt.titleLabel.font = [UIFont systemFontOfSize:14 / 320.0 * ScreenWidth];
    [forgetBt addTarget:self action:@selector(forgetBt) forControlEvents:UIControlEventTouchUpInside];
    [forgetBt setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBt setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.77 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:forgetBt];

    
    //注册按钮
    UIButton * signUpBt = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBt.frame = CGRectMake(25, CGRectGetMaxY(forgetBt.frame)+20, ScreenWidth-50,40*ScreenHeight/667);
    signUpBt.layer.cornerRadius = 5;
    signUpBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [signUpBt setTitle:@"注册" forState:UIControlStateNormal];
    [signUpBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpBt.titleLabel.font = [UIFont systemFontOfSize:19 / 320.0 *ScreenWidth];
    [signUpBt addTarget:self action:@selector(signUpBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpBt];

    
    //返回按钮
    UIButton * backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    backBt.frame = CGRectMake(25, CGRectGetMaxY(signUpBt.frame)+20, ScreenWidth-50,40*ScreenHeight/667);
    backBt.layer.cornerRadius = 5;
    backBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [backBt setTitle:@"取消" forState:UIControlStateNormal];
    [backBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBt.titleLabel.font = [UIFont systemFontOfSize:19 / 320.0 *ScreenWidth];
    [backBt addTarget:self action:@selector(closeBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBt];

    
}


-(void)closeBt
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    
//    if (self.indexControl == 0)
//    {
//        
//        //跳转到制定控制器
//        
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            
//            if ([controller isKindOfClass:[DBNewRentalPackViewController class]]) {
//                
//                [self.navigationController popToViewController:controller animated:YES];
//                
//            }
//            
//        }
//        
//    }
//    
//    else if (self.indexControl == 1)
//    {
//        
////        跳转到制定控制器
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            
//            if ([controller isKindOfClass:[DBStoreInfoViewController class]]) {
//                
//                [self.navigationController popToViewController:controller animated:YES];
//                
//            }
//        }
//        
//    }
//    
//    else
//    {
//        NSLog(@"%ld",self.navigationController.viewControllers.count);
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
}

//是否显示密码
-(void)passWordShow
{
    if (passWordField.field.secureTextEntry == YES)
    {
        passWordField.field.secureTextEntry = NO;
        [passWordField.button setImage:[UIImage imageNamed:@"password-1"] forState:UIControlStateNormal];
    }
    else
    {
        passWordField.field.secureTextEntry =YES;
        [passWordField.button setImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
    }
}

//忘记密码按钮点击
-(void)forgetBt
{
    NSLog(@"忘记密码");
    DBForgetPwViewController *forgetPw = [[DBForgetPwViewController alloc]init];
    [self.navigationController pushViewController:forgetPw animated:YES];
}

//登录点击
-(void)SignInBt:(UIButton*)button
{
    
    NSLog(@"登录按钮点击");
    [self.view endEditing:YES];
    [self.tipView removeFromSuperview];
    
    userNameField.field.text =  [userNameField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CT = @"^1(3|5|8|7)\\d{9}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  // 小灵通
       NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  // 电信
    
    if(userNameField.field.text.length == 0)
    {
        
    }
    
    else if(([regextestmobile evaluateWithObject:userNameField.field.text] == NO)
                       && ([regextestct evaluateWithObject:userNameField.field.text] == NO)
           )
    {
        [self tipShow:@"请输入正确的手机号"];
    }
    
    else if(passWordField.field.text.length == 0)
        
    {
        [self tipShow:@"密码不能为空"];
    }
    
    else
        
    {
//        发送至服务器
        [self loadData:button];
    }
    
}


#pragma mark  登录成功跳转页面
//加载数据
-(void)loadData:(UIButton*)button
{
    [self.tipView removeFromSuperview];

    NSString *url =[NSString stringWithFormat:@"%@/api/login",Host];
    
    //    NSString * url = @"http://www.rental.hpecar.com/api/login";
    
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    
    
    NSString * PW = [DBNetworkTool md5Digest:passWordField.field.text];
    parDic[@"password"] = PW;
    NSLog(@"%@",userNameField.field.text);
    NSLog(@"%@",PW);
    parDic[@"phone"] = userNameField.field.text;
    
    //    parDic[@"agent"] = @"android";
    
    //    NSLog(@"密码是%@",passWordField.field.text);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    
    //关闭用户交互

    
    button.userInteractionEnabled = NO ;
    
    [self addProgress];
    [DBNetworkTool signInPOST:url parameters:parDic success:^(id responseObject) {
        
        button.userInteractionEnabled = YES ;
        
        NSLog(@"提交成功");
        
        NSLog(@"%@",responseObject);
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            [self tipShow:@"登录成功"];
            
            // 获取token 针对个人的操作要加
            
            
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage]; // 获得响应头
         
            
            NSHTTPCookie *cookie;
            
            
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [cookieJar cookiesForURL:[NSURL URLWithString:Host]])
            {
                if ([[cookie name] isEqualToString:@"token"]) { // 获取响应头数组对象里地名字为token的对象

                    NSLog(@"############%@", [NSString stringWithFormat:@"%@=%@",[cookie name],[cookie value]]);
                    //获取响应头数组对象里地名字为token的对象的数据，这个数据是用来验证用户身份相当于“key”
                    
                    ////保存个人信息
                    //        //登录成功后保存账号密码
                    //
                    //
                    [user setObject:[[responseObject objectForKey:@"message"]objectForKey:@"nickName"] forKey:@"nickName"];
                    [user setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"message"]objectForKey:@"uid"]] forKey:@"userId"];
                    
                    [user setObject:[NSString stringWithFormat:@"%@=%@",[cookie name],[cookie value]] forKey:@"token"];
                    NSLog(@"11111111111%@",[NSString stringWithFormat:@"%@=%@",[cookie name],[cookie value]]);
     
                }
                
                DBManager * manager = [DBManager shareManager];
                
                NSDictionary * dic = [manager searchWithUserId:[[responseObject objectForKey:@"message"]objectForKey:@"uid"]];
                
                if ([dic objectForKey:@"userName"] == nil)
                {
                    [manager addUserValueUserid:[[responseObject objectForKey:@"message"]objectForKey:@"uid"] WithUserName:userNameField.field.text andPaw:passWordField.field.text andToken:[NSString stringWithFormat:@"%@=%@",[cookie name],[cookie value]]];
                    
                }
                [JPUSHService setAlias:userNameField.field.text callbackSelector:nil object:nil];
                [user setObject:userNameField.field.text forKey:@"phone"];
                [user setObject:passWordField.field.text forKey:@"password"];
  
            }
            NSLog(@"####################################\n---%@--",[cookieJar cookies]); // 获取响应头的数组
            
            //           for (int i = 0; i < [cookieJar cookies].count; i++) {
            
//            NSHTTPCookie *cookie = [[cookieJar cookiesForURL:[NSURL URLWithString:Host]]lastObject];
            
//            NSHTTPCookie *cookie = [[cookieJar cookies]firstObject]; // 实例化响应头数组对象
            
            NSLog(@"%ld",[cookieJar cookies].count);
            
            //跳转到信息页面

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                // 1秒后异步执行这里的代码...
                
                //自驾		
                self.view.userInteractionEnabled = YES ;
                
                if (self.indexControl == 0)
                    
                {
                    DBOrderServeViewController * order = [[DBOrderServeViewController alloc]init];
                    
                    order.model =self.model;
                    order.activityDic = self.activityDic ;

                    
                    [self.navigationController pushViewController:order animated:YES];
                    
                    return ;
                }
                
                //顺风车
                else if (self.indexControl == 1)
                {
                    DBFreeRideViewController * order = [[DBFreeRideViewController alloc]init];
                    
                    order.model =self.FreeRideModel;
                    
                    [self.navigationController pushViewController:order animated:YES];
                    
                }
                else 
//
                {
                
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        }
        else
        {
            [self tipShow:@"账户或密码错误"];
        }
        
    } failure:^(NSError *error)
     {

         button.userInteractionEnabled = YES ;
         [self tipShow:@"请检查网络是否可用"];
         [self removeProgress];
         
     }];
    
}




//注册页面
-(void)signUpBt
{
    
    DBSignUpViewController * sigUp = [[DBSignUpViewController alloc]init];
    
    
    sigUp.signInblock = ^(NSString * userName , NSString * paw)
    {
        userNameField.field.text = userName ;
        passWordField.field.text = paw;
       
        [self loadData:nil];
        
    };
    
    [self.navigationController pushViewController:sigUp animated:YES];
    
}

//取消按钮
-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"登录页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"登录页面"];

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
