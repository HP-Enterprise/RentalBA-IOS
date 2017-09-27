//
//  DBChangePwViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/31.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBChangePwViewController.h"
#import "DBSignInViewController.h"


@interface DBChangePwViewController ()

@property (nonatomic,strong)UIView *tipView;
@end

@implementation DBChangePwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self setNavigation];
    [self createUI];
}


-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"修改密码" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    

}


-(void)createUI
{
    //请输入框
    oldPwField = [[DBTextField alloc]initWithFrame:CGRectMake( 40 , 100, ScreenWidth - 80 , 30 ) withLeftImage:nil withButtonImage:nil withButtonHighImage:nil];

    oldPwField.field.keyboardType = UIKeyboardTypeASCIICapable;
    oldPwField.field.secureTextEntry = YES;
 
    oldPwField.field.frame  = CGRectMake(20, 0, oldPwField.frame.size.width-50, oldPwField.frame.size.height);

    oldPwField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

    oldPwField.field.placeholder = @"请输入原密码";


    [oldPwField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [oldPwField.field setValue:[UIFont systemFontOfSize:15 ] forKeyPath:@"_placeholderLabel.font"];

    [self.view addSubview:oldPwField];
    
    
    
    
    //密码输入
    newPwField =[[DBTextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(oldPwField.frame)+ 10, ScreenWidth - 80, 30 ) withLeftImage:nil withButtonImage:@"password-1" withButtonHighImage:nil];
    
    
    //    newPwAgField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    newPwField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    
    newPwField.field.frame = CGRectMake(20, 0, newPwField.frame.size.width-50, newPwField.frame.size.height);
    newPwField.button.frame = CGRectMake(newPwField.frame.size.width- 40,newPwField.frame.size.height/4,newPwField.frame.size.height/2*11/8,newPwField.frame.size.height/2);
    
    
    newPwField.field.placeholder = @"请输入新密码";
    [newPwField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [newPwField.field setValue:[UIFont systemFontOfSize:15 ] forKeyPath:@"_placeholderLabel.font"];
    
    newPwField.field.keyboardType = UIKeyboardTypeASCIICapable;
    newPwField.field.clearButtonMode = 0;
    
    newPwField.field.secureTextEntry = YES;
    [newPwField.button addTarget:self action:@selector(passWordShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newPwField];

    
    
    
    
    
    
    //密码输入
    newPwAgField =[[DBTextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(newPwField.frame)+ 10, ScreenWidth - 80, 30 ) withLeftImage:nil withButtonImage:@"password-1" withButtonHighImage:nil];

    newPwAgField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];

    newPwAgField.field.frame = CGRectMake(20, 0, newPwAgField.frame.size.width-50, newPwAgField.frame.size.height);
    newPwAgField.button.frame = CGRectMake(newPwAgField.frame.size.width- 40,newPwAgField.frame.size.height/4,newPwAgField.frame.size.height/2*11/8,newPwAgField.frame.size.height/2);
    
    
    newPwAgField.field.placeholder = @"再次输入新密码";
    [newPwAgField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [newPwAgField.field setValue:[UIFont systemFontOfSize:15 ] forKeyPath:@"_placeholderLabel.font"];
    
    newPwAgField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    newPwAgField.field.clearButtonMode = 0;
    
    newPwAgField.field.secureTextEntry = YES;
    [newPwAgField.button addTarget:self action:@selector(passWordShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newPwAgField];
    
    
    

    
    
    
    

    
    
    
//    
//    UIView * cardLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
//    cardLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
//    
//    [oldPwField addSubview:cardLine];
//    
//    UIView * cardLine1 = [[UIView alloc]initWithFrame:CGRectMake(0 ,40 , ScreenWidth , 0.5)];
//    cardLine1.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
//    
//    [oldPwField addSubview:cardLine1];
//    
//    
//    
//    UIView * cardLine2 = [[UIView alloc]initWithFrame:CGRectMake(0 ,40 , ScreenWidth , 0.5)];
//    cardLine2.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
//    
//    [newPwAgField addSubview:cardLine2];

    

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


//是否显示密码
-(void)passWordShow
{
    if (newPwAgField.field.secureTextEntry == YES)
    {
        newPwAgField.field.secureTextEntry = NO;
        [newPwAgField.button setImage:[UIImage imageNamed:@"password-1"] forState:UIControlStateNormal];
    }
    else
    {
        newPwAgField.field.secureTextEntry =YES;
        [newPwAgField.button setImage:[UIImage imageNamed:@"password"] forState:UIControlStateNormal];
    }
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
    

    
    if(![regextestPwdStr evaluateWithObject:oldPwField.field.text] || ![regextestPwdStr evaluateWithObject:newPwAgField.field.text])
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"密码由“8~18位字母、数字组合"];
        oldPwField.field.text = @"";
        newPwAgField.field.text = @"";
    }

    else
    {
        
//        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        
        
        if ([[user objectForKey:@"checkNet"]isEqualToString:@"0"])
        {
            [self.tipView removeFromSuperview];
            [self tipShow:@"当前网络不可用"];
            return;
        }


        NSString * newPW = [DBNetworkTool md5Digest:newPwAgField.field.text];
        NSString * oldPW = [DBNetworkTool md5Digest:oldPwField.field.text];
        
        NSDictionary * dic= @{@"oldPwd":oldPW,@"password":newPW};
        
        NSString * url =[NSString stringWithFormat:@"%@/api/my/pwd",Host];
      
        
//        NSString * url = @"http://www.rental.hpecar.com/api/my/pwd";
        

        self.view.userInteractionEnabled = NO ;
        DBNetworkTool *net = [[DBNetworkTool alloc]init];
        [net changePwdPUT:url parameters:dic];
        
        net.changePwBlock = ^(NSDictionary *dic)
        {

            if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
            {
         
                [UIView animateWithDuration:2 animations:^{
                    
                     [self.tipView removeFromSuperview];
                    [self tipView:ScreenHeight * 0.8 withTipmessage:[dic objectForKey:@"message"]];
                    NSLog(@"11111111%@",dic);
                    
                } completion:^(BOOL finished) {
                    
                    // 返回登录界面
                    
                    
                    //注销成功token值设为0
                    
                    
                    [user setObject:@"未登录" forKey:@"phone"];
                    [user setObject:@"" forKey:@"nickName"];
                    [user setObject:@"0" forKey:@"token"];

  
                    
                    
                    DBSignInViewController * sign = [[DBSignInViewController alloc]init];

                     self.view.userInteractionEnabled = YES ;
                     sign.indexControl = 3 ;
                    
//                    self.signInblock([user objectForKey:@"phone"],newPwAgField.field.text);
//                 
//                    
//                    
//                    for (UIViewController * vc in self.navigationController.viewControllers)
//                    {
//                        if ([vc isKindOfClass:[DBSignInViewController class]])
//                        {
//                            [self.navigationController popToViewController:vc animated:YES];
//
//                        }
//                    }
                    
             
                    
//                    [user setObject:newPwAgField.field.text forKey:@"password"];
                    
                    
                    
                    [self.navigationController pushViewController:sign animated:YES];
                    
                }];
            }
            else
            {
         
                 self.view.userInteractionEnabled = YES ;
                [self.tipView removeFromSuperview];
                [self tipShow:@"数据错误"];
            }
            
        };
    }
}


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
