//
//  DBNavgationView.h
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBNavgationView : UIView


//@property(nonatomic,strong)UIView *statusBarView;
//@property(nonatomic,strong)UIImageView *baseView;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UIButton *leftButton;

@property(nonatomic,strong)UIButton *rightButton;

-(instancetype)initNavgationWithTitle:(NSString*)title withLeftBtImage:(NSString*)LeftImge withRightImage:(NSString*)rightImage withFrame:(CGRect)frame;

-(instancetype)initNavgationWithTitle:(NSString*)title withLeftBtImage:(NSString*)LeftImge withRightImage:(NSString*)rightImage withRightTitle:(NSString*)RightTitle withFrame:(CGRect)frame;



@end
