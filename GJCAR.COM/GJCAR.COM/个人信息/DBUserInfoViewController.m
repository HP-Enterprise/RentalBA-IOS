//
//  DBUserInfoViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/27.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBUserInfoViewController.h"
#import "DBManager.h"

//修改密码
#import "DBChangePwViewController.h"
//填写证件
#import "DBSetCardInfoViewController.h"

//修改昵称
#import "DBInfoEditViewController.h"

//修改手机号
#import "DBChangePhoneViewController.h"

//修改邮箱
#import "DBChangeEmailViewController.h"

#import "DBUserInfoView.h"
@interface DBUserInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIView * tipView ;

@property (nonatomic,strong)NSDictionary * userInfoDic ;

@end

@implementation DBUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建导航栏
    [self setNavigation];
    
    //创建个人信息
    [self createUserInfo];
    
//    [self createNewUserInfo];
}

#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"个人信息" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark 加载个人信息
//加载个人信息
-(void)loadUserInfo
{
    
    
    _userInfoDic = [NSDictionary dictionary];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * url = [NSString stringWithFormat:@"%@/api/me",Host];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            _userInfoDic = [responseObject objectForKey:@"message"];
            _userInfo = [[DBUserInfoModel alloc]initWithDictionary:[responseObject objectForKey:@"message"] error:nil];

            [self performSelectorOnMainThread:@selector(config) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark ---个人信息加载完成赋值
-(void)config
{
    
    
    UILabel * nickname = [self.view viewWithTag:450];
    UILabel * name = [self.view viewWithTag:451];
    UILabel * cardKind = [self.view viewWithTag:452];
    UILabel * cardNumber = [self.view viewWithTag:453];
    UILabel * phoneNumber = [self.view viewWithTag:454];
    
    UILabel * email = [self.view viewWithTag:455];
    


    UIImageView * nameImage = [self.view viewWithTag:461];

    if (_userInfo.credentialType == nil)
    {
        cardKind.text = @"请填写证件信息";
    }
    else
    {
        switch ([_userInfo.credentialType integerValue])
        {
            case 0:
                cardKind.text = @"第二代身份证";
                break;
            case 1:
                cardKind.text = @"港澳通行证";
                break;
            case 2:
                cardKind.text = @"台湾通行证";
                break;
            case 3:
                cardKind.text = @"护照";
                break;
            default:
                break;
        }
    }

    if (_userInfo.nickName) {
        nickname.text = _userInfo.nickName;
    }
    
    if (_userInfo.realName) {
        name.text = _userInfo.realName;

    }
    if (_userInfo.email) {
         email.text = _userInfo.email ;
    }
    if (_userInfo.credentialNumber)
    {
        cardNumber.text= [NSString stringWithFormat:@"%@",_userInfo.credentialNumber];
    }
       phoneNumber.text =[NSString stringWithFormat:@"%@",_userInfo.phone] ;

//测试用 测试完显示
    
    if ([_userInfoDic objectForKey:@"credentialNumber"]==nil ||
        [[_userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] ||
        [[_userInfoDic objectForKey:@"credentialNumber"]isEqualToString:@""] ||

        [[_userInfoDic objectForKey:@"realName"]isEqualToString:@""] ||

        [_userInfoDic objectForKey:@"realName"]==nil ||
        [[_userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]])
    {
        
        nameImage.hidden = NO;
    }
    else
    {
        nameImage.hidden = YES;
    }

}

-(void)createNewUserInfo{
    UIScrollView * userInfoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    userInfoScroll.contentSize = CGSizeMake(ScreenWidth, ScreenHeight-63);
    userInfoScroll.delegate = self ;
    userInfoScroll.showsVerticalScrollIndicator = NO;
    userInfoScroll.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:userInfoScroll];
    
    DBUserInfoView * userInfoView = [[DBUserInfoView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , ScreenHeight - 64) withDic:self.userInfoDic withModel:self.userInfo];
    
    
    [userInfoScroll addSubview:userInfoView];
    
    
    

    __weak typeof(self)weak_self = self ;
    userInfoView.deletBtBlock = ^()
    {
 
        [weak_self deletBt];
    };
    

    
}


#pragma mark --创建个人信息view
-(void)createUserInfo
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 80 , ScreenWidth , 240 )];
    baseView.backgroundColor = [UIColor whiteColor] ;
    [self.view addSubview:baseView];

    
    //循环创建
    for (int i = 0 ; i < 7; i ++)
    {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + i * 40 , ScreenWidth, 0.5)];
        lineView.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [baseView addSubview:lineView];
    }
    //头像
    UILabel * imageLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20, 0, ScreenWidth /2, 40)];
    imageLabel.text = @"头像";
    imageLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    imageLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:imageLabel];
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 60 , 5, 30, 30 )];
    imageV.layer.cornerRadius = 15 ;
    imageV.layer.masksToBounds = YES ;
    imageV.image = [UIImage imageNamed:@"newUserImage"];
    [baseView addSubview:imageV];
    

    //昵称
    UILabel * nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40 , ScreenWidth /2 , 40)];
    nickNameLabel.text = @"昵称" ;
    nickNameLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    nickNameLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:nickNameLabel];
    
    //昵称
    
    UILabel * nickName = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 40 , ScreenWidth  - 30  , 40)];
    
    nickName.text =_userInfo.nickName ;
    nickName.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    nickName.font = [UIFont systemFontOfSize:14];
    nickName.textAlignment = 2 ;
    [baseView addSubview:nickName];
    nickName.tag = 450 ;
    

    UIImageView * editImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 16 ,nickNameLabel.frame.origin.y + 14 , 6  , 11 )];
    //    classImage.backgroundColor = [UIColor redColor];
    editImage.image =[UIImage imageNamed:@"next"];
    [baseView addSubview:editImage];

    
    //修改昵称
    UIControl * changeNickName = [[UIControl alloc]initWithFrame:CGRectMake(20, nickNameLabel.frame.origin.y, ScreenWidth - 20, 30)];
    
    [changeNickName addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:changeNickName];

    
    //姓名
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(nickName.frame) , ScreenWidth /2 , 40)];
    nameLabel.text = @"姓名" ;
    nameLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:nameLabel];
    

    //名字
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(nickName.frame) , ScreenWidth  - 30  , 40)];
    name.text =_userInfo.realName ;
    name.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    name.font = [UIFont systemFontOfSize:14];
    name.textAlignment = 2 ;
    [baseView addSubview:name];
    name.tag = 451 ;
    /*
     
     
     address = "<null>";
     birth = "<null>";
     contactPerson = "<null>";
     contactPhone = "<null>";
     country = "<null>";
     createDate = "<null>";
     createUser = "<null>";
     credentialNumber = "<null>";
     credentialType = "<null>";
     customerSource = "<null>";
     email = "<null>";
     emailStatus = 0;
     expirydate = 1498838399000;
     gender = 1;
     id = 21;
     isEnable = "<null>";
     lvl = 1;
     modifyDate = "<null>";
     modifyUser = "<null>";
     nickName = 15827653951;
     phone = 15827653951;
     postCode = "<null>";
     realName = "<null>";
     registerWay = "<null>";

     
     */

    
    UIImageView * cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 16 ,name.frame.origin.y + 14 , 6  , 11 )];
    //    classImage.backgroundColor = [UIColor redColor];
    cardImage.image =[UIImage imageNamed:@"next"];
    cardImage.tag = 461;
    [baseView addSubview:cardImage];
    
    
    //修改姓名
    UIControl * cardKinde = [[UIControl alloc]initWithFrame:CGRectMake(20, name.frame.origin.y, ScreenWidth - 20, 30)];
    
    [cardKinde addTarget:self action:@selector(changeCardInfo) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:cardKinde];
    

    //证件类型
    UILabel * cardNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(name.frame) , ScreenWidth /2 , 40)];
    cardNumberLabel.text = @"证件号" ;
    cardNumberLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    cardNumberLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:cardNumberLabel];
    
    //证件号码
    
    UILabel * carNumber= [[UILabel alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(name.frame) , ScreenWidth  - 30  , 40)];
    
    if (_userInfo.credentialNumber != nil)
    {
        
        
        carNumber.text =[NSString stringWithFormat:@"%@",_userInfo.credentialNumber] ;

  
    }
    
    carNumber.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    carNumber.font = [UIFont systemFontOfSize:14];
    carNumber.textAlignment = 2 ;
    [baseView addSubview:carNumber];
    carNumber.tag = 453 ;
    
    
    //手机
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(carNumber.frame) , ScreenWidth /2 , 40)];
    phoneLabel.text = @"手机号" ;
    phoneLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:phoneLabel];
    
    //手机号码
    
    UILabel * phoneNumber= [[UILabel alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(carNumber.frame) , ScreenWidth  - 30  , 40)];
    phoneNumber.text = [NSString stringWithFormat:@"%@",_userInfo.phone] ;
    phoneNumber.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    phoneNumber.font = [UIFont systemFontOfSize:14];
    phoneNumber.textAlignment = 2 ;
    [baseView addSubview:phoneNumber];
    phoneNumber.tag = 454 ;

    
    
    UIImageView * phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 16 ,phoneNumber.frame.origin.y + 14 , 6  , 11 )];

    phoneImage.image =[UIImage imageNamed:@"next"];
//    [baseView addSubview:phoneImage];
    
    
    //修改
    UIControl * changePhone = [[UIControl alloc]initWithFrame:CGRectMake(20, phoneLabel.frame.origin.y, ScreenWidth - 20, 30)];
    
    [changePhone addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
//    [baseView addSubview:changePhone];

    
    
    
    //邮箱
    UILabel * emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(phoneLabel.frame) , ScreenWidth /2 , 40)];
    emailLabel.text = @"邮箱账号" ;
    emailLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    emailLabel.font = [UIFont systemFontOfSize:14];
    [baseView addSubview:emailLabel];
    
    //邮箱账号
    
    UILabel * emailNumber= [[UILabel alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(phoneLabel.frame) , ScreenWidth  - 30  , 40)];
    
    
    if (_userInfo.email != nil)
    {
        emailNumber.text = [NSString stringWithFormat:@"%@",_userInfo.email] ;
    }
    
    
    emailNumber.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    emailNumber.font = [UIFont systemFontOfSize:14];
    emailNumber.textAlignment = 2 ;
    [baseView addSubview:emailNumber];
    emailNumber.tag = 455 ;
    
    
    
    UIImageView * emailImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 16 ,emailNumber.frame.origin.y + 14 , 6  , 11 )];
    
    emailImage.image =[UIImage imageNamed:@"next"];
    [baseView addSubview: emailImage];

    
    //修改
    UIControl * changeEmail = [[UIControl alloc]initWithFrame:CGRectMake(20, emailLabel.frame.origin.y, ScreenWidth - 20, 30)];
    
    [changeEmail addTarget:self action:@selector(changeEmail) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:changeEmail];

    //修改密码
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(emailLabel.frame)+19.5 , ScreenWidth, 0.5)];
    lineView1.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];
    

    UIButton * changePwBt = [UIButton buttonWithType:UIButtonTypeCustom];
    changePwBt.frame = CGRectMake(0 , CGRectGetMaxY(baseView.frame)+20, ScreenWidth  , 40);
    [changePwBt addTarget:self action:@selector(changPw) forControlEvents:UIControlEventTouchUpInside];
    changePwBt.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:changePwBt];
    
    
    UILabel * changePw = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(baseView.frame)+20, ScreenWidth - 20, 40)];
    changePw.text = @"修改密码" ;
    changePw.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    changePw.font = [UIFont systemFontOfSize:14];
    changePw.textAlignment = 0 ;
    [self.view addSubview:changePw];

    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( -20 ,  39.5 , ScreenWidth, 0.5)];
    lineView2.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [changePw addSubview:lineView2];

    
    
    //注销
    UIButton * alipayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBt.frame = CGRectMake( 50 , CGRectGetMaxY(changePw.frame)+40 ,ScreenWidth - 100  , 30 );
    [alipayBt setTitle:@"退出登录" forState:UIControlStateNormal];
    [alipayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alipayBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    alipayBt.layer.cornerRadius = 5 ;
    alipayBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [alipayBt addTarget:self action:@selector(deletBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alipayBt];

    
    DBNetManager * netManager =[DBNetManager sharedManager];
    [self getUserInfoFromFMDB];

    if (netManager.netStatu == 0)
    {

        NSDictionary * userDic = [self getUserInfoFromFMDB];
        
        nickName.text =[userDic objectForKey:@"nickName"] ;
        name.text =[userDic objectForKey:@"realName"] ;
        carNumber.text = [userDic objectForKey:@"credentialNumber"] ;
        phoneNumber.text =[userDic objectForKey:@"phone"];
    }

}




-(NSDictionary*)getUserInfoFromFMDB
{
    
    
    DBManager * manager = [DBManager shareManager];
    
    
    return [manager searchAll];
}



#pragma mark --修改密码
-(void)changPw
{
    DBChangePwViewController * changePw = [[DBChangePwViewController alloc]init];
    
    [self.navigationController pushViewController:changePw animated:YES];
    
    
    NSLog(@"修改密码点击了");
}

#pragma mark --修改昵称
-(void)changeNickName
{
    DBInfoEditViewController * infoEdit = [[DBInfoEditViewController alloc] init];
    [self.navigationController pushViewController:infoEdit animated:YES];
    
}
#pragma mark --填写证件号码
-(void)changeCardInfo
{
    
    DBSetCardInfoViewController * cardInfo = [[DBSetCardInfoViewController alloc]init];
    
    cardInfo.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:_userInfoDic] ;
 
    
    if ([_userInfoDic objectForKey:@"credentialNumber"]==nil ||
        [[_userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] ||
        [[_userInfoDic objectForKey:@"credentialNumber"]isEqualToString:@""])
    {
        if ([_userInfoDic objectForKey:@"realName"]==nil ||
            [[_userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]] ||
            [[_userInfoDic objectForKey:@"realName"]isEqualToString:@""]) {
            cardInfo.index = @"2" ;
        }
        else
        {
            cardInfo.index = @"1";
        }
        
        [self.navigationController pushViewController:cardInfo animated:YES];


    }
    else if ([_userInfoDic objectForKey:@"realName"]==nil ||
             [[_userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]] ||
             [[_userInfoDic objectForKey:@"realName"]isEqualToString:@""])
    {
        cardInfo.index = @"0";
        
        [self.navigationController pushViewController:cardInfo animated:YES];

    }
    
    else
    {
        NSLog(@"信息不可更改");
    }
    
    
//测试用,测完注释
    
//    [self.navigationController pushViewController:cardInfo animated:YES];


}
#pragma mark --修改联系电话
-(void)changePhone
{
    
    DBChangePhoneViewController * changePhone = [[DBChangePhoneViewController alloc]init];
    
    
    [self.navigationController pushViewController:changePhone animated:YES];
    
    
}
#pragma mark --修改邮箱

-(void)changeEmail
{
    DBChangeEmailViewController * changeEmail = [[DBChangeEmailViewController alloc]init];
    changeEmail.userInfoDic =[NSMutableDictionary dictionaryWithDictionary:_userInfoDic] ;
    [self.navigationController pushViewController:changeEmail animated:YES];
    
}

#pragma mark --退出登录
-(void)deletBt
{
    
    NSString *url =[NSString stringWithFormat:@"%@/api/login",Host];
    
    //    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    [self tipShow:@"注销成功"];
    
    [user setObject:@"未登录" forKey:@"phone"];
    [user setObject:@"" forKey:@"nickName"];
    
    [user setObject:@"0" forKey:@"token"];
    [user setObject:@"0" forKey:@"userId"];
    
    //跳转到信息页面
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 2秒后异步执行这里的代码...
        self.view.userInteractionEnabled = YES ;

        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
    });
    
    [DBNetworkTool DELETE:url parameters:nil success:^(id responseObject) {
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);

    }];
}

#pragma mark --返回上一页
-( void)back

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
    

    
     [self loadUserInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoChange:) name:@"userInfoChange" object:nil];

    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}


-(void)userInfoChange:(NSNotification*)not{

    NSLog(@"通知发送了 %@",not.object);
    switch ([not.object integerValue]) {
        case 1:
            [self changeNickName];
            break;
        case 2:
            [self changeCardInfo];
            break;
        case 3:
            [self changeEmail];
            break;
        case 4:
            [self changPw];
            break;
        default:
            break;
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"个人信息页面"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userInfoChange" object:nil];

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
