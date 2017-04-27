//
//  DBFifthViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBFifthViewController.h"

@interface DBFifthViewController ()<UIScrollViewDelegate>
{
    DBTextField * userNameField ;
    DBTextField * passWordField ;
    
    UIScrollView * scrollView ;
    
    BOOL keyboardDidShow  ;
    //记录移动的距离
    CGFloat moveLenth ;
    
    
}
@end

@implementation DBFifthViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];

}

#pragma mark 创建界面
-(void)setUI
{
    
    //添加背景图片
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    
    UIImageView * imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*571/777)];
    imageV.image = [UIImage imageNamed:@"截图"];
    
    
    [self.view addSubview:imageV];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), ScreenWidth, 60)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.delegate = self ;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 50, 30)];
    name.text = @"账号" ;
    name.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:name ];
    
    
    //账号输入框
    userNameField = [[DBTextField alloc]initWithFrame:CGRectMake(45, 0, ScreenWidth-50, 30) withImage:nil];
    userNameField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
//    userNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
//    userNameField.field.placeholder = @"请输入手机号";
    
//    [userNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
//    [userNameField.field setValue:[UIFont systemFontOfSize:15 ] forKeyPath:@"_placeholderLabel.font"];
    
    userNameField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [scrollView addSubview:userNameField];

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame) - 0.5, ScreenWidth - 35, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [scrollView addSubview:lineView];
    
    
    
    UILabel * password = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame), 50, 30)];
    password.text = @"密码" ;
    password.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:password ];

    
    //密码输入
    passWordField =[[DBTextField alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(lineView.frame), ScreenWidth-50, 30) withLeftImage:nil withButtonImage:nil withButtonHighImage:nil];
    passWordField.layer.cornerRadius = 5;
    
//    passWordField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    
    passWordField.button.frame = CGRectMake(passWordField.frame.size.width- 40,passWordField.frame.size.height/4,passWordField.frame.size.height/2*11/8,passWordField.frame.size.height/2);
    
    
//    passWordField.field.placeholder = @"请输入密码";
//    [passWordField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
//    [passWordField.field setValue:[UIFont systemFontOfSize:15 ] forKeyPath:@"_placeholderLabel.font"];
    
    passWordField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    passWordField.field.clearButtonMode = 0;
    
    passWordField.field.secureTextEntry = NO;
//    [passWordField.button addTarget:self action:@selector(passWordShow) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:passWordField];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(passWordField.frame) - 0.5, ScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [scrollView addSubview:lineView1];

    
    //登录按钮
    UIButton * chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBt.frame = CGRectMake(50, CGRectGetMaxY(scrollView.frame)+50, ScreenWidth-100, 30);
    chooseBt.layer.cornerRadius = 3;
    chooseBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [chooseBt setTitle:@"登录" forState:UIControlStateNormal];
    [chooseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    [chooseBt addTarget:self action:@selector(chooseBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBt];
    
//
}
//键盘位置监控
- (void)keyBoardDidShow:(NSNotification *)notif {
    NSLog(@"===keyboar showed====");
    if (keyboardDidShow) return;
    //    get keyboard size
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //    CGSize keyboardSize = [aValue CGRectValue].size;
    CGPoint keyboardPoint = [aValue CGRectValue].origin;
    
    CGRect viewFrame = scrollView.frame ;
    

    if (CGRectGetMaxY(viewFrame)+ 94 > keyboardPoint.y)
    {
        
        
        
        
        moveLenth = CGRectGetMaxY(viewFrame) + 94 - keyboardPoint.y ;
        
        viewFrame.origin.y -= moveLenth ;
        
        
        
        
        scrollView.frame = viewFrame;
        
        
        [scrollView scrollRectToVisible:viewFrame animated:YES];
        keyboardDidShow = YES;
        
    }

}

- (void)keyBoardDidHide:(NSNotification *)notif {
    NSLog(@"====keyboard hidden====");
    //    NSDictionary *info = [notif userInfo];
    //    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGSize keyboardSize = [aValue CGRectValue].size;
    //    CGPoint keyboardPoint = [aValue CGRectValue].origin;
    CGRect viewFrame = scrollView.frame;
    viewFrame.origin.y += moveLenth ;
    
    scrollView.frame = viewFrame;
    if (!keyboardDidShow) {
        return;
    }
    keyboardDidShow = NO;
}




-(void)chooseBt
{
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
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
