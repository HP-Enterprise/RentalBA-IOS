//
//  TCAlertView.m
//  TCAlertView
//
//  Created by Arthur on 2017/3/23.
//  Copyright © 2017年 Arthur. All rights reserved.
//

#import "TCAlertView.h"


#define kMainScreenBounds [UIScreen mainScreen].bounds
@interface TCAlertView()<UITextFieldDelegate>

{
    UILabel * lblMessage ;
    UIButton * btnConfirm ;
    UIButton * btnCancel ;
}



@property (nonatomic, strong) UIView *bgView;
/** 蒙版 */
@property (nonatomic, strong) UIView *coverView;
/** 弹框 */
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, copy) DBAletViewBlock block;
@property (nonatomic,copy)DBAletCancelBlock cancelBlock ;
@end

@implementation TCAlertView


+(TCAlertView*)shareManage{
    
    static TCAlertView * alert = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[TCAlertView alloc]initWithFrame:kMainScreenBounds];
    });
    return alert ;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    
    //创建蒙版
    UIView * coverView = [[UIView alloc] initWithFrame:kMainScreenBounds];
    self.coverView = coverView;
    //    [self.view addSubview:coverView];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    
    //创建提示框view
    UIView * alertView = [[UIView alloc] init];
    alertView.backgroundColor = self.alertBackgroundColor;
    alertView.layer.masksToBounds = YES;
    alertView.clipsToBounds = YES;
    //设置圆角半径
    alertView.layer.cornerRadius = 5.0;
    self.alertView = alertView;
    [self addSubview:alertView];
    alertView.center = coverView.center;
    alertView.frame = CGRectMake(kMainScreenBounds.size.width * 0.125, kMainScreenBounds.size.width * 0.5  , kMainScreenBounds.size.width * 0.75, kMainScreenBounds.size.width * 0.75 * 1.5/ 3);

    
    //创建操作提示 label
    UILabel * label = [[UILabel alloc] init];
    [alertView addSubview:label];
    label.text = @"兑换优惠券";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = 0;
    CGFloat lblWidth = alertView.bounds.size.width;
    CGFloat lblHigth = 22;
    label.frame = CGRectMake(20, 8, lblWidth, lblHigth);
    
    
    //创建message label
    lblMessage = [[UILabel alloc] init];
    lblMessage.textColor = self.messageColor;
//    [alertView addSubview:lblMessage];
    lblMessage.text = self.messageStr;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 2; //最多显示两行Message
    lblMessage.font = [UIFont systemFontOfSize:14];
    lblMessage.adjustsFontSizeToFitWidth = YES ;
    CGFloat margin = 5;
    CGFloat msgX = margin;
    CGFloat msgY = lblHigth + 8;
    CGFloat msgW = alertView.bounds.size.width - 2 * margin;
    CGFloat msgH = 44;
    lblMessage.frame = CGRectMake(msgX, msgY, msgW, msgH);
    
    _field = [[DBTextField alloc]initWithFrame:CGRectMake(msgX, msgY, msgW, msgH) withImage:nil withTitle:@"请输入兑换码"];
    _field.field.delegate = self ;
    
    _field.field.placeholder = @"请输入兑换码";
    
    [_field.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_field.field setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    _field.field.font = [UIFont systemFontOfSize:12];
    [alertView addSubview:_field];
    
    //创建中间灰色分割线
    UIView * separateLine = [[UIView alloc] init];
    separateLine.backgroundColor =[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1] ;
//    [alertView addSubview:separateLine];
    separateLine.frame = CGRectMake(0, msgY +  msgH + 10, alertView.bounds.size.width, 0.5);
    
    //创建 取消按钮
    CGFloat buttonWidth = alertView.bounds.size.width * 0.5;
    CGFloat buttonHigth = alertView.bounds.size.height - CGRectGetMaxY(separateLine.frame);
    btnCancel = [[UIButton alloc] init];
    
    [alertView addSubview:btnCancel];
    [btnCancel setTitleColor:[UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1]  forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];

    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnCancel setBackgroundColor:self.btnCancelBackgroundColor];
    btnCancel.frame = CGRectMake(0, CGRectGetMaxY(separateLine.frame), buttonWidth, buttonHigth);
    btnCancel.tag = 0;
    [btnCancel addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    btnConfirm = [[UIButton alloc] init];
    btnConfirm.tag = 1;
    [alertView addSubview:btnConfirm];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [btnConfirm setBackgroundColor:self.btnConfirmBackgroundColor];
    btnConfirm.frame = CGRectMake(buttonWidth, btnCancel.frame.origin.y, buttonWidth, btnCancel.frame.size.height);
    [btnConfirm addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --展示view
- (void)showAlertWithMessage:(NSString*)message Block:(DBAletViewBlock) block {
    
    self.block = block ;
    
    lblMessage.text = message;
    
    if (!block) {
        
        btnConfirm.hidden = YES ;
        btnCancel.frame = CGRectMake(0,btnCancel.frame.origin.y, self.alertView.frame.size.width , btnCancel.frame.size.height);
    }
    else{
        
        btnConfirm.hidden = NO;
        btnCancel.frame = CGRectMake(0,btnCancel.frame.origin.y, self.alertView.frame.size.width / 2, btnCancel.frame.size.height);
    }
    if (self.bgView) {
        return;
    }

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha =  0.4;
    [window addSubview:self.bgView];
    [window addSubview:self];
}

#pragma mark --展示view
- (void)showAlertWithMessage:(NSString*)message cancelBlock:(DBAletViewBlock)cancel Block:(DBAletViewBlock) block {
    
    self.block = block ;
    
    if (cancel) {
        self.cancelBlock = cancel ;
    }
    
    lblMessage.text = message;
    
    if (!block) {
        
        btnConfirm.hidden = YES ;
        btnCancel.frame = CGRectMake(0,btnCancel.frame.origin.y, self.alertView.frame.size.width , btnCancel.frame.size.height);
    }
    else{
        
        btnConfirm.hidden = NO;
        btnCancel.frame = CGRectMake(0,btnCancel.frame.origin.y, self.alertView.frame.size.width / 2, btnCancel.frame.size.height);
    }
    if (self.bgView) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha =  0.4;
    [window addSubview:self.bgView];
    [window addSubview:self];
    
    
    
}

/** 点击确定 or 取消触发事件 */
-(void)didClickBtnConfirm:(UIButton *)sender{
    
    if (sender.tag == 0) {
        [self closeView];
        return;
    }
    else{
        self.block();
        
    }
}

#pragma mark --关闭view
- (void)closeView {
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self removeFromSuperview];
}

- (void)cancelAction:(UIButton *)button {
    [self closeView];
}

-(UIColor *)alertBackgroundColor{
    
    if (_alertBackgroundColor == nil) {
        _alertBackgroundColor = [UIColor whiteColor];
    }
    return _alertBackgroundColor;
}

/** 确定按钮背景色 */
-(UIColor *)btnConfirmBackgroundColor{
    
    if (_btnConfirmBackgroundColor == nil) {
        _btnConfirmBackgroundColor = BascColor;
    }
    return _btnConfirmBackgroundColor;
}

/** 取消按钮背景色 */
-(UIColor *)btnCancelBackgroundColor{
    
    if (_btnCancelBackgroundColor == nil) {
        _btnCancelBackgroundColor = [UIColor whiteColor];
    }
    return _btnCancelBackgroundColor;
}

/** message字体颜色 */
-(UIColor *)messageColor{
    
    if (_messageColor == nil) {
        _messageColor = [UIColor blackColor];
    }
    return _messageColor;
}



@end
