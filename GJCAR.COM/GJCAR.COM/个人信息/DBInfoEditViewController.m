//
//  DBInfoEditViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBInfoEditViewController.h"


@interface DBInfoEditViewController ()<UITextFieldDelegate>

{
    DBTextField * nameFiled;
}

@property (nonatomic,strong)UIView * tipView ;


@end

@implementation DBInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    [self setUI];
    
}

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"修改昵称" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


//导航栏左侧按钮
-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}


//创建界面
-(void)setUI
{
    
    
    nameFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, 84, ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    nameFiled.backgroundColor = [UIColor whiteColor];
    nameFiled.field.font = [UIFont systemFontOfSize:12];
//    nameFiled.layer.cornerRadius = 5 ;
//    nameFiled.layer.borderWidth = 0.5 ;
//    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;

    nameFiled.field.delegate = self ;
    nameFiled.field.placeholder = @"请输入新昵称 (2-12个字符)";
    [nameFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [nameFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    nameFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];

    
    
    UIView * changePwLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
    changePwLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
    [nameFiled addSubview:changePwLine];
    
//    UIView * changePwLine1 = [[UIView alloc]initWithFrame:CGRectMake(0 ,40 , ScreenWidth , 0.5)];
//    changePwLine1.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
//    [nameFiled addSubview:changePwLine1];

    
    
    [self.view addSubview:nameFiled];
    

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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (nameFiled.field == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 12) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:12];
            return NO;
        }

    }
    return YES;
}


-(void)saveBt
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    if ([[user objectForKey:@"checkNet"]isEqualToString:@"0"])
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"当前网络不可用"];
        return;
    }
    
    
    NSLog(@"提交点击");

    if ([nameFiled.field.text length] < 2)
    {

        [self.tipView removeFromSuperview];
        [self tipShow:@"昵称长度2-12个字符"];
        return ;
    }
    
    
    
    NSDictionary * dic= @{@"nickName":nameFiled.field.text};
    
    NSString * url =[NSString stringWithFormat:@"%@/api/me",Host];
//    NSString * url = @"http://www.rental.hpecar.com/api/me";
    

    DBNetworkTool *net = [[DBNetworkTool alloc]init];
    [net changePwdPUT:url parameters:dic];
    net.changePwBlock = ^(NSDictionary *dic)
    {
        if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
        {
            [UIView animateWithDuration:2 animations:^{
                
                 NSLog(@"保存修改");
                
                [self.tipView removeFromSuperview];
                [self tipView:ScreenHeight * 0.8 withTipmessage:[dic objectForKey:@"message"]];
                NSLog(@"11111111%@",dic);
                
                
                [user setObject:nameFiled.field.text forKey:@"nickName"];
                
            } completion:^(BOOL finished) {
                
                // 返回登录界面
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        else
        {
            [self.tipView removeFromSuperview];
            [self tipShow:[dic objectForKey:@"message"]];
        }
        
    };
    
   
}

//设置提示框显示时间
- (void)tipShow:(NSString *)str {
    
    [UIView animateWithDuration:2 animations:^{
        
        [self tipView:ScreenHeight * 0.8 withTipmessage:str];
        
    } completion:^(BOOL finished) {
        
        [self.tipView removeFromSuperview];
        
    }];
}


//输入错误提示框
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



//空白处键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    NSLog(@"%@ free",self);
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
