//
//  DBChangeEmailViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/9/20.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBChangeEmailViewController.h"

@interface DBChangeEmailViewController ()<UITextFieldDelegate>


{
    DBTextField * emailField ;
}
@property (nonatomic,strong)UILabel * emailLabel;

@property (nonatomic,strong)UIView * tipView ;

@end

@implementation DBChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setNavigation];
    
    [self createTextFiled];
    
}

-(void)setNavigation
{
      self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"修改邮箱" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)createTextFiled
{

        emailField = [[DBTextField alloc]initWithFrame:CGRectMake(0, 84, ScreenWidth, 40 ) withImage:nil withTitle:nil];
        
        emailField.backgroundColor = [UIColor whiteColor];
        emailField.field.font = [UIFont systemFontOfSize:12];
        //    emailField.layer.cornerRadius = 5 ;
        //    emailField.layer.borderWidth = 0.5 ;
        //    emailField.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
        
        emailField.field.delegate = self ;
        emailField.field.placeholder = @"请输入新邮箱";
        [emailField.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
        [emailField.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
        emailField.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
        
        
        
        UIView * changePwLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
        changePwLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
        [emailField.field addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    
        [emailField addSubview:changePwLine];
        
        //    UIView * changePwLine1 = [[UIView alloc]initWithFrame:CGRectMake(0 ,40 , ScreenWidth , 0.5)];
        //    changePwLine1.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
        
        //    [emailField addSubview:changePwLine1];
        
        
        
        [self.view addSubview:emailField];
        
        
        //保存修改按钮
        UIButton * saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBt.frame = CGRectMake( 50 , ScreenHeight - 100 ,ScreenWidth - 100  , 30 );
        [saveBt setTitle:@"保存" forState:UIControlStateNormal];
        
        
        saveBt.layer.cornerRadius = 5 ;
        
        
        [saveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
        [saveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
        
        saveBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        [saveBt addTarget:self action:@selector(saveBt) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveBt];
        

    
}


-(void)textFieldDidChange
{
    
    if ([[emailField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        

        [_emailLabel removeFromSuperview];
        _emailLabel = nil ;
        
        
    }
    else
    {
        [self createEmailLabel:emailField.field.text];
    }
    
    
    
    
}




-(void)createEmailLabel:(NSString*)str
{
    
    if (!_emailLabel)
    {
        
        _emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(emailField.frame)+10, 200, 30)];
        
        _emailLabel.font=[UIFont systemFontOfSize:16];

        
        [self.view addSubview:_emailLabel];
        
        
        UIControl * click = [[UIControl alloc]initWithFrame:_emailLabel.frame];
        [self.view addSubview:click];
        
        [click addTarget:self action:@selector(changeText) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self judgeEmail:str];
    
}

-(void)judgeEmail:(NSString* )str
{
    
    NSArray * emails = @[@"@qq.com",@"@163.com",@"@126.com",@"@sina.com"];
    
    
    NSArray *array = [str componentsSeparatedByString:@"@"];
    
    if (array.count > 1)
    {
        if ([[array lastObject]isEqualToString:@""])
        {
            _emailLabel.text = [NSString stringWithFormat:@"%@qq.com",str];
            
        }
        else
        {
            for (NSString * everyStr in emails)
            {
                
                if([everyStr rangeOfString:[array lastObject]].location !=NSNotFound)//_roaldSearchText
                {
                    
                    _emailLabel.text = [NSString stringWithFormat:@"%@%@",[array firstObject],everyStr];
                    
                    NSLog(@"yes");
                    
                    break ;
                    
                }
                
                else
                {
                    
                    NSLog(@"no");
                    
                }
                
                _emailLabel.text = [NSString stringWithFormat:@"%@",str];
                
            }
        }
        
    }
    else
    {
        _emailLabel.text = [NSString stringWithFormat:@"%@@qq.com",str];
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    [_emailLabel removeFromSuperview];
    _emailLabel = nil ;
    
}

-(void)changeText
{
    emailField.field.text = _emailLabel.text ;
    [_emailLabel removeFromSuperview];
    _emailLabel = nil ;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [emailField.field endEditing:YES];
}


-(void)saveBt
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:@"checkNet"]isEqualToString:@"0"])
    {
//        [self.tipView removeFromSuperview];
//        [self tipShow:@"当前网络不可用"];
        return;
    }
    
    
    NSLog(@"提交点击");
    
    if ([emailField.field.text length] < 2)
    {
        
//        [self.tipView removeFromSuperview];
//        [self tipShow:@"昵称长度2-12个字符"];
        return ;
    }
    

    [_userInfoDic setObject:emailField.field.text forKey:@"email"];
    
    
    
    NSString * url =[NSString stringWithFormat:@"%@/api/me",Host];
    //    NSString * url = @"http://www.rental.hpecar.com/api/me";
    
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:_userInfoDic];
    
    
    DBNetworkTool *net = [[DBNetworkTool alloc]init];

    [net changePwdPUT:url parameters:dic];
    
    net.changePwBlock = ^(NSDictionary *dic)
    {
        
        
        if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            [UIView animateWithDuration:2 animations:^{
                
                
                [self tipShow:[dic objectForKey:@"message"]];
                
                
            } completion:^(BOOL finished) {
                
                // 返回登录界面
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        else
        {
            [UIView animateWithDuration:2 animations:^{
                
                [self tipShow:@"数据错误"];
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
    };
    
    
}



- (void)tipShow:(NSString *)str
{
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

-(void)back

{
    [self.navigationController popViewControllerAnimated:YES];
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
