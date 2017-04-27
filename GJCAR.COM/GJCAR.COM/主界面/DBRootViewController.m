//
//  DBRootViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBRootViewController.h"



#import "DBmainViewController.h"
#import "DBSecendViewController.h"
#import "DBThirdViewController.h"
#import "DBFourthViewController.h"
#import "DBFifthViewController.h"
#import "DBSixthViewController.h"

//登录
#import "DBSignInViewController.h"

//订单
#import "DBMyOrderViewController.h"

//个人信息页面
#import "DBUserInfoViewController.h"
#import "DBUserInfoModel.h"



//会员等级
#import "DBVipLvlViewController.h"
//我的礼券
#import "DBVoucherViewController.h"
//我的积分
#import "DBScoreViewController.h"
//系统设置
#import "DBSystemSetViewController.h"

static NSString * tele = @"400-653-6600" ;

@interface DBRootViewController ()<UIScrollViewDelegate>
{
    //记录上一次点击按钮
    UIButton * lastBt;
    
    //创建个人信息页面
    UIView * userView;
    
    //记录第几个页面点击
    NSInteger index ;
    
    //订单
    UILabel * order ;
    NSInteger orderNumaber ;
    
    UILabel * order1 ;
    NSInteger orderNumaber1 ;
   
    UILabel * order2 ;
    NSInteger orderNumaber2 ;
    
    UILabel * order3 ;
    NSInteger orderNumaber3 ;
    
    
    //    UIView * baseView ;
}
//错误提示
@property (nonatomic,strong)UIView * tipView;
@property (nonatomic,strong)DBUserInfoModel * userInfo ;

@property (nonatomic,strong)NSArray * controlArray;
@property (nonatomic,strong) UIViewController * currentViewController;

@property (nonatomic,strong)UIScrollView * activeScrollView;



@end

@implementation DBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTabBar];
    
    
    [self setNavigation];
    
    
    //创建个人信息页面
    [self setUserView];
    

    //检测新版本
    [self loadVersion];
    

}


#pragma mark 加载数据
-(void)loadUserInfo
{
    
    
    //    _userInfoDic = [NSDictionary dictionary];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * url = [NSString stringWithFormat:@"%@/api/me",Host];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            _userInfo = [[DBUserInfoModel alloc]initWithDictionary:[responseObject objectForKey:@"message"] error:nil];
            
            
            //            _userInfoDic = [responseObject objectForKey:@"message"];
            
            [self loadOrderInfo];
            
            [self performSelectorOnMainThread:@selector(config:) withObject:_userInfo waitUntilDone:YES];
            
        }
        else
        {

            [user setObject:@"0" forKey:@"token"];
            [user setObject:@"0" forKey:@"userId"];
            [self loadOrderInfo];
            [self setUser];

        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
}


-(void)loadOrderInfo
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/user/%@/order?currentPage=1&orderState=&pageSize=100",Host,[user objectForKey:@"userId"]];
    

    NSString * url1 = [NSString stringWithFormat:@"%@/api/door/user/orders?userId=%@&currentPage=1&orderState=&pageSize=100",Host,[user objectForKey:@"userId"]];
    

//    NSString * url2 = [NSString stringWithFormat:@"%@/api/airportTrip/orders?currentPage=1&fuzzy=1&pageSize=100",Host,[user objectForKey:@"userId"]];

    //顺风车
    NSString * url3 = [NSString stringWithFormat:@"%@/api/user/%@/freeRideOrder?currentPage=1&orderState=&pageSize=100",Host,[user objectForKey:@"userId"]];

    
    
    __weak typeof(self)weak_self = self ;
    [DBNetworkTool  checkOrderGET:url parameters:nil success:^(id responseObject) {
        
        

        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            
            
            
           orderNumaber = [NSArray arrayWithArray:[responseObject objectForKey:@"message"]].count;
            [weak_self performSelectorOnMainThread:@selector(oderConfig) withObject:nil waitUntilDone:YES];
           
        
        }
    
    } failure:^(NSError *error) {
    
    }];
    
    
    [DBNetworkTool  checkOrderGET:url1 parameters:nil success:^(id responseObject) {
        

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            
            
            if(![[responseObject objectForKey:@"message"]isKindOfClass:[NSNull class]]){
                NSArray * dataArray = [NSArray arrayWithArray:[[responseObject objectForKey:@"message"]objectForKey:@"content"]];
                                       
                                        
                orderNumaber1 = dataArray.count;
                                        
                [weak_self performSelectorOnMainThread:@selector(oderConfig) withObject:nil waitUntilDone:YES];
            }
           
            
            
            
           
            
        }
        
    } failure:^(NSError *error) {
        
    }];

    [DBNetworkTool  checkOrderGET:url3 parameters:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            orderNumaber3 = [NSArray arrayWithArray:[responseObject objectForKey:@"message"]].count;

            [weak_self performSelectorOnMainThread:@selector(oderConfig) withObject:nil waitUntilDone:YES];
            
        }
        
    } failure:^(NSError *error) {
        
    }];


}

-(void)oderConfig
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    UILabel * ordernumber = [self.view viewWithTag:650];
    UILabel * ordernumber1 = [self.view viewWithTag:651];
    UILabel * ordernumber2 = [self.view viewWithTag:652];
    UILabel * ordernumber3 = [self.view viewWithTag:653];

    
    if ([[user objectForKey:@"token"]isEqualToString:@"0"])
    {

        ordernumber.text =[NSString stringWithFormat:@"自驾订单"];
        ordernumber1.text = [NSString stringWithFormat:@"门到门订单"];
        ordernumber2.text = [NSString stringWithFormat:@"接送机订单"];
        ordernumber3.text = [NSString stringWithFormat:@"顺风车订单"];
        
    }
    else
    
    {
        ordernumber.text =[NSString stringWithFormat:@"自驾订单(%ld)",orderNumaber];
        ordernumber1.text = [NSString stringWithFormat:@"门到门订单(%ld)",orderNumaber1];
        ordernumber2.text = [NSString stringWithFormat:@"接送机订单(%ld)",orderNumaber2];
        ordernumber3.text = [NSString stringWithFormat:@"顺风车订单(%ld)",orderNumaber3];
    }
    
   }


#pragma mark 创建页面
#pragma mark ---创建导航栏
-(void)setNavigation
{
    
    self.view.backgroundColor = [UIColor grayColor];
    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"短租自驾的" withWidth:ScreenWidth withFontSize:13  ];
    
    CGSize three = [DBcommonUtils calculateStringLenth:@"顺风车的" withWidth:ScreenWidth withFontSize:13  ];
    
    CGSize two = [DBcommonUtils calculateStringLenth:@"活动的" withWidth:ScreenWidth withFontSize:13  ];
    

    
    //导航栏背景
    
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    _baseView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_baseView];
    
    [self.view bringSubviewToFront:_baseView];
    

    //个人信息按钮
    
    UIButton * UserBt = [ UIButton buttonWithType:UIButtonTypeCustom];
    UserBt.frame = CGRectMake(10, 30, 30  , 30  );
    [UserBt setImage:[UIImage imageNamed:@"userBt"] forState:UIControlStateNormal];
    [UserBt addTarget:self action:@selector(UserBt) forControlEvents:UIControlEventTouchUpInside];
    
    [_baseView addSubview:UserBt];
    
    
    //logo
    UIImageView * logo = [[ UIImageView alloc ]initWithFrame:CGRectMake(ScreenWidth/2 - (157 / 2  )/2, 25, 157 / 2   , 28  )];
    [_baseView addSubview:logo];
    logo.image = [UIImage imageNamed:@"LOGO"];
    
    //    根据字符长度计算控件宽度
    
    //    CGRectMake(ScreenWidth/2 - (four.width * 3 + six.width + 30)/2
    
    
    //label间距
    
    
//    CGFloat w = (ScreenWidth - four.width* 3- three.width * 2 - two.width)/7 ;
    //8.20 测试用
    CGFloat w = (ScreenWidth - four.width- three.width  - two.width)/4 ;

    
    
    _activeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame)+10, self.view.frame.size.width, 90 - CGRectGetMaxY(logo.frame)-10)];
    _activeScrollView.backgroundColor = [UIColor whiteColor];

    _activeScrollView.showsHorizontalScrollIndicator = NO;
    _activeScrollView.showsVerticalScrollIndicator = NO ;
    _activeScrollView.delegate =self ;
    [_baseView addSubview:_activeScrollView];
    [_baseView bringSubviewToFront:_activeScrollView];
    _activeScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 90 - CGRectGetMaxY(logo.frame)-10);
    
    
    
    //短租自驾
    UIButton * selfDriveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    selfDriveBt.frame = CGRectMake(w, 0, four.width, four.height +5);
    [selfDriveBt setTitle:@"短租自驾" forState:UIControlStateNormal];
    [selfDriveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selfDriveBt.titleLabel.font = [UIFont systemFontOfSize:13  ];
    selfDriveBt.layer.cornerRadius = (four.height +5)/2 ;
    [selfDriveBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    selfDriveBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [_activeScrollView addSubview:selfDriveBt];
    
    selfDriveBt.tag = 100;
    
    
    //默认上一次点击短租自驾
    
    lastBt = selfDriveBt;
    
    
    //    短租代驾
//    UIButton * otherDriveBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    otherDriveBt.frame = CGRectMake(CGRectGetMaxX(selfDriveBt.frame)+w,selfDriveBt.frame.origin.y, four.width, four.height +5);
//    [otherDriveBt setTitle:@"短租带驾" forState:UIControlStateNormal];
//    [otherDriveBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
//    otherDriveBt.titleLabel.font = [UIFont systemFontOfSize:11  ];
//    otherDriveBt.layer.cornerRadius = (four.height +5)/2  ;
//    [otherDriveBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
//    otherDriveBt.backgroundColor = [UIColor whiteColor];
//    [_activeScrollView addSubview:otherDriveBt];
    
//    otherDriveBt.tag = 101;
    //
    //
//        //顺风车
//    UIButton * specialBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    specialBt.frame = CGRectMake(CGRectGetMaxX(selfDriveBt.frame)+w, selfDriveBt.frame.origin.y, three.width, three.height+5);
//    [specialBt setTitle:@"顺风车" forState:UIControlStateNormal];
//    [specialBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
//    specialBt.titleLabel.font = [UIFont systemFontOfSize:13 ];
//    specialBt.layer.cornerRadius = (three.height +5)/2 ;
//    [specialBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
//    specialBt.backgroundColor = [UIColor whiteColor];
//    [_activeScrollView addSubview:specialBt];
//    
//    specialBt.tag = 101;
    
    //长租车
    UIButton * activityBt = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBt.frame = CGRectMake(CGRectGetMaxX(selfDriveBt.frame)+w, selfDriveBt.frame.origin.y, three.width, three.height+5);
    [activityBt setTitle:@"长租车" forState:UIControlStateNormal];
    [activityBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
    activityBt.titleLabel.font = [UIFont systemFontOfSize:13  ];
    activityBt.layer.cornerRadius = (three.height +5)/2  ;
    [activityBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    activityBt.backgroundColor = [UIColor whiteColor];
    [_activeScrollView addSubview:activityBt];
    
    activityBt.tag = 101;
    //
    //
    //    //企业租车
//    UIButton * companyBt = [UIButton buttonWithType:UIButtonTypeCustom];
//    companyBt.frame = CGRectMake(CGRectGetMaxX(activityBt.frame)+w, selfDriveBt.frame.origin.y, four.width, four.height+5);
//    [companyBt setTitle:@"企业租车" forState:UIControlStateNormal];
//    [companyBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
//    companyBt.titleLabel.font = [UIFont systemFontOfSize:11  ];
//    companyBt.layer.cornerRadius = (four.height +5)/2  ;
//    [companyBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
//    companyBt.backgroundColor = [UIColor whiteColor];
//    [_activeScrollView addSubview:companyBt];
//    
//    companyBt.tag = 104;
    //
    //
    //
    //    //活动
    UIButton * moreBt = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBt.frame = CGRectMake(CGRectGetMaxX(activityBt.frame)+w, selfDriveBt.frame.origin.y, two.width, two.height+5);
    [moreBt setTitle:@"活动" forState:UIControlStateNormal];
    [moreBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
    moreBt.titleLabel.font = [UIFont systemFontOfSize:13  ];
    moreBt.layer.cornerRadius = (two.height +5)/2  ;
    [moreBt addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBt.backgroundColor = [UIColor whiteColor];
    [_activeScrollView addSubview:moreBt];
    
    moreBt.tag = 102;
    
}
-(void)setTabBar
{
    
    
    
    DBmainViewController * main = [[DBmainViewController alloc]init];
    main.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);
    [self.view addSubview:main.view];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:main];
    nav.navigationBarHidden = YES ;
    
    
    DBSecendViewController * secend = [[DBSecendViewController alloc]init];
    
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:secend];
    secend.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);
    nav1.navigationBarHidden = YES ;
    
    DBThirdViewController * third = [[DBThirdViewController alloc]init];
    
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:third];
    third.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);

    nav2.navigationBarHidden = YES ;
    
    DBFourthViewController * fourth = [[DBFourthViewController alloc]init];
    
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:fourth];
    nav3.navigationBarHidden = YES ;
    fourth.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);

    
    DBFifthViewController * five = [[DBFifthViewController alloc]init];
    
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:five];
    nav4.navigationBarHidden = YES ;
    five.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);

    
    
    DBSixthViewController * six = [[DBSixthViewController alloc]init];

    
    
    UINavigationController * nav5 = [[UINavigationController alloc]initWithRootViewController:six];
    nav5.navigationBarHidden = YES ;
    six.view.frame = CGRectMake(0, 90, ScreenWidth, ControlHeight);

    
    [self addChildViewController:main];
//    [self addChildViewController:secend];
//    [self addChildViewController:third];
    [self addChildViewController:fourth];
//    [self addChildViewController:five];
    [self addChildViewController:six];
    

    
    
//    _controlArray = [NSArray arrayWithObjects:nav,nav1,nav2,nav3,nav4,nav5, nil];
        _controlArray = [NSArray arrayWithObjects:main,fourth,six, nil];
//            _controlArray = [NSArray arrayWithObjects:main,secend,third,fourth,five,six, nil];
    _currentViewController = main ;
    

    
    
    
}


#pragma mark 创建个人信息侧滑页面
//创建个人信息页面
-(void)setUserView
{
    
    userView = [[ UIView alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth * 2, ScreenHeight)];
    [self.view addSubview:userView];
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewMove)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft ;
    [userView addGestureRecognizer:swip];
    
    
    [self.view bringSubviewToFront:userView];
    
    userView.hidden = YES ;
    
    userView.userInteractionEnabled = YES ;
    
    
    //创建右侧半透明view
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth * 3/ 4, 0, ScreenWidth * 5 / 4, ScreenHeight)];
    baseView.backgroundColor = [UIColor grayColor];
    baseView.alpha = 0 ;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewMove)];
    [baseView addGestureRecognizer:tap];
    [userView addSubview:baseView];
    baseView.tag = 540 ;
    
    
    
    
    UIView * infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth  * 3 / 4, ScreenHeight)];
    infoView.backgroundColor = [UIColor colorWithRed:246 green:248 blue:248 alpha:1];
    [userView addSubview:infoView];
    
    //创建个人信息头像
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50   , 60  ,  60  )];
    userImage.image = [UIImage imageNamed:@"xmen.jpg"];
    [infoView addSubview:userImage];
    userImage.tag = 399 ;
    
    //创建个人信息姓名
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+20, 60  , infoView.frame.size.width -  80 - 60   , 20    )];
    //    nameLabel.text = [user objectForKey:@"nickName"];
    
    nameLabel.text =@"未登录";
    
    
    nameLabel.font = [UIFont systemFontOfSize:15  ];
    nameLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    [infoView addSubview:nameLabel];
    
    
    nameLabel.tag = 400;
    
    //创建个人信息手机号
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+20, CGRectGetMaxY(nameLabel.frame), infoView.frame.size.width -  80 - 60   , 20    )];
    
    phoneLabel.font = [UIFont systemFontOfSize:14  ];
    phoneLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    [infoView addSubview:phoneLabel];
    phoneLabel.text = @"";
    
    //    phoneLabel.text = [user objectForKey:@"phone"];
    
    phoneLabel.tag = 401 ;
    
    
    
    //个人信息编辑按钮
    
    UIButton * editBt = [UIButton buttonWithType:UIButtonTypeCustom];
    editBt.frame = CGRectMake(infoView.frame.size.width - 20   , 75    , 19 / 2 , 35 / 2 );
    [editBt setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    
    
    [infoView addSubview:editBt];
    
    UIControl * editc  = [[UIControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame) , 75    , infoView.frame.size.width - userImage.frame.size.width , 35 / 2 )];
    [editc addTarget:self action:@selector(editUser) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:editc];
    
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(userImage.frame)+25, infoView.frame.size.width - 20 , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    [infoView addSubview:lineView];
    
    

    
    
    //我的订单
    UIImageView * orderImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView.frame)+15, 20    , 20  )];
    orderImage.image = [UIImage imageNamed:@"订单"];
    [infoView addSubview:orderImage];
    
    
    UILabel * myOrder = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImage.frame)+15, orderImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    
    myOrder.text = @"我的订单";
    [infoView addSubview:myOrder];
    myOrder.font = [UIFont systemFontOfSize:15  ];
    myOrder.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    UIControl * myorderControl = [[UIControl alloc]initWithFrame:CGRectMake(0, myOrder.frame.origin.y, infoView.frame.size.width, 20  )];
    [infoView addSubview:myorderControl];
    [myorderControl addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
    myorderControl.tag = 655;

    
    
    
    
//订单分类view
    UIView * orderkind = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myOrder.frame)+5, infoView.frame.size.width - 100, 30 )];
    orderkind.backgroundColor = [UIColor whiteColor];
    orderkind.hidden = YES ;
    [infoView addSubview:orderkind];
    orderkind.tag = 654 ;
    
    
    order = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImage.frame)+15,  0 , infoView.frame.size.width - 100, 20  )];
    order.text = @"自驾订单";
    
    [orderkind addSubview:order];
    order.font = [UIFont systemFontOfSize:13];
    order.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    order.tag = 650;
    
    
    
    
    UIControl * orderControl = [[UIControl alloc]initWithFrame:CGRectMake(0, order.frame.origin.y, infoView.frame.size.width, 20  )];
    [orderkind addSubview:orderControl];
    [orderControl addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
    orderControl.tag = 550;
    
    
    
    //代驾订单
//    UIImageView * orderImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(order.frame)+5, 20    , 20  )];
//    orderImage1.image = [UIImage imageNamed:@"订单"];
//    //    [infoView addSubview:orderImage1];
//    
//    
//    order1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImage1.frame)+15, orderImage1.frame.origin.y, infoView.frame.size.width - 100, 20  )];
//    order1.text = @"门到门订单";
//    [orderkind addSubview:order1];
//    order1.font = [UIFont systemFontOfSize:13];
//    order1.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
//    order1.tag = 651;
//    
//    
//    UIControl * orderControl1 = [[UIControl alloc]initWithFrame:CGRectMake(0, orderImage1.frame.origin.y, infoView.frame.size.width, 20  )];
//    [orderkind addSubview:orderControl1];
//    [orderControl1 addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
//    orderControl1.tag = 551;
    
//
//    //接送机订单
//    UIImageView * orderImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(order.frame)+5, 20    , 20  )];
//    orderImage2.image = [UIImage imageNamed:@"订单"];
//    //    [infoView addSubview:orderImage1];
//    
//    
//    order2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImage2.frame)+15, orderImage2.frame.origin.y, infoView.frame.size.width - 100, 20  )];
//    order2.text = @"接送机订单";
//    [orderkind addSubview:order2];
//    order2.font = [UIFont systemFontOfSize:13];
//    order2.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
//    order2.tag = 652;
//    
//    
//    UIControl * orderControl2 = [[UIControl alloc]initWithFrame:CGRectMake(0, orderImage1.frame.origin.y, infoView.frame.size.width, 20  )];
//    [orderkind addSubview:orderControl2];
//    [orderControl2 addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
//    orderControl2.tag = 552;
//    
//    
    
    
    
    
    
    
    //顺风车订单
//    UIImageView * orderImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(order.frame)+5, 20    , 20  )];
//    orderImage3.image = [UIImage imageNamed:@"订单"];
//    [infoView addSubview:orderImage3];
//    
//    
//    order3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImage3.frame)+15, orderImage3.frame.origin.y, infoView.frame.size.width - 100, 20  )];
//    order3.text = @"顺风车订单";
//    [orderkind addSubview:order3];
//    order3.font = [UIFont systemFontOfSize:13];
//    order3.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
//    order3.tag = 653;
//    
//    
//    UIControl * orderControl3 = [[UIControl alloc]initWithFrame:CGRectMake(0, orderImage3.frame.origin.y, infoView.frame.size.width, 20  )];
//    [orderkind addSubview:orderControl3];
//    [orderControl3 addTarget:self action:@selector(myOrder:) forControlEvents:UIControlEventTouchUpInside];
//    
//    orderControl3.tag = 553;
    

    
    
    
//礼券 积分 等 view
    
    UIView * infokind = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myOrder.frame)+15, infoView.frame.size.width  , 160  )];
    infokind.backgroundColor = [UIColor whiteColor];
    [infoView addSubview:infokind];
    infokind.tag = 656 ;
    
    
    //我的礼券
    UIImageView * BritishImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20    , 20  )];
    BritishImage.image = [UIImage imageNamed:@"British"];
    [infokind addSubview:BritishImage];
    
    
    UILabel * British = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(BritishImage.frame)+15, BritishImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    British.text = @"我的优惠券";
    [infokind addSubview:British];
    British.font = [UIFont systemFontOfSize:15  ];
    British.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    
    UIControl * BritishControl = [[UIControl alloc]initWithFrame:CGRectMake(0, BritishImage.frame.origin.y, infoView.frame.size.width, 20  )];
    [infokind addSubview:BritishControl];
    [BritishControl addTarget:self action:@selector(myBritish) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(BritishImage.frame)+15, infoView.frame.size.width - 20 , 0.5)];
    //    lineView1.backgroundColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    //    [infoView addSubview:lineView1];
    
    
    //我的积分
    UIImageView * scoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(BritishImage.frame)+15, 20    , 20  )];
    scoreImage.image = [UIImage imageNamed:@"score"];
    [infokind addSubview:scoreImage];
    
    
    UILabel * score = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(scoreImage.frame)+15, scoreImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    score.text = @"我的积分";
    [infokind addSubview:score];
    score.font = [UIFont systemFontOfSize:15  ];
    score.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    
    UIControl * scoreControl = [[UIControl alloc]initWithFrame:CGRectMake(0, scoreImage.frame.origin.y, infoView.frame.size.width, 20  )];
    [infokind addSubview:scoreControl];
    [scoreControl addTarget:self action:@selector(myScore) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //会员等级
    UIImageView * VipImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(scoreImage.frame)+15, 20    , 20  )];
    VipImage.image = [UIImage imageNamed:@"vip"];
    [infokind addSubview:VipImage];
    
    
    UILabel * vipLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(VipImage.frame)+15, VipImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    vipLevel.text = @"会员等级";
    [infokind addSubview:vipLevel];
    vipLevel.font = [UIFont systemFontOfSize:15  ];
    vipLevel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    
    UIControl * vipControl = [[UIControl alloc]initWithFrame:CGRectMake(0, VipImage.frame.origin.y, infoView.frame.size.width, 20  )];
    [infokind addSubview:vipControl];
    [vipControl addTarget:self action:@selector(vipLevel) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    //系统设置
    UIImageView * setImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(VipImage.frame)+15, 20    , 20  )];
    setImage.image = [UIImage imageNamed:@"set"];
    [infokind addSubview:setImage];
    
    
    UILabel * set = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(setImage.frame)+15, setImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    set.text = @"系统设置";
    [infokind addSubview:set];
    set.font = [UIFont systemFontOfSize:15  ];
    set.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    
    UIControl * setControl = [[UIControl alloc]initWithFrame:CGRectMake(0, setImage.frame.origin.y, infoView.frame.size.width, 20  )];
    [infokind addSubview:setControl];
    [setControl addTarget:self action:@selector(setBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    //客服中心
    
    UIImageView * serviceImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(set.frame)+15, 20    , 20  )];
    serviceImage.image = [UIImage imageNamed:@"客服"];
    
    [infokind addSubview:serviceImage];
    
    
    UILabel * service = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serviceImage.frame)+15, serviceImage.frame.origin.y, infoView.frame.size.width - 100, 20  )];
    service.text = @"客服中心";
    [infokind addSubview:service];
    service.font = [UIFont systemFontOfSize:15  ];
    service.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    
    
    UIControl * serviceControl = [[UIControl alloc]initWithFrame:CGRectMake(0, serviceImage.frame.origin.y, infoView.frame.size.width, 20  )];
    [infokind addSubview:serviceControl];
    [serviceControl addTarget:self action:@selector(serviceBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(serviceImage.frame)+15, infoView.frame.size.width - 20 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
//    [infokind addSubview:lineView2];
    
    
    //创建版本logo
    [self setActivityView:(UIView * )infoView];
    
}

#pragma mark ---个人信息加载完成赋值
-(void)config:(DBUserInfoModel*)model
{
    
    
    UILabel * name = [self.view viewWithTag:400];
    UILabel * phone = [self.view viewWithTag:401];
    UIImageView * imageV = [self.view viewWithTag:399];
    
    
    
    
    name.text = _userInfo.nickName;
    phone.text  =[NSString stringWithFormat:@"%@",_userInfo.phone] ; 
    imageV.image = [UIImage imageNamed:@"xmen.jpg"];
    
    
//    DBManager * manager = [DBManager shareManager];
//    
//
//    
//    [manager addUserInfoWithModel:model];
    
    
    
}


#pragma mark ---创建商家活动页面
//创建商家活动页面
-(void)setActivityView:(UIView *)view
{
 
    NSString* oldversion =[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];

    
    
    UIImageView * activityView = [[UIImageView alloc]initWithFrame:CGRectMake( 20, ScreenHeight - 150   , 90, 33   )];

    
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    if ([deviceType isEqualToString:@"iPad"]) {
        
        activityView.frame = CGRectMake( 20, ScreenHeight - 70   , 90, 33   );
        
    }
    
    activityView.image = [UIImage imageNamed:@"versionImage"];
    [view addSubview:activityView];
    
    UILabel * version = [[UILabel alloc]initWithFrame:CGRectMake(34, CGRectGetMaxY(activityView.frame)+2, 90, 20)];
    version.text  = [NSString stringWithFormat:@"版本号:V%@",oldversion] ;
    version.font = [UIFont systemFontOfSize:12];
//    version.textAlignment = 1 ;
    version.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    [view addSubview:version];

}

#pragma mark 点击事件

#pragma mark ---侧滑页面功能 :订单 礼券 设置 客服
-(void)myOrder:(UIControl*)control
{
//    UINavigationController * control = [_controlArray objectAtIndex:index];
    
    if (control.tag == 655)
    {
        
        //订单页面
        UIView * myorder = [self.view viewWithTag:654];
        
        //礼券 积分等
        UIView * myservers = [self.view viewWithTag:656];
        
        
        if (myorder.hidden == NO)
        {
            
            control.enabled = NO ;
            [UIView animateWithDuration:0.3 animations:^{
               
                myorder.alpha = 0;
                
                CGRect frame = myservers.frame ;
                
                frame.origin.y -= 20 ;
                
                myservers.frame = frame ;

            } completion:^(BOOL finished) {
                
                control.enabled = YES ;
                myorder.hidden = YES ;
            }];
            
            
        }
        else
        {
            control.enabled = NO ;
            myorder.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                myorder.alpha = 1;

                CGRect frame = myservers.frame ;
                
                frame.origin.y += 20 ;
                
                myservers.frame = frame ;
                
            } completion:^(BOOL finished) {
                
                control.enabled = YES ;

            }];
        }
  
    }
    else
    {
        [self.tipView removeFromSuperview];
        
        DBNetManager * netManager =[DBNetManager sharedManager];
        
        if (netManager.netStatu == 0)[self tipShow:@"数据加载失败"];
        else
        {
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            if ([[user objectForKey:@"token"]isEqualToString:@"0"])
            {
                DBSignInViewController * signIn = [[DBSignInViewController alloc]init];
                
                signIn.indexControl = 3 ;
                [self.navigationController pushViewController:signIn animated:YES];
                
            }
            else
                
            {
                DBMyOrderViewController * orderinfo = [[DBMyOrderViewController alloc]init];

                orderinfo.orderIndex = control.tag - 550;
                
                
                
                [self viewMove];
                
                
                [self.navigationController pushViewController:orderinfo animated:YES];
            }
        }

    }

}


-(void)myBritish
{
    
    DBNetManager * netManager =[DBNetManager sharedManager];
    
    if (netManager.netStatu == 0)[self tipShow:@"无网络服务"];
    else
    {

    
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"token"]isEqualToString:@"0"])
        {
            DBSignInViewController * signIn = [[DBSignInViewController alloc]init];
            
            signIn.indexControl = 3 ;
            [self.navigationController pushViewController:signIn animated:YES];
            
        }
        else
        
        {
            DBVoucherViewController * voicher = [[DBVoucherViewController alloc]init];
            
            [self.navigationController pushViewController:voicher animated:YES];
        }
    }
    
}

-(void)setBt
{
    DBSystemSetViewController * system = [[DBSystemSetViewController alloc]init];
    
    [self.navigationController pushViewController:system animated:YES];
}


-(void)serviceBt
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:tele message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    
    [alert show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tele]]];
        //[NSString stringWithFormat:@"tel://%@",[[self.infoDic objectForKey:@"takeCarStore"]objectForKey:@"phone"]]
    }
}




-(void)myScore
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"token"]isEqualToString:@"0"])
    {
        DBSignInViewController * signIn = [[DBSignInViewController alloc]init];
        
        signIn.indexControl = 3 ;
        [self.navigationController pushViewController:signIn animated:YES];
        
    }
    else
    
    {
        DBScoreViewController * score = [[DBScoreViewController alloc]init];
        [self.navigationController pushViewController:score animated:YES];
    }

    
}


-(void)vipLevel
{
    
    DBNetManager * netManager =[DBNetManager sharedManager];
    
    if (netManager.netStatu == 0)[self tipShow:@"无网络服务"];
    else
    {

        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        if ([[user objectForKey:@"token"]isEqualToString:@"0"])
        {
            DBSignInViewController * signIn = [[DBSignInViewController alloc]init];
            
            signIn.indexControl = 3 ;
            [self.navigationController pushViewController:signIn animated:YES];
            
        }
        else
        
        {
            DBVipLvlViewController * lvl = [[DBVipLvlViewController alloc]init];
            
            [self.navigationController pushViewController:lvl animated:YES];
        }

    }
}


#pragma mark ----个人信息点击事件

//点击个人信息页面
-(void)UserBt
{
    NSLog(@"个人信息点击");
    
    UIView * clearView = [self.view viewWithTag:540];
    //加载个人信息
    [self loadUserInfo];
    //弹出信息页面
    if (userView.frame.origin.x != 0 )
    {
        [self.view bringSubviewToFront:userView];
        
        userView.hidden = NO ;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            //侧滑页面
            
            CGRect frame = userView.frame;
            frame  = CGRectMake(0 , 0 , 2 * ScreenWidth, ScreenHeight);
            userView.frame = frame;
            
            
            clearView.alpha = 0.7 ;
            
            
            //动画结束后执行
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

#pragma mark ---得到当前控制器
-(UINavigationController * )getNavigationController
{
    

    UINavigationController * control = [_controlArray objectAtIndex:index];
    

    [self viewMove];
    
    return control ;
    
}

#pragma mark ---个人信息编辑点击事件
-(void)editUser
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"个人信息编辑页面");
    
    
    
    DBNetManager * netManger = [DBNetManager sharedManager];
    if (netManger.netStatu == 0)
    {
        
        [self tipShow:@"网络不可用"];
        
//        DBUserInfoViewController * userInfo = [[DBUserInfoViewController alloc]init];
//        userInfo.netStatu = 0 ;
//       
//        [self.navigationController pushViewController:userInfo animated:YES];
    }
    else
    {
        if ([[user objectForKey:@"token"]isEqualToString:@"0"])
        {
            DBSignInViewController * signIn = [[DBSignInViewController alloc]init];
            
            signIn.indexControl = 3 ;
            [self.navigationController pushViewController:signIn animated:YES];
            
        }
        else
            
        {
            DBUserInfoViewController * userInfo = [[DBUserInfoViewController alloc]init];
            
            userInfo.userInfo = self.userInfo ;
            
            
            [self.navigationController pushViewController:userInfo animated:YES];
        }

    }
    
    
}
#pragma mark ---滑动手势收起侧滑页面
-(void)viewMove
{
    
    UIView * clearView = [self.view viewWithTag:540];

    if (userView.frame.origin.x == 0 ) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect frame = userView.frame;
            frame  = CGRectMake(- ScreenWidth , 0 , ScreenWidth * 2, ScreenHeight);
            userView.frame = frame;
            
            
            clearView.alpha = 0  ;
            
        } completion:^(BOOL finished) {
            

            userView.hidden = YES ;
            //            clearView.hidden = NO ;
            
        }];
        
    }
}



- (void)tipShow:(NSString *)str
{
    
    if (self.tipView)
    {
        [self.tipView removeFromSuperview];
    }
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

#pragma mark ----导航栏点击事件
-(void)BtClick:(UIButton * )button
{
    lastBt.backgroundColor = [UIColor whiteColor];
    [lastBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
    
    lastBt = button;
    
    button.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    index = button.tag -100 ;

    if (_currentViewController != _controlArray[button.tag -100])
    {

        [self transitionFromViewController:_currentViewController toViewController:_controlArray[button.tag -100] duration:0.5 options:
         0 animations:^{
             
         } completion:^(BOOL finished){
             
             _currentViewController = _controlArray[button.tag -100];
         }];
    }

}
- (void)navChange{
    
    UIButton * button = [self.view viewWithTag:100];
    lastBt.backgroundColor = [UIColor whiteColor];
    [lastBt setTitleColor:[UIColor colorWithRed:0.56 green:0.58 blue:0.58 alpha:1] forState:UIControlStateNormal];
    
    lastBt = button;
    
    button.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self transitionFromViewController:_currentViewController toViewController:_controlArray[0] duration:0.5 options:
     0 animations:^{
         
     } completion:^(BOOL finished){
         
         _currentViewController = _controlArray[0];
     }];

    
    
    
    
}
#pragma mark ----导航栏隐藏事件
-(void)tabBarHid
{

    if (self.baseView.hidden == NO) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.baseView.alpha = 0 ;
        } completion:^(BOOL finished) {
            self.baseView.hidden = YES;
        }];
        
    }

}
#pragma mark ----导航栏显示事件
-(void)tabBarShow
{
    if (self.baseView.hidden == YES)
    {
        
        self.baseView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.baseView.alpha = 1 ;
        } completion:^(BOOL finished) {
            
        }];
        
    }
}
#pragma mark ----网络变化显示事件
-(void)netChange{
    [self addBugView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarHid) name:@"tabBarHid" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarShow) name:@"tabBarShow" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(navChange) name:@"navChange" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netChange) name:@"netChange" object:nil];
    
    [self loadUserInfo];
 
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tabBarHid" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tabBarShow" object:nil];
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"netChange" object:nil];
}

-(void)dealloc{
    DBLog(@"%@  free",self);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"navChange" object:nil];
}


-(void)setUser
{
    UILabel * name = [self.view viewWithTag:400];
    
    UILabel * phone = [self.view viewWithTag:401];
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    name.text  = @"未登录";

    phone.text  =  @"";
    
    UIImageView * imageV = [self.view viewWithTag:399];

    imageV.image = [UIImage imageNamed:@"userImage"];

}


#pragma mark 检测新版本

-(void)loadVersion
{
    NSString * url =[NSString stringWithFormat:@"%@/api/appManage/latest?appType=1",Host];
    NSString* oldversion =[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];

    [DBNetworkTool Get:url parameters:nil success:^(id responseObject)
    {
        
        DBLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSNull class]] || [responseObject objectForKey:@"message"] ==nil)
            {
                            
            }
            else if ([[[responseObject objectForKey:@"message"]objectForKey:@"appVersion"]isEqualToString:@"0000"])
            {
                [self addBugView];
            }
            else if(![[[responseObject objectForKey:@"message"]objectForKey:@"appVersion"]isEqualToString:oldversion])
            {
                
                NSString * version = [[responseObject objectForKey:@"message"]objectForKey:@"appVersion"] ;
                NSString * newVersion = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString * oldVersion = [oldversion stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if ([newVersion integerValue] > [oldVersion integerValue]) {
                    
//                    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
//                    [self.view addSubview:backView];
//                    backView.backgroundColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.68 alpha:1];
//                    backView.alpha = 0.3 ;
//                    [self.view bringSubviewToFront:backView];
                    NSString * flag = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"message"]objectForKey:@"forceUpdate"]];
                    
                    
                    //                 UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
                    //                 [weak_self.view addSubview:backView];
                    //                 backView.backgroundColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.68 alpha:1];
                    //                 backView.alpha = 0.3 ;
                    //                 [weak_self.view bringSubviewToFront:backView];

                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可供更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];

                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1151833888"]];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self loadVersion];
                        });

                    
                    }];
                    
                    if ([flag isEqualToString:@"0"]){
                        [alertController addAction:cancelAction];
                    }
                    
                    [alertController addAction:okAction];

                    [self presentViewController:alertController animated:YES completion:nil];

                }
            }
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}

//系统维护弹框
-(void)addBugView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
    [window addSubview:backView];
    backView.backgroundColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.68 alpha:1];
    backView.alpha = 0.6 ;
    [window bringSubviewToFront:backView];
    
    UIView * bugView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth * 0.2 , ScreenHeight * 0.4 , ScreenWidth * 0.6, ScreenHeight * 0.2)];
    bugView.backgroundColor = [UIColor whiteColor];
    bugView.layer.cornerRadius = 10 ;
    [window addSubview:bugView];
    
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, bugView.frame.size.height/2 - 10 , bugView.frame.size.width, 20)];
    title.text = @"应用维护中";
    title.textAlignment = 1 ;
    title.font = [UIFont systemFontOfSize:14];
    [bugView addSubview:title];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(bugView.frame.size.width * 0.25, CGRectGetMaxY(title.frame)+10, bugView.frame.size.width * 0.5, 20);
    button.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [button setTitle:@"退出" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [bugView addSubview:button];

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
