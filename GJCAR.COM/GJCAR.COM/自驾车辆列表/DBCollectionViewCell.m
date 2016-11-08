//
//  CollectionViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCollectionViewCell.h"

@implementation DBCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        
    }
    
    return self;
}


-(void)createUI
{
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0 , 0 , ScreenWidth/7, 0.5)];
//    line.backgroundColor = [DBcommonUtils getColor:@"9e9e9f"] ;
//    [self addSubview:line];
//    
//    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/7, 0, 0.5, ScreenWidth/7)];
//    line2.backgroundColor = [DBcommonUtils getColor:@"9e9e9f"] ;
//    [self addSubview:line2];
//    
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/14, ScreenWidth/14)];
    self.dateLabel.textAlignment= 1 ;
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.dateLabel];
    
    
    self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWidth/7/3, ScreenWidth/7, ScreenWidth/7*2/3)];
    self.priceLable.textAlignment= 1 ;
    self.priceLable.font = [UIFont systemFontOfSize:11];
    self.priceLable.textColor = [UIColor colorWithRed:0.5 green:0.51 blue:0.49 alpha:1] ;
    [self.contentView addSubview:self.priceLable];


    
    
    
}

-(void)config:(NSArray*)array
{
  
    
    [self createUI];
    


    
}


@end
