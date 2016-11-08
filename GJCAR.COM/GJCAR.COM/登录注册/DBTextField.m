//
//  DBTextField.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBTextField.h"

@implementation DBTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        self.floatH = frame.size.height ;
        //背景设置
        UIView *baseView = [[UIView alloc]initWithFrame:frame];
        [self addSubview:baseView];
        //中间TextFiled
        CGFloat fieldW = frame.size.width ;
        CGFloat fieldH = frame.size.height ;
    
        _field = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, fieldW-20,fieldH - 10 )];
        [self addSubview:_field];
        _field.font = [UIFont systemFontOfSize:16];
        _field.clearButtonMode =UITextFieldViewModeWhileEditing;
        
    }


    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"more-image"] forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [_field setInputAccessoryView:topView];
    
    
    NSLog(@"%f",topView.frame.origin.y);
    
    
    return self;
}

-(void)dismissKeyBoard
{
    [_field resignFirstResponder];
}


-(instancetype)initWithFrame:(CGRect)frame withLeftImage:(NSString *)leftImage withButtonImage:(NSString *)rightImage withButtonHighImage:(NSString*)rightHightImage
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        //背景设置
        UIView *baseView = [[UIView alloc]initWithFrame:frame];
        [self addSubview:baseView];
        
//        //左侧图片
//        UIImageView *imageView =[[ UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
//        imageView.image = [UIImage imageNamed:leftImage];
//        [baseView addSubview:imageView];

        
        //中间TextFiled
        CGFloat fieldW = frame.size.width - frame.size.height;
        
        _field = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, fieldW-30, frame.size.height)];
        [self addSubview:_field];
        
        _field.clearButtonMode =UITextFieldViewModeWhileEditing;
//        [_field setValue:[UIFont systemFontOfSize:12/320*ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
        
        //右侧按钮
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
//        [_button setImage:[UIImage imageNamed:rightHightImage] forState:UIControlStateHighlighted];
        
        _button.frame = CGRectMake(frame.size.width- 25,frame.size.height/4,frame.size.height/2*11/8, frame.size.height/2);
        
        [self addSubview:_button];

    }
    
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"more-image"] forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [_field setInputAccessoryView:topView];
    
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame withValiBt:(NSString*)btTitle
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        //背景设置
        UIView *baseView = [[UIView alloc]initWithFrame:frame];
        [self addSubview:baseView];
        
        //中间TextFiled
        CGFloat fieldW = frame.size.width - frame.size.height;
        
        _field = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, fieldW-100, frame.size.height)];
        [self addSubview:_field];
        _field.clearButtonMode =UITextFieldViewModeWhileEditing;
        [_field setValue:[UIFont systemFontOfSize:15/320*ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
        
        //竖线
        UIView *lineView= [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-120*ScreenHeight/667, 5*ScreenHeight/667, 1, 30*ScreenHeight/667)];
        lineView.backgroundColor= [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [self addSubview:lineView];
        
        //验证码按钮
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(frame.size.width-120*ScreenHeight/667, 0, 120*ScreenHeight/667, 40*ScreenHeight/667);
        self.button.titleLabel.textAlignment = 1;
        [self.button setTitle:btTitle forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithRed:0.53 green:0.54 blue:0.54 alpha:1] forState:UIControlStateNormal];

        
        [self addSubview:self.button];
        
        //显示获取验证码时间
        self.valiLabel= [[UILabel alloc]initWithFrame:self.button.frame];

        self.valiLabel.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];;
        self.valiLabel.textColor = [UIColor whiteColor];
        self.valiLabel.textAlignment = 1;
        [self addSubview:self.valiLabel];
        self.valiLabel.hidden = YES;
        
    }
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"more-image"] forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [_field setInputAccessoryView:topView];
    
    
    
    return self;

}

//个人信息编辑
-(instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withTitle:(NSString*)title
{
    self = [super initWithFrame:frame];
    
    if(self != nil)
    {
        //背景设置
        UIView *baseView = [[UIView alloc]initWithFrame:frame];
        [self addSubview:baseView];
        
        //右边TextFiled
        if (image == nil)
        {
            _field = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth - 40 , frame.size.height)];
            [self addSubview:_field];
            
                       
            _field.clearButtonMode =UITextFieldViewModeWhileEditing;
        }
        else
        {
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, frame.size.height/2 - 10, frame.size.height/2 - 10)];
            imageV.image = [UIImage imageNamed:image];
            [self addSubview:imageV];
            
            
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10,0, frame.size.width * 3 / 16, frame.size.height)];
            titleLabel.text = title;
            [self addSubview:titleLabel];
            
            CGFloat fieldW = frame.size.width - CGRectGetMaxX(titleLabel.frame);
            
            _field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 0, fieldW, frame.size.height)];
            [self addSubview:_field];
            
            _field.clearButtonMode =UITextFieldViewModeWhileEditing;
            

        }
        
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:lineView];
        
        
    }
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"more-image"] forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [_field setInputAccessoryView:topView];
    
    
    return self;
}



@end
