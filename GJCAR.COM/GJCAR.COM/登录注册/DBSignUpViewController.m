//
//  DBSignUpViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//


#import "DBSignUpViewController.h"

#import "DBSurveillance.h"

@interface DBSignUpViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *tipView;


@end

@implementation DBSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];

    [self createUI];
}

-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"注册" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    

    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, ScreenWidth , 0.5)];
    lineView.backgroundColor = [DBcommonUtils getColor:@"9e9e9f"];
    
}

-(void)createUI
{
    

    
    
    //账号输入框
    userNameField = [[DBTextField alloc]initWithFrame:CGRectMake(25, 120, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
//    userNameField.layer.cornerRadius = 5;
//    userNameField.layer.borderWidth = 1;

    userNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    userNameField.field.delegate = self ;
//    userNameField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    userNameField.field.placeholder = @"请输入手机号";
    [userNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [userNameField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    
    userNameField.field.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:userNameField];
    
    
    //验证码输入框
    ValidateField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame)+15, ScreenWidth-50, 40*ScreenHeight/667) withValiBt:@"获取验证码"];
//    ValidateField.layer.cornerRadius = 5;
//    ValidateField.layer.borderWidth = 1;
    
    ValidateField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    
//    ValidateField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    ValidateField.field.placeholder = @"请输入验证码";
    [ValidateField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

    [ValidateField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    ValidateField.field.keyboardType = UIKeyboardTypeNumberPad;
    [ValidateField.button addTarget:self action:@selector(ValidateBt) forControlEvents:UIControlEventTouchUpInside];
    ValidateField.button.titleLabel.font = [UIFont systemFontOfSize:15 / 320.0 *ScreenWidth];
    ValidateField.valiLabel.layer.cornerRadius =5 ;
    
    [self.view addSubview:ValidateField];
    
    
    //请输入框
    newPwField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(ValidateField.frame)+15, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
//    newPwField.layer.cornerRadius = 5 ;
//    newPwField.layer.borderWidth = 1;
 

    newPwField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

    newPwField.field.secureTextEntry = YES;
//    newPwField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    
    newPwField.field.placeholder = @"请输入密码";
    [newPwField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [newPwField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    newPwField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:newPwField];
//
    //提交按钮
    UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBt.frame = CGRectMake(25, CGRectGetMaxY(newPwField.frame)+15, ScreenWidth-50,40*ScreenHeight/667);
    submitBt.layer.cornerRadius = 5 ;
    
    submitBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    
    [submitBt setTitle:@"注册" forState:UIControlStateNormal];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBt.titleLabel.font = [UIFont systemFontOfSize:19 / 320.0 *ScreenWidth];
    [submitBt addTarget:self action:@selector(submitBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBt];
    
    
    

}

#pragma mark 获取验证码
//点击获取验证码
-(void)ValidateBt
{

    [self.tipView removeFromSuperview];
    [self.view endEditing:YES];
    
    userNameField.field.text =  [userNameField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1(3|5|8|7)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  // 小灵通
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];  // 移动
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];  // 灵通
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  // 电信
    
    if(userNameField.field.text.length == 0)
    {
        
//        self.tipView = [DBTipView alloc]initWithHeight:<#(CGFloat)#> WithMessage:<#(NSString *)#> withViewController:<#(UIViewController *)#> withShowTimw:<#(CGFloat)#>
//        
        
//        [self.tipView removeFromSuperview];
        [self tipShow:@"手机号不能为空"];
    }
    else if (([regextestmobile evaluateWithObject:userNameField.field.text] == YES)
           
              || ([regextestct evaluateWithObject:userNameField.field.text] == YES)
             )
    {
        
        //调用获取验证码
        [self getValidate];
    }
    else
    {
//        [self.tipView removeFromSuperview];
        [self tipShow:@"请输入正确的手机号"];
    }
}

//获取验证码
-(void)getValidate
{
    //判断用户是否已经注册
     [self.tipView removeFromSuperview];
    
        NSString * useUrl = [NSString stringWithFormat:@"%@/api/register/%@",Host,userNameField.field.text];

     __weak typeof(self)weak_self = self ;
    [DBNetworkTool Get:useUrl parameters:nil success:^(id responseObject)
     {
         if ([[responseObject objectForKey:@"registered"]isEqualToString:@"true"])
         {
             [weak_self.tipView removeFromSuperview];
             [weak_self tipShow:@"用户已经存在"];
             
         }

         else if ([[responseObject objectForKey:@"registered"]isEqualToString:@"false"])
         {
    
             // 倒计时
             ValidateField.button.userInteractionEnabled = NO;
             ValidateField.valiLabel.hidden =NO;
             ValidateField.valiLabel.layer.cornerRadius =20*ScreenWidth/667;
             ValidateField.layer.masksToBounds = YES;
             
             time = 120;
             ValidateField.valiLabel.text = [NSString stringWithFormat:@"(%ld)秒", (long)time];
             // 计时器
    
            if (timer == nil)
            {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
            }

             NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
             parDic[@"target"] = userNameField.field.text;
             parDic[@"channel"]= @"sms";
             parDic[@"purpose"] =@"register";
          
            NSString *url  =[NSString stringWithFormat:@"%@/api/verify",Host];
             
             //演示
//             NSString*url = @"http://www.rental.hpecar.com/api/verify";
    
             [DBNetworkTool codeValidatePOST:url parameters:parDic success:^(id responseObject) {
                 
                 [weak_self.tipView removeFromSuperview];
                 [weak_self tipShow:[responseObject objectForKey:@"message"]];
                 
             } failure:^(NSError *error) {
                 
                 NSLog(@"%@",error);
                 [weak_self.tipView removeFromSuperview];
                 [weak_self tipShow:@"请检查网络是否可用"];

             }];
    
         }
   
     } failure:^(NSError *error)
     {
         [self.tipView removeFromSuperview];
         [self tipShow:@"请检查网络是否可用"];
         
         NSLog(@"%@",error);
     }];
}


//验证码开始计数
-(void)showTime
{
    if(time != 0 /*&& userNameField.field.text.length == 11*/) {
        
        time--;
        ValidateField.valiLabel.text = [NSString stringWithFormat:@"(%d)秒", time];
        
    }else
    {
        ValidateField.button.userInteractionEnabled = YES;
        [ValidateField.button setTitle:@"再次获取" forState:UIControlStateNormal];
        ValidateField.valiLabel.hidden = YES;
        [timer invalidate];
         timer = nil;
    }
}

//返回按钮
-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}

//是否显示密码
-(void)passWordShow
{
    if (newPwField.field.secureTextEntry == YES)
    {
        newPwField.field.secureTextEntry = NO;
        [newPwField.button setImage:[UIImage imageNamed:@"password-1"] forState:UIControlStateNormal];
    }
    else
    {
        newPwField.field.secureTextEntry =YES;
        [newPwField.button setImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
    }
}

#pragma mark 点击提交

//注册提交按钮
-(void)submitBt
{
    [self.view endEditing:YES];
    NSLog(@"下一步点击");
    
    [self.tipView removeFromSuperview];
    
    userNameField.field.text =  [userNameField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CT = @"^1(3|5|8|7)\\d{9}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  // 小灵通
       NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  // 电信
    
    NSString * pwdStr = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$";
    NSPredicate *regextestPwdStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdStr];
    
    if(userNameField.field.text.length == 0)
    {
        
//        [self.tipView removeFromSuperview];
        [self tipShow:@"手机号不能为空"];
        
    }
    else if(([regextestmobile evaluateWithObject:userNameField.field.text] == NO)
           
            && ([regextestct evaluateWithObject:userNameField.field.text] == NO)
          )
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"请输入正确的手机号"];
        
    }
    
    else if(ValidateField.field.text.length != 6)
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"请输入正确的验证码"];
        
    }
    
    //    else if (![newPwField.field.text isEqualToString:newPwAgField.field.text])
    //    {
    //
    //        [self tipShow:@"两次输入不一致,请重新输入"];
    //    }
    
    else if(![regextestPwdStr evaluateWithObject:newPwField.field.text])
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"密码由“8~18位字母、数字组合"];
        newPwField.field.text = @"";
    }
    
    else
        
    {
        NSString * submitUrl = [NSString stringWithFormat:@"%@/api/register?registerWay=5",Host];

//        NSString * submitUrl = @"http://www.rental.hpecar.com/api/register";
        
        NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
        
        NSString * PW = [DBNetworkTool md5Digest:newPwField.field.text];
        
        parDic[@"password"] = PW;
        
        NSLog(@"%@",PW);
        
        parDic[@"phone"] = userNameField.field.text;
        parDic[@"code"] = ValidateField.field.text;
//        parDic[@""] =@"5";
        
        NSLog(@"%@",ValidateField.field.text);
    
        
        
//        UIWebView * webView = [[UIWebView alloc]init];
//        NSURL *url = [NSURL URLWithString: submitUrl];
//        NSString *body = [NSString stringWithFormat: @"password=%@&phone=%@&code=%@",PW,userNameField.field.text,ValidateField.field.text];
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
//        [request setHTTPMethod: @"POST"];
//        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
//        [self.view addSubview:webView];
//        [webView loadRequest: request];

        
        
        

        [DBNetworkTool verifyPost:submitUrl parameters:parDic success:^(id responseObject)
         {
             NSLog(@"%@",responseObject);
            
             if ([[responseObject allKeys] containsObject:@"uid"])
             {
                 NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                 [user setObject:userNameField.field.text forKey:@"userName"];
                 [user setObject:newPwField.field.text forKey:@"password"];
                 [user setObject:[responseObject objectForKey:@"uid"] forKey:@"userId"];
                 [UIView animateWithDuration:2 animations:^{
                
                     [self tipShow:@"注册成功"];
                     
                     DBSurveillance * surveillance =   [[DBSurveillance alloc] init];
                     
                     [surveillance registerReport];
                     
                 } completion:^(BOOL finished) {
                     
                     self.signInblock(userNameField.field.text,newPwField.field.text);

                     // 返回登录界面
                     [self.navigationController popViewControllerAnimated:YES];

                 }];
                 time = 0;
             }
             else
             {
                 
                 if ([[responseObject objectForKey:@"message"]isKindOfClass:[NSNull class]]) {
                     [self tipShow:@"内部错误"];

                 }
                 else{
                     [self tipShow:[responseObject objectForKey:@"message"]];
                 }
                 DBLog(@"%@",[responseObject objectForKey:@"message"]);
                 
                 
                 
                 
//
                              }
         } failure:^(NSError *error) {
             NSLog(@"%@",error);
//             [self.tipView removeFromSuperview];
             [self tipShow:@"请检查网络是否可用"];
         }];
    }
}

/**
 *  提交注册
 */

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == userNameField.field)
    {
        
        
//        if (![ValidateField.button.titleLabel.text isEqualToString:@"获取验证码 "])
//        {

            ValidateField.button.userInteractionEnabled = YES;
//            [ValidateField.button setTitle:@"再次获取" forState:UIControlStateNormal];
            ValidateField.valiLabel.hidden = YES;
            [timer invalidate];
            timer = nil;
//        }
        
       
    }

    
    return YES;
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


//空白处键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}


- (void)tipShow:(NSString *)str
{
     self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
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
