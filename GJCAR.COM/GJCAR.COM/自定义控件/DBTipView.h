//
//  DBTipView.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBTipView : UIView

{
    
    CGFloat time;
}

- (instancetype)initWithHeight:(CGFloat)height WithMessage:(NSString *)messageStr;
//默认高度
- (instancetype)initWithNormalHeightWithMessage:(NSString *)messageStr withViewController:(UIViewController *)viewController withShowTimw:(CGFloat)times;
// 手动设置高度
- (instancetype)initWithHeight:(CGFloat)height WithMessage:(NSString *)messageStr withViewController:(UIViewController *)viewController withShowTimw:(CGFloat)times;


// 调用上面init方法后，调用此方法可显示提示框
- (void)tipViewShow;


@end
