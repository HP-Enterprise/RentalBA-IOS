//
//  DBTextField.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBTextField : UIView


@property (nonatomic)CGFloat floatH;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UITextField *field;
@property(nonatomic,strong)UILabel *valiLabel;

-(instancetype)initWithFrame:(CGRect)frame withImage:(UIImage*)image;

-(instancetype)initWithFrame:(CGRect)frame withLeftImage:(NSString *)leftImage withButtonImage:(NSString *)rightImage withButtonHighImage:(NSString*)rightHightImage;
-(instancetype)initWithFrame:(CGRect)frame withValiBt:(NSString*)btTitle;
-(instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withTitle:(NSString*)title;
@end
