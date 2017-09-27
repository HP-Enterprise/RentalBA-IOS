//
//  TCAlertView.h
//  TCAlertView
//
//  Created by Arthur on 2017/3/23.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DBAletViewBlock)();
typedef void(^DBAletCancelBlock)();

@interface TCAlertView : UIView


@property (nonatomic,strong)DBTextField * field ;
/** 设置alertView背景色 */
@property (nonatomic, copy) UIColor *alertBackgroundColor;
/** 设置确定按钮背景色 */
@property (nonatomic, copy) UIColor *btnConfirmBackgroundColor;
/** 设置取消按钮背景色 */
@property (nonatomic, copy) UIColor *btnCancelBackgroundColor;
/** 设置message字体颜色 */
@property (nonatomic, copy) UIColor *messageColor;

@property (nonatomic,copy)NSString * messageStr ;

+(TCAlertView*)shareManage;

- (void)showAlertWithMessage:(NSString*)message Block:(DBAletViewBlock) block;

- (void)showAlertWithMessage:(NSString*)message cancelBlock:(DBAletViewBlock)cancel Block:(DBAletViewBlock) block ;

- (void)closeView;


@end
