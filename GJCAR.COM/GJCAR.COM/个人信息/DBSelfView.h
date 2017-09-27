//
//  DBSelfView.h
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBSelfView : UIView


typedef NS_OPTIONS(NSUInteger, ClickBt) {
    ChangeNickName = 0,
    ChangeName = 1 << 0,
    ChangeEmail = 1 << 1,
    ChangePw = 1 << 2,
};


@property (nonatomic,strong)UIView * infoView ;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)id info ;
@property (nonatomic)BOOL useEnble ;

@property (nonatomic,assign)NSUInteger ClickBt ;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * infoLabel;
@property (nonatomic,strong)UIImageView * userImage;
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title withInfo:(id)info withUserEnble:(BOOL)enble;
@end
