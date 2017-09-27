//
//  DBProgressAnimation.h
//  ShenHuaCar
//
//  Created by 段博 on 16/5/6.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBProgressAnimation : UIView


{
    UIWindow * window ;
}

@property (nonatomic,strong)UIImageView * progress ;
@property (nonatomic,strong)UIView * backView ;


-(void)addProgressAnimationWithViewControl:(UIViewController*)viewControl;

-(void)removeProgressAnimation;

@end
