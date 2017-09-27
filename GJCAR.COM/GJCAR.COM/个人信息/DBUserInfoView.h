//
//  DBUserInfoView.h
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^deletBtBlock)(void);
@interface DBUserInfoView : UIView




@property (nonatomic,strong)DBUserInfoModel * userInfo ;
@property (nonatomic,strong)NSDictionary * userInfoDic ;


@property (nonatomic,strong)deletBtBlock deletBtBlock ;


-(instancetype)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dic withModel:(DBUserInfoModel*)model;

@end
