//
//  DBChangePhoneViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBChangePhoneViewController.h"

@interface DBChangePhoneViewController ()

@property (nonatomic,strong)UIView *tipView;
@end

@implementation DBChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    [self createUI];
    
}
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"修改联系电话" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)createUI
{
    //账号输入框
    userNameField = [[DBTextField alloc]initWithFrame:CGRectMake(25, 120, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
    //    userNameField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    
    userNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    
    
    userNameField.field.placeholder = @"请输入手机号";
    [userNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [userNameField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    userNameField.field.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:userNameField];
    
    
    //验证码输入框
    ValidateField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame)+15, ScreenWidth-50, 40*ScreenHeight/667) withValiBt:@"获取验证码"];
    //    ValidateField.layer.cornerRadius = 5;
    //    ValidateField.layer.borderWidth = 1;
    //    ValidateField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    
    
    ValidateField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    
    
    ValidateField.field.placeholder = @"请输入验证码";
    [ValidateField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [ValidateField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    ValidateField.field.keyboardType =UIKeyboardTypeNumberPad;
    [ValidateField.button addTarget:self action:@selector(ValidateBt) forControlEvents:UIControlEventTouchUpInside];
    [ValidateField.button.titleLabel setFont:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth]];
    
    [self.view addSubview:ValidateField];
    
    //下一步按钮
    UIButton * nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBt.frame = CGRectMake(25, CGRectGetMaxY(ValidateField.frame)+15, ScreenWidth-50,40*ScreenHeight/667);
    nextBt.layer.cornerRadius = 5;
    nextBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [nextBt setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBt.titleLabel.font = [UIFont systemFontOfSize:19 / 320.0 *ScreenWidth];
    [nextBt addTarget:self action:@selector(nextBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBt];
    
}

//点击获取验证码
-(void)ValidateBt
{
    
    NSLog(@"正在获取验证码------");
    [self.tipView removeFromSuperview];
    [self.view endEditing:YES];
    
    userNameField.field.text =  [userNameField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";

    NSString *CT = @"^1(3|5|8|7)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  // 小灵通
      NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  // 电信
    
    if(userNameField.field.text.length == 0)
    {
        
        [self tipShow:@"手机号不能为空"];
        
    }else if (([regextestmobile evaluateWithObject:userNameField.field.text] == YES)
                           || ([regextestct evaluateWithObject:userNameField.field.text] == YES) )
    {
        
        
        //判断用户是否已经注册
        
        
        NSString * useUrl = [NSString stringWithFormat:@"%@/api/register/%@",Host,userNameField.field.text];
        
        
        
        //            NSString * useUrl = [NSString stringWithFormat:@"http://www.rental.hpecar.com/api/register/%@",userNameField.field.text];
        
        
        [DBNetworkTool Get:useUrl parameters:nil success:^(id responseObject)
         {
             if ([[responseObject objectForKey:@"registered"]isEqualToString:@"true"])
             {
                 [self.tipView removeFromSuperview];
                 [self tipShow:@"手机号已被注册"];

                 
             }
             
             else if ([[responseObject objectForKey:@"registered"]isEqualToString:@"false"])
             {
                 [self getValidate];
                 
             }
             
         } failure:^(NSError *error) {
             
             [self.tipView removeFromSuperview];
             //             [self tipShow:@"请检查网络是否可用"];
             
         }];
        
    }
    
    
    else
    {
        [self.tipView removeFromSuperview];
        
        //        [self tipShow:@"请输入正确的手机号"];
        
    }
    
    
}

#pragma mark 获取验证码

//获取验证码
-(void)getValidate
{
    
    // 倒计时
    ValidateField.button.userInteractionEnabled = NO;
    
    ValidateField.valiLabel.hidden =NO;
    ValidateField.valiLabel.layer.cornerRadius = 5;
    ValidateField.layer.masksToBounds = YES;
    
    time = 120;
    ValidateField.valiLabel.text = [NSString stringWithFormat:@"(%ld)秒", (long)time];
    
    // 计时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    
    
    NSMutableDictionary *parDic = [NSMutableDictionary dictionary];
    parDic[@"target"] = userNameField.field.text;
    parDic[@"channel"]= @"sms";
    parDic[@"purpose"] =@"resetpwd";
    
    
    NSString *url  =[NSString stringWithFormat:@"%@/api/verify",Host];
    
    //    NSString * url = @"http://www.rental.hpecar.com/api/verify";
    
    
    [DBNetworkTool codeValidatePOST:url parameters:parDic success:^(id responseObject)
     {
         
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
         {
             [self.tipView removeFromSuperview];
             [self tipShow:[responseObject objectForKey:@"message"]];
         }
         
     } failure:^(NSError *error) {
         
         [self.tipView removeFromSuperview];
         [self tipShow:@"请检查网络是否可用"];
         
     }];
    //
    
}

//验证码开始计数
-(void)showTime
{
    
    if(time != 0 /*&& userNameField.field.text.length == 11*/) {
        
        time--;
        ValidateField.valiLabel.text = [NSString stringWithFormat:@"(%ld)秒", (long)time];
        
    }else {
        
        ValidateField.button.userInteractionEnabled = YES;
        [ValidateField.button setTitle:@"再次获取" forState:UIControlStateNormal];
        ValidateField.valiLabel.hidden = YES;
        [timer invalidate];
        timer = nil;
    }
}

//下一步
-(void)nextBt
{
    NSLog(@"下一步点击了");
    [self.view endEditing:YES];
    [self.tipView removeFromSuperview];
    
    if(ValidateField.field.text.length == 6)
    {
        
        self.view.userInteractionEnabled = NO ;
        
        //        NSString * url = @"http://www.rental.hpecar.com/api/verify";
        
        NSString *url  = [NSString stringWithFormat:@"%@/api/verify",Host];
        
        NSMutableDictionary * parDic = [ NSMutableDictionary dictionary];
        
        parDic[@"code"]= ValidateField.field.text ;
        parDic[@"phone"] = userNameField.field.text ;
        
        DBNetworkTool *net = [[DBNetworkTool alloc]init];
        
        [net verifyCodePUT:url parameters:parDic];
        
        net.verifyCodeBlock = ^(NSDictionary *dic)
        {
            if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
            {
                
                self.view.userInteractionEnabled = YES ;
                
                
                NSLog(@"%@",dic);
                
                
                             time = 0;
                
                //                [UIView animateWithDuration:2 animations:^{
                //
                //                    [self tipView:ScreenHeight * 0.8 withTipmessage:[dic objectForKey:@"message"]];
                //                    NSLog(@"11111111%@",dic);
                //
                //                } completion:^(BOOL finished) {
                //
                //                    // 返回登录界面
                //                    [self.navigationController popToRootViewControllerAnimated:YES];
                //
                //                }];
            }
            else
            {
                self.view.userInteractionEnabled = YES ;
                [self.tipView removeFromSuperview];
                [self tipShow:[dic objectForKey:@"message"]];
            }
            
        };
        
    }
    else
    {
        [self.tipView removeFromSuperview];
        //        [self tipShow:@"请输入正确的验证码"];
        self.view.userInteractionEnabled = YES ;
    }
    
    
}

//设置提示框
- (void)tipShow:(NSString *)str {
    
    [UIView animateWithDuration:2 animations:^{
        
        [self tipView:ScreenHeight * 0.8 withTipmessage:str];
        
    } completion:^(BOOL finished) {
        
        [self.tipView removeFromSuperview];
        
    }];
}


//输入号码错误显示提示框
- (void)tipView:(CGFloat)tipviewY withTipmessage:(NSString *)messageStr {
    
    NSString *str = messageStr;
    NSMutableDictionary *attDic = [[NSMutableDictionary alloc] init];
    attDic[NSFontAttributeName] = [UIFont systemFontOfSize:15 / 320.0 * ScreenWidth];
    attDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    CGRect strRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil];
    
    CGFloat tipViewW = strRect.size.width + 30;
    CGFloat tipViewH = ScreenHeight * 0.0625;
    CGFloat tipViewX = (ScreenWidth - tipViewW) / 2.0;
    CGFloat tipViewY = tipviewY;
    self.tipView = [[UIView alloc] initWithFrame:CGRectMake(tipViewX, tipViewY, tipViewW, tipViewH)];
    self.tipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.tipView.layer.cornerRadius = 7.5;
    [self.view addSubview:self.tipView];
    
    CGFloat msgLabW = tipViewW;
    CGFloat msgLabH = tipViewH;
    CGFloat msgLabX = 0;
    CGFloat msgLabY = 0;
    UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(msgLabX, msgLabY, msgLabW, msgLabH)];
    msgLab.text = messageStr;
    [self.tipView addSubview:msgLab];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.font = [UIFont systemFontOfSize:15 / 320.0 * ScreenWidth];
    msgLab.textColor = [UIColor whiteColor];
    
}

//返回按钮点击
-(void)back
{
    //个人信息
    //    DBUserInfoViewController * user = [[DBUserInfoViewController alloc]init];
    //    [self.navigationController pushViewController:user animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    NSLog(@"%@ free",self);
}

//空白处键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
