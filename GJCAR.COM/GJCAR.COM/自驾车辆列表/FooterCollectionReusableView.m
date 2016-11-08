//
//  FooterCollectionReusableView.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "FooterCollectionReusableView.h"

@implementation FooterCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
//        UIView * baseview = [[UIView alloc]initWithFrame:frame];
//        baseview.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:1 alpha:1];
      
//        baseview.backgroundColor = [UIColor blackColor];
        

        
        
        self.premiumLabel  = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 0, ScreenWidth/2 , ScreenWidth/7 )];
        
        self.premiumLabel.text = @"保险费: 40/天" ;
        self.premiumLabel.font = [UIFont systemFontOfSize:12];
        self.premiumLabel.textAlignment = 1;
        self.premiumLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:1 alpha:1] ;
        
        
        self.costLabel =[[UILabel alloc]initWithFrame:CGRectMake( ScreenWidth/ 2  , 0, ScreenWidth/2  , ScreenWidth/7 )];
        
        self.costLabel.text = @"预授权: 3000" ;
        self.costLabel.font = [UIFont systemFontOfSize:12];
        self.costLabel.textAlignment = 1;
        self.costLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:1 alpha:1] ;
        
//        [self addSubview:self.premiumLabel];
//        [self addSubview:self.costLabel];
        
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = [DBcommonUtils getColor:@"9e9e9f"] ;
        [self addSubview:lineView];
        
//        [baseview addSubview:self.premiumLabel];
//        [baseview addSubview:self.costLabel];
        
        
//         [self addSubview:baseview];
        
    }
    return self;
}

@end
