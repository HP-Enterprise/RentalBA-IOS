//
//  DBNavgationView.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBNavgationView.h"

@implementation DBNavgationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initNavgationWithTitle:(NSString*)title withLeftBtImage:(NSString*)LeftImge withRightImage:(NSString*)rightImage withFrame:(CGRect)frame;

{
    if (self = [super initWithFrame:frame])
    
    {
        UIView * baseView = [[UIView alloc]initWithFrame:frame];
        
        baseView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];

//        baseView.userInteractionEnabled = YES ;
        
        
        
        [self addSubview:baseView];
        
        
        if (LeftImge != nil)
        {
            UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(20, 36, 7, 11)];
            imagev.image = [UIImage imageNamed:LeftImge];
            [self addSubview:imagev];
         
            self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftButton.frame = CGRectMake(0, 20, 44, 44);
            [self addSubview:self.leftButton];
//            self.leftButton.backgroundColor = [UIColor blackColor];
        }
        
        if (rightImage !=nil)
        {
            UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20 - 7 , 36, 7, 11)];
            
            imagev.image = [UIImage imageNamed:LeftImge];
            [self addSubview:imagev];
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.frame = CGRectMake(ScreenWidth - 54, 20, 44, 44);
            [self addSubview:self.rightButton];
        }
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50 , 20, ScreenWidth-100, 44)];
        self.titleLabel.text = title ;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment =1 ;
        self.titleLabel.textColor = [UIColor blackColor ] ;
        [self addSubview:self.titleLabel];
        
        
//        UIView * statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//        statusBarView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
//        [self addSubview:statusBarView];
        


    }
    
    
    return self;
    
}


-(instancetype)initNavgationWithTitle:(NSString*)title withLeftBtImage:(NSString*)LeftImge withRightImage:(NSString*)rightImage withRightTitle:(NSString*)RightTitle withFrame:(CGRect)frame

{
    if (self = [super initWithFrame:frame])
        
    {
        UIView * baseView = [[UIView alloc]initWithFrame:frame];
        
        baseView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        
        //        baseView.userInteractionEnabled = YES ;
        
        
        
        [self addSubview:baseView];
        
        
        if (LeftImge != nil)
        {
            UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(20, 36, 7, 11)];
            imagev.image = [UIImage imageNamed:LeftImge];
            [self addSubview:imagev];
            
            self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftButton.frame = CGRectMake(0, 20, 44, 44);
            [self addSubview:self.leftButton];
            //            self.leftButton.backgroundColor = [UIColor blackColor];
        }
        
        if (rightImage !=nil)
        {
            UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20 - 7 , 36, 7, 11)];
            
            imagev.image = [UIImage imageNamed:LeftImge];
            [self addSubview:imagev];
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.frame = CGRectMake(ScreenWidth - 54, 20, 44, 44);
            [self addSubview:self.rightButton];
        }
        else if (rightImage ==nil)
        {
            if (RightTitle != nil)
            {

                self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.rightButton.frame = CGRectMake(ScreenWidth - 54, 20, 44, 44);
                [self.rightButton setTitle:RightTitle forState:UIControlStateNormal];
                [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
                
                
                self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
                self.rightButton.titleLabel.textAlignment =1 ;
                
                
                
                [self addSubview:self.rightButton];

            }
        }
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50 , 20, ScreenWidth-100, 44)];
        self.titleLabel.text = title ;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment =1 ;
        self.titleLabel.textColor = [UIColor blackColor ] ;
        [self addSubview:self.titleLabel];
        
        
        //        UIView * statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        //        statusBarView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        //        [self addSubview:statusBarView];
        
        
        
    }
    
    
    return self;
    
}



@end
