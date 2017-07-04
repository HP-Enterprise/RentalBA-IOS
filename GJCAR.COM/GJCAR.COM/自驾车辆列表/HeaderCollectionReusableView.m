//
//  HeaderCollectionReusableView.m
//  UICollectionView
//
//  Created by smith on 15/12/10.
//  Copyright © 2015年 smith. All rights reserved.
//

#import "HeaderCollectionReusableView.h"




@implementation HeaderCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *  priceView = [[UIView alloc]initWithFrame:frame];
        priceView.backgroundColor = [UIColor colorWithRed:0.94 green:0.97 blue:1 alpha:1];
        
        
        NSArray * weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        
        for (int i = 0; i < 7; i++)
            
        {
            
            UILabel * weekView= [[UILabel alloc]initWithFrame:CGRectMake(i * ScreenWidth/7, 20, ScreenWidth/7, ScreenWidth/7 - 20)];
            weekView.textAlignment = 1;
            weekView.text = weekArray[i];
//            weekView.backgroundColor =[UIColor colorWithRed:0.94 green:0.97 blue:1 alpha:1];
            weekView.font = [UIFont systemFontOfSize:12];
            [priceView addSubview:weekView];
            
            
            if (i == 0 || i == 6)
            {
                weekView.textColor =[UIColor redColor];
            }
        
            
        }
        
        [self addSubview:priceView];
        
        _lastBt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_lastBt setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        _lastBt.frame = CGRectMake(50 , 0, 20, 20);


        [_lastBt addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lastBt];
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lastBt.frame), 0, frame.size.width - 2*CGRectGetMaxX(_lastBt.frame) , 20)];
        
        _timeLabel.textAlignment  =1 ;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor blackColor];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults ];
        
        NSString * date = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)] ;
        
        _timeLabel.text = date   ;
        
        
        [self addSubview:_timeLabel];
        

        _nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _nextBt.frame = CGRectMake(frame.size.width - 50, 0, 20, 20);
        [_nextBt addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
       
        [_nextBt setImage:[UIImage imageNamed:@"nextMonth"] forState:UIControlStateNormal];


        [self addSubview:_nextBt];


    }

   
    return self;
}


-(void )lastMonth
{
    self.changeMonthBlock(@"last");
//   [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadPrice" object:@"last"];
}

-(void)nextMonth
{
    self.changeMonthBlock(@"next");
//   [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadPrice" object:@"next"];
}



@end
