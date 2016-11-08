//
//  DBSelfView.m
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSelfView.h"


@implementation DBSelfView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title withInfo:(id)info withUserEnble:(BOOL)enble{
    if (self=[super initWithFrame:frame]) {
        
        _title = title ;
        _info = info ;
        _useEnble = enble ;
        [self addSubview:self.infoView];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self ;
}


-(UIView*)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5 , self.frame.size.width, 0.5)];
        lineView.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [_infoView addSubview:lineView];
    
        //头像
        [_infoView addSubview:self.nameLabel];
        
        if ([_info isKindOfClass:[UIImage class]]) {
           
            [_infoView addSubview:self.userImage];
        }
        else{
            
            [_infoView addSubview:self.infoLabel];
        }
        
    }
    
    return _infoView;
}





-(UILabel*)nameLabel{
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20, 0, self.frame.size.width /2, 40)];
        _nameLabel.text = _title;
        _nameLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        

        UIControl * changeNickName = [[UIControl alloc]initWithFrame:CGRectMake(20, 0 , self.frame.size.width - 20, 40)];
        [changeNickName addTarget:self action:@selector(changeNickName:) forControlEvents:UIControlEventTouchUpInside];
     
        [_infoView addSubview:changeNickName];
        if ([_title isEqualToString:@"昵称"]) {
            changeNickName.tag = 1001 ;
        }
        else if ([_title isEqualToString:@"姓名"]){
             changeNickName.tag = 1002 ;
        }
        else if ([_title isEqualToString:@"邮箱"]){
            changeNickName.tag = 1003 ;
        }
        else if ([_title isEqualToString:@"修改密码"]){
            changeNickName.tag = 1004 ;
        }
        
    }
    return _nameLabel ;
}

-(UILabel*)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0, 0, self.frame.size.width -30, 40)];
        _infoLabel.text = _info;
        _infoLabel.textAlignment = 2 ;
        _infoLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        [_infoView addSubview:_infoLabel];
        
        UIImageView * editImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 16 , 14 , 6  , 11 )];
        //    classImage.backgroundColor = [UIColor redColor];
        editImage.image =[UIImage imageNamed:@"next"];

        if ([_title isEqualToString:@"昵称"] || [_title isEqualToString:@"邮箱"]) {
            [_infoView addSubview:editImage];
        }
        else if ([_title isEqualToString:@"姓名"] || [_title isEqualToString:@"证件号"]){
            
            if (!self.info || [self.info isEqualToString:@""]) {
                [_infoView addSubview:editImage];
            }
            else{
                self.userInteractionEnabled = NO ;
            }
        }
        else if ([_title isEqualToString:@"修改密码"] )
        {
            [_infoView addSubview:editImage];
        }

    }
    return _infoLabel;
}
-(UIImageView*)userImage{
    if (!_userImage) {
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 60 , 5, 30, 30 )];
        _userImage.image = [UIImage imageNamed:@"xmen.jpg"];
        _userImage.layer.cornerRadius = 14 ;
        _userImage.layer.masksToBounds = YES ;
        [_infoView addSubview:_userImage];
    }
    return _userImage ;
}
-(void)changeNickName:(UIControl*)control{
    
    NSString * obj ;
 
    NSNumber * index  = [NSNumber numberWithInteger:control.tag - 1000];
    
    switch (control.tag - 1000) {
        case 1:
            obj = @"changeNickName";

            break;
        case 2:
            obj = @"changeName";
            break;
        case 3:
            obj = @"changeEmail";
            break;
        case 4:
            obj = @"changePw";
            break;

        default:
            break;
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfoChange" object:index];
    
}

@end
