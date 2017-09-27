//
//  DBUserInfoView.m
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBUserInfoView.h"

#import "DBSelfView.h"

@implementation DBUserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dic withModel:(DBUserInfoModel*)model{
    if (self =  [super initWithFrame:frame]) {
        
        self.userInfoDic = dic ;
        self.userInfo = model;
        [self createUserInfo];
    }
    return self;
}

-(NSDictionary*)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [NSDictionary dictionary];
    }
    return  _userInfoDic ;
}

#pragma mark --创建个人信息view
-(void)createUserInfo
{
    //用户头像
    UIView * userImage =[[DBSelfView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 40) withTitle:@"头像" withInfo:[UIImage imageNamed:@"newUserImage"] withUserEnble:NO];
    [self addSubview:userImage];

    //昵称
    UIView * nickName =[[DBSelfView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(userImage.frame), ScreenWidth, 40) withTitle:@"昵称" withInfo:self.userInfo.nickName withUserEnble:YES];
    [self addSubview:nickName];

    //姓名
    UIView * realName =[[DBSelfView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(nickName.frame), ScreenWidth, 40) withTitle:@"姓名" withInfo:self.userInfo.realName withUserEnble:YES];
    [self addSubview:realName];
    

    
    //证件号
    UIView * cardNumberLabel =[[DBSelfView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(realName.frame), ScreenWidth, 40) withTitle:@"证件号" withInfo:self.userInfo.credentialNumber withUserEnble:YES];
    [self addSubview:cardNumberLabel];

    
    //手机号
    UIView * phoneNumberLabel =[[DBSelfView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(cardNumberLabel.frame), ScreenWidth, 40) withTitle:@"手机号" withInfo:self.userInfo.phone withUserEnble:YES];
    [self addSubview:phoneNumberLabel];

    
    //邮箱
    UIView * emailLabel =[[DBSelfView alloc]initWithFrame:CGRectMake(0 ,CGRectGetMaxY(phoneNumberLabel.frame), ScreenWidth, 40) withTitle:@"邮箱" withInfo:self.userInfo.email withUserEnble:YES];
    [self addSubview:emailLabel];


    //修改密码
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(emailLabel.frame)+19.5 , ScreenWidth, 0.5)];
    lineView1.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView1];
    
    
    UIView * changePwBt = [[DBSelfView alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(emailLabel.frame)+20, ScreenWidth  , 40)withTitle:@"修改密码" withInfo:nil withUserEnble:YES];
    [self addSubview:changePwBt];
    
    //注销
    UIButton * alipayBt = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBt.frame = CGRectMake( 50 , CGRectGetMaxY(changePwBt.frame)+40 ,ScreenWidth - 100  , 30 );
    [alipayBt setTitle:@"退出登录" forState:UIControlStateNormal];
    [alipayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    alipayBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    alipayBt.layer.cornerRadius = 5 ;
    alipayBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [alipayBt addTarget:self action:@selector(deletBt) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alipayBt];
    

//    address = "<null>";
//    birth = "<null>";
//    contactPerson = "<null>";
//    contactPhone = "<null>";
//    country = "<null>";
//    createDate = "<null>";
//    createUser = "<null>";
//    credentialNumber = "<null>";
//    credentialType = "<null>";
//    customerSource = "<null>";
//    email = "<null>";
//    emailStatus = 0;
//    expirydate = 1498838399000;
//    gender = 1;
//    id = 21;
//    isEnable = "<null>";
//    lvl = 1;
//    modifyDate = "<null>";
//    modifyUser = "<null>";
//    nickName = 15827653951;
//    phone = 15827653951;
//    postCode = "<null>";
//    realName = "<null>";
//    registerWay = "<null>";
//
//
//    */
//
//

}


-(void)deletBt{
    
    
    self.deletBtBlock();
}

@end
