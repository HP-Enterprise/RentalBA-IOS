//
//  DBSetCardInfoViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSetCardInfoViewController.h"

#import "DBDatePickViewController.h"

@interface DBSetCardInfoViewController ()<UITextFieldDelegate>
{
    DBTextField * nameFiled;
    DBTextField * cardNumberFiled;
}

//车型选择控件
@property (nonatomic,strong)DBDatePickViewController * carTypePicker;

@property (nonatomic ,strong)UILabel * cardKind ;

@property (nonatomic,strong)UIView * tipView ;


@property (nonatomic,strong)DBProgressAnimation * progress ;
@end



@implementation DBSetCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    
    
    [self setUI];
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



#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"身份信息" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    

}


-(void)setUI
{
    

    //姓名
    
    nameFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, 84, ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    nameFiled.backgroundColor = [UIColor whiteColor];
    nameFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    nameFiled.field.delegate = self ;
    
    if ( ![self.index isEqualToString:@"1"]) {
         nameFiled.field.placeholder = @"请输入姓名";
    }
    else{
        nameFiled.field.placeholder = [_userInfoDic objectForKey:@"realName"];
        nameFiled.field.enabled = NO ;
    }
    
   
    [nameFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [nameFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    nameFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    
    
    
    UIView * changePwLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
    changePwLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
    [nameFiled addSubview:changePwLine];
    [self.view addSubview:nameFiled];
    
    
    
    //证件号码
    
    cardNumberFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameFiled.frame), ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    cardNumberFiled.backgroundColor = [UIColor whiteColor];
    cardNumberFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    cardNumberFiled.field.delegate = self ;
  
    
    if (![self.index isEqualToString:@"0"] )  {
        
        cardNumberFiled.field.placeholder = @"请输入身份证号码";

    }
    
    else{
        cardNumberFiled.field.placeholder = [_userInfoDic objectForKey:@"credentialNumber"];
        cardNumberFiled.field.enabled = NO ;
    }
    
    
    [cardNumberFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [cardNumberFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    cardNumberFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    [self.view addSubview:cardNumberFiled];
 

    //    UIView * changePwLine1 = [[UIView alloc]initWithFrame:CGRectMake(0 ,40 , ScreenWidth , 0.5)];
    //    changePwLine1.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
    //    [nameFiled addSubview:changePwLine1];
    

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

    
    [_userInfoDic setValue:@"0" forKey:@"credentialType"];
    
}


#pragma mark ----提交
-(void)saveBt
{
    [self.tipView removeFromSuperview];
    
    NSString * url =[NSString stringWithFormat:@"%@/api/me",Host];
    //    NSString * url = @"http://www.rental.hpecar.com/api/me";
    
    
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    if ([self.index isEqualToString:@"1"])
    {
        if (![self validateIdentityCard]) {
            [self tipShow:@"请输入有效证件号"];
            return ;
        }
        
        else{
            
            [_userInfoDic setValue:[NSString stringWithFormat:@"%@",cardNumberFiled.field.text] forKey:@"credentialNumber"];

        }
    }
    else if ( [self.index isEqualToString:@"0"])
    {
        if (![pred evaluateWithObject: nameFiled.field.text]) {
            [self tipShow:@"请输入有效中文名"];
            return;

        }
        else{
              [_userInfoDic setValue:[NSString stringWithFormat:@"%@",nameFiled.field.text] forKey:@"realName"];
        }
    }
    else if ([self.index isEqualToString:@"2"])
    {
        if (![self validateIdentityCard]) {
            [self tipShow:@"请输入有效证件号"];
            return ;
        }
        
        else{
            
            [_userInfoDic setValue:[NSString stringWithFormat:@"%@",cardNumberFiled.field.text] forKey:@"credentialNumber"];

        }
        
        if (![pred evaluateWithObject: nameFiled.field.text]) {
            [self tipShow:@"请输入有效中文名"];
            return;
            
        }
        else{
            [_userInfoDic setValue:[NSString stringWithFormat:@"%@",nameFiled.field.text] forKey:@"realName"];
        }


    }
    
    
    
    
  
    
    
    NSDictionary * dic = [NSDictionary dictionaryWithDictionary:_userInfoDic];
    
    
    DBNetworkTool *net = [[DBNetworkTool alloc]init];
    [self addProgress];
    [net changePwdPUT:url parameters:dic];
    
    net.changePwBlock = ^(NSDictionary *dic)
    {
        
        
        [self removeProgress];
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



-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}
//空白处键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark ----delegate

#pragma mark ----私有
- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
  
}

//判断证件是否有效
//身份证号
-(BOOL)validateIdentityCard
{
    
    
//    BOOL flag;
//    if(nameFiled.field.text.length != 18){
//        flag =NO;
//        return flag;
//    }
//    (^\d{15}$)|(^\d{17}([0-9]|X)$)
    NSString * regex1=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSString * regex2=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
    
    
    
    NSPredicate *regextestmobile1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *regextestmobile2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    if (cardNumberFiled.field.text.length == 15) {
        
        return [regextestmobile1 evaluateWithObject:cardNumberFiled.field.text];

    }
    else if (cardNumberFiled.field.text.length == 18){
        return [regextestmobile2 evaluateWithObject:cardNumberFiled.field.text];
    }
    else{
        return NO ;
    }
    
    
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
