//
//  DBResetViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.

#import "DBResetViewController.h"
#import "DBSignInViewController.h"


@interface DBResetViewController ()
@property (nonatomic,strong)UIView *tipView;


@end

@implementation DBResetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigation];
    [self createUI];
}


-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"重置密码" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)createUI
{
    //请输入框
    newPwField = [[DBTextField alloc]initWithFrame:CGRectMake(25, 120, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
    newPwField.layer.cornerRadius = 5;
//    newPwField.layer.borderWidth = 1;
    newPwField.field.secureTextEntry = YES;
//    newPwField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    
    newPwAgField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

    
    newPwField.field.placeholder = @"请输入新密码";
    [newPwField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [newPwField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    newPwAgField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:newPwField];
    
    //请输入框
    newPwAgField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(newPwField.frame)+15, ScreenWidth-50, 40*ScreenHeight/667) withImage:nil];
    newPwAgField.layer.cornerRadius = 5;
//    newPwAgField.layer.borderWidth = 1;
    newPwAgField.field.secureTextEntry = YES;
    
//    newPwAgField.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
   
    newPwAgField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

    
    newPwAgField.field.placeholder = @"再次输入密码";
    [newPwAgField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [newPwAgField.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    newPwAgField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:newPwAgField];

    
    //提交按钮
    //保存修改按钮
    UIButton * saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBt.frame = CGRectMake( 40 , CGRectGetMaxY(newPwAgField.frame)+10 , ScreenWidth - 80  , 30);
    [saveBt setTitle:@"保存" forState:UIControlStateNormal];
    
    
    saveBt.layer.cornerRadius = 3 ;
    
    
    [saveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    saveBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    
    saveBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [saveBt addTarget:self action:@selector(submitBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBt];
    
  
}


#pragma mark 提交密码修改
//提交
-(void)submitBt
{

    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    [self.view endEditing:YES];
    NSLog(@"提交点击");
    
    NSString * pwdStr = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,18}$";
    NSPredicate *regextestPwdStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdStr];

    
    if (![newPwField.field.text isEqualToString:newPwAgField.field.text])
    {
        
        [self tipShow:@"两次输入不一致,请重新输入"];
    }
    
    else if(![regextestPwdStr evaluateWithObject:newPwField.field.text])
    {
        [self tipShow:@"密码由“8~18位字母、数字组合"];
        newPwField.field.text = @"";
        newPwAgField.field.text = @"";
    }
    else
    {
 
        NSString * PW = [DBNetworkTool md5Digest:newPwField.field.text];
        
        NSLog(@"%@",PW);
        
        
        
        NSDictionary * dic= @{@"phone":self.userName,@"password":PW,@"code":self.code};
        
        
        NSLog(@"%@...%@....%@",self.userName,PW,self.code);
        
        NSString * url =[NSString stringWithFormat:@"%@/api/resetpwd",Host];
//        NSString * url =@"http://www.rental.hpecar.com/api/resetpwd";
        
        
        
        DBNetworkTool *net = [[DBNetworkTool alloc]init];
        [net changePwdPUT:url parameters:dic];
        net.changePwBlock = ^(NSDictionary *dic)
        {
            
            if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
            {
                [UIView animateWithDuration:1 animations:^{
                    
                    [self.tipView removeFromSuperview];
                   
                    NSLog(@"11111111%@",dic);
                    
                } completion:^(BOOL finished) {
                    
                    // 返回登录界面

                    [user setObject:@"未登录" forKey:@"phone"];
                    [user setObject:@"" forKey:@"nickName"];
                    [user setObject:@"0" forKey:@"token"];


                    DBSignInViewController * sign = [[DBSignInViewController alloc]init];
                    //
                    //                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:sign];
                    //                    nav.navigationBarHidden = YES ;
                    sign.indexControl = 3 ;
                    
                    [self.navigationController pushViewController:sign animated:YES];
                    
                }];
            }
            else
            {
                [self.tipView removeFromSuperview];

                [self tipShow:[dic objectForKey:@"message"]];
            }

        };   
    }
}


- (void)tipShow:(NSString *)str
{
    
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}



//返回按钮点击
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
