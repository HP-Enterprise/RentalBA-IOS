//
//  DBLongRentInfoViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/27.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBLongRentInfoViewController.h"

@interface DBLongRentInfoViewController ()<UIScrollViewDelegate>

{
    UIView * backView ;
    
    DBTextField * userNameField;
    DBTextField * companyNameField;
    DBTextField * phoneField;
    DBTextField * emailField;
    
    
    BOOL keyboardDidShow  ;
    //记录移动的距离
    CGFloat moveLenth ;
    
    
}

@property (nonatomic,strong)UIView * tipView ;

@property (nonatomic,strong)UIScrollView * scrollView ;

@end

@implementation DBLongRentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航栏创建
    [self setNavigation];
    
    
    //创建页面
    [self setUI];
    
}


#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"申请内容" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)setUI
{
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, ScreenWidth, 121)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:12];

//    
//    //展开的小箭头
//    
//    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , cityImage.frame.origin.y + 3, 7 , 4 )];
//    moreImage.image = [UIImage imageNamed:@"more-image"];
//    [self.view addSubview:moreImage];
//    
    
    //取车城市
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20 ,  0 ,four.width + 5, 30 )];
    takeCityLabel.text = @"取车城市";
    takeCityLabel.textAlignment = 1 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:takeCityLabel];
    
    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y +5 , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:lineView];
    
    
    //定位城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 30)];
    cityLabel.text =[[self.infoDic objectForKey:@"takeCity"]objectForKey:@"cityName"];
    cityLabel.textAlignment = 0 ;
    cityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:12 ];
    
    [backView addSubview:cityLabel];
    cityLabel.tag = 601 ;
    
    
//    //城市选择点击事件
//    UIControl * takeCity = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, cityLabel.frame.size.width, cityLabel.frame.size.height)];
//    takeCity.tag = 611 ;
//    [takeCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [cityLabel addSubview:takeCity];
//    
//    cityLabel.userInteractionEnabled = YES;
//    
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 5  ,ScreenWidth - 2 * takeCityLabel.frame.origin.x , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:lineView1];
    
    
    //取车时间
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(takeCityLabel.frame.origin.x , CGRectGetMaxY(lineView1.frame) ,four.width + 5, 30 )];
    returnCityLabel.text = @"取车时间";
    returnCityLabel.textAlignment = 1 ;
    returnCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCityLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:returnCityLabel];
    returnCityLabel.tag = 605 ;
    
    
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnCityLabel.frame)+5,  returnCityLabel.frame.origin.y +5 , 0.5 , 20)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:lineView2];
    
    
    //取车时间
    UILabel * placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 30)];
    placeLabel.text = [self.infoDic objectForKey:@"takeTime"];
    placeLabel.textAlignment = 0 ;
    placeLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    placeLabel.font = [UIFont systemFontOfSize:12 ];
    placeLabel.adjustsFontSizeToFitWidth = YES ;
    [backView addSubview:placeLabel];
    placeLabel.tag = 602 ;
    
    
//    
//    //取车地点选择
//    UIControl * takePlace = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, placeLabel.frame.size.width, placeLabel.frame.size.height)];
//    takePlace.tag = 612 ;
//    [takePlace addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [placeLabel addSubview:takePlace];
//    
//    placeLabel.userInteractionEnabled = YES;
//    
//    
    
    
    //取还车分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView2.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:carveLine];
    
    
    //租期  用车数量 品牌 车型 等条件筛选
    
    [self createView:carveLine.frame];
    
 
    
}

-(void)createView:(CGRect)frame
{
    
    
    
    //租期选择
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake( 25, CGRectGetMaxY(frame), ScreenWidth / 2  - 25   , 30 )];
    takeCityLabel.text =[NSString stringWithFormat:@"租期 :%@",[self.infoDic objectForKey:@"rentalTime"]];
    takeCityLabel.textAlignment = 0 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:takeCityLabel];
    takeCityLabel.tag = 603 ;
    
    
    //横线
    UIView * takeCitylineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,  29.5, ScreenWidth / 2 - 35 , 0.5)];
    takeCitylineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeCityLabel addSubview:takeCitylineView];
    
    
    
    
    //展开的小箭头
//    
//    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth / 2 -17 , CGRectGetMaxY(frame) + 18 , 7   , 4 )];
//    moreImage.image = [UIImage imageNamed:@"more-image"];
//    [self.view addSubview:moreImage];
//    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( ScreenWidth/ 2,  CGRectGetMaxY(frame), 0.5 , 60)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:lineView];
    
    
//    //租期选择
//    UIControl * takeTimeC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeCityLabel.frame.size.width, takeCityLabel.frame.size.height)];
//    takeTimeC.tag = 613 ;
//    [takeTimeC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [takeCityLabel addSubview:takeTimeC];
//    
//    takeCityLabel.userInteractionEnabled = YES;
//    
    
    
    //用车数量
    UILabel * carNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWidth / 2 + 10 , CGRectGetMaxY(frame), ScreenWidth / 2  - 25   , 30 )];
    carNumberLabel.text = [NSString stringWithFormat:@"用车数量 :%@",[self.infoDic objectForKey:@"carNumber"]];
    carNumberLabel.textAlignment = 0 ;
    carNumberLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    carNumberLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:carNumberLabel];
    carNumberLabel.tag = 604 ;
    
    //横线
    UIView * carNumberlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,  29.5, ScreenWidth / 2 - 35 , 0.5)];
    carNumberlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [carNumberLabel addSubview:carNumberlineView];
    
    
//    
//    //展开的小箭头
//    
//    UIImageView * carNumberImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth -27 , CGRectGetMaxY(frame) + 18 , 7   , 4 )];
//    carNumberImage.image = [UIImage imageNamed:@"more-image"];
//    [self.view addSubview:carNumberImage];
//    
//    
    
    
    
//    //取车地点选择
//    UIControl * carNumberC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, carNumberLabel.frame.size.width, carNumberLabel.frame.size.height)];
//    carNumberC.tag = 614 ;
//    [carNumberC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [carNumberLabel addSubview:carNumberC];
//    
//    carNumberLabel.userInteractionEnabled = YES;
//    
    
    
    
    //品牌选择
    UILabel * brandLabel = [[UILabel alloc]initWithFrame:CGRectMake( 25, CGRectGetMaxY(takeCityLabel.frame), ScreenWidth / 2  - 25   , 30 )];
    brandLabel.text = [NSString stringWithFormat:@"品牌 :%@",[[self.infoDic objectForKey:@"carBrand"]objectForKey:@"brand"]];
    brandLabel.textAlignment = 0 ;
    brandLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    brandLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:brandLabel];
    brandLabel.tag = 605 ;
    
//    //展开的小箭头
//    
//    UIImageView * brandImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth / 2 -17 , CGRectGetMaxY(takeCityLabel.frame) + 18 , 7   , 4 )];
//    brandImage.image = [UIImage imageNamed:@"more-image"];
//    [self.view addSubview:brandImage];
//    
    
    
//    //租期选择
//    UIControl * brandC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeCityLabel.frame.size.width, takeCityLabel.frame.size.height)];
//    brandC.tag = 615 ;
//    [brandC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
//    [brandLabel addSubview:brandC];
//    
//    brandLabel.userInteractionEnabled = YES;
//    
    
    //车型选择
    UILabel * carkindLabel = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWidth / 2 + 10, CGRectGetMaxY(takeCityLabel.frame), ScreenWidth / 2  - 25   , 30 )];
    carkindLabel.text =[NSString stringWithFormat:@"车型 :%@",[[self.infoDic objectForKey:@"carEnterprise"]objectForKey:@"model"]];
    carkindLabel.textAlignment = 0 ;
    carkindLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    carkindLabel.font = [UIFont systemFontOfSize:12 ];
    [backView  addSubview:carkindLabel];
    carkindLabel.tag = 606 ;
    
//    //展开的小箭头
//    
//    UIImageView * carkindImage = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth  -27 , CGRectGetMaxY(takeCityLabel.frame) + 18 , 7   , 4 )];
//    carkindImage.image = [UIImage imageNamed:@"more-image"];
//    [self.view addSubview:carkindImage];
//    

    //分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(carkindLabel.frame)   ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [backView addSubview:carveLine];
    
    
    
    
    
    NSLog(@"%f",carveLine.frame.origin.y);
    
    
    
    [self SetUserInfoView:carveLine.frame];
    
    
    
}

-(void)SetUserInfoView:(CGRect)frame;
{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+10, ScreenWidth, 180)];
    _scrollView.showsVerticalScrollIndicator = NO ;
    _scrollView.showsHorizontalScrollIndicator = NO ;
    _scrollView.delegate = self ;
    
    

    _scrollView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_scrollView];
    

    //企业输入框
    companyNameField = [[DBTextField alloc]initWithFrame:CGRectMake(25, 10, ScreenWidth-50, 30 ) withImage:nil];
    companyNameField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    companyNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    companyNameField.field.placeholder = @"企业名称";
    
    [companyNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [ companyNameField.field drawPlaceholderInRect:CGRectMake(0, 0 , 0, 0)];
    [companyNameField.field setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

    companyNameField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [_scrollView addSubview:companyNameField];

    
    
    //联系人输入框
    userNameField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(companyNameField.frame)+10, ScreenWidth-50, 30) withImage:nil];
    userNameField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    userNameField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    userNameField.field.placeholder = @"联系人";
    
    [userNameField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [userNameField.field setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    userNameField.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [_scrollView addSubview:userNameField];

    
    
    //手机号输入框
    phoneField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(userNameField.frame)+10, ScreenWidth-50, 30) withImage:nil];
    phoneField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    phoneField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    phoneField.field.placeholder = @"联系电话";
    
    [phoneField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [phoneField.field setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    phoneField.field.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:phoneField];
    
    
    
    //邮箱输入框
    emailField = [[DBTextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(phoneField.frame)+10, ScreenWidth-50, 30 ) withImage:nil];
    emailField.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
    emailField.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    emailField.field.placeholder = @"E-mail";
    
    [emailField.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [emailField.field setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    emailField.field.keyboardType = UIKeyboardTypeEmailAddress;
    [_scrollView addSubview:emailField];
    

    
    
    
    
    //选车按钮
    
    UIButton * chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBt.frame = CGRectMake(50, CGRectGetMaxY(_scrollView.frame)+50, ScreenWidth-100, 30);
    chooseBt.layer.cornerRadius = 3;
    chooseBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [chooseBt setTitle:@"提交" forState:UIControlStateNormal];
    [chooseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    [chooseBt addTarget:self action:@selector(submitBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBt];
    

}






//提交按钮点击
-(void)submitBt
{
    [self.tipView removeFromSuperview];
    
    
    
    //手机号判断
    
    phoneField.field.text =  [phoneField.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
      NSString *CT = @"^1(3|5|8|7)\\d{9}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];  // 小灵通
      NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];  // 电信


    //判断是否是汉字
    
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    

    
    if (companyNameField.field.text.length == 0 || userNameField.field.text.length == 0 || phoneField.field.text.length == 0 || emailField.field.text.length == 0)
    {
        
        
        [self tipShow:@"请完善信息"];
        
    }
    else if(([regextestmobile evaluateWithObject:phoneField.field.text] == NO)
          
            && ([regextestct evaluateWithObject:phoneField.field.text] == NO)
          )
    {
        [self tipShow:@"请输入正确的手机号"];
    }
    else if (![pred evaluateWithObject:userNameField.field.text])
    {
        [self tipShow:@"请输入正确的联系人"];

    }
    
    else
    {
        //提交
        [self submit];
    }
    
    
    NSLog(@"申请提交了");
}

-(void)submit
{
    
    NSString * url = [NSString stringWithFormat:@"%@/api/longRentalAsk",Host];
    

    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    
    parDic[@"carNumber"] = [self.infoDic objectForKey:@"carNumber"];
    
    parDic[@"rentalTime"] = [self.infoDic objectForKey:@"rentalTime"];

    
    parDic[@"vehicleBrandId"] = [[self.infoDic objectForKey:@"carBrand"]objectForKey:@"id"];
    
    parDic[@"vehicleModelId"] = [[self.infoDic objectForKey:@"carEnterprise"]objectForKey:@"id"];
    
    parDic[@"useCarDate"] = [self.infoDic objectForKey:@"takeTime"];

    
    parDic[@"useCarCityId"] = [[self.infoDic objectForKey:@"takeCity"]objectForKey:@"id"];

    
    parDic[@"customerName"] = userNameField.field.text ;

    parDic[@"requirement"] = companyNameField.field.text;
    parDic[@"phone"] = phoneField.field.text ;

    parDic[@"email"] = emailField.field.text ;

 

    __weak typeof(self)weak_self = self ;
    [DBNetworkTool POST:url parameters:parDic success:^(id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            
            [UIView animateWithDuration:1 animations:^{
                
                [self tipShow:[responseObject objectForKey:@"message"]];

            } completion:^(BOOL finished) {
               
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }];
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    

}


- (void)tipShow:(NSString *)str
{
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

//返回上页面
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    CGRect viewFrame = self.scrollView.frame;
    
    
    if (CGRectGetMaxY(viewFrame) > keyboardPoint.y)
    {
        
        moveLenth = CGRectGetMaxY(viewFrame) - keyboardPoint.y ;
        
        viewFrame.origin.y -= moveLenth ;
        

         self.scrollView.frame = viewFrame;
        
        
        [self.scrollView scrollRectToVisible:viewFrame animated:YES];
        keyboardDidShow = YES;

    }
    
   
    
}

- (void)keyBoardDidHide:(NSNotification *)notif {
    NSLog(@"====keyboard hidden====");

    CGRect viewFrame = self.scrollView.frame;
    viewFrame.origin.y += moveLenth ;

    self.scrollView.frame = viewFrame;
    if (!keyboardDidShow) {
        return;
    }
    keyboardDidShow = NO;
}



-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"长租车申请页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"长租车申请页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
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
