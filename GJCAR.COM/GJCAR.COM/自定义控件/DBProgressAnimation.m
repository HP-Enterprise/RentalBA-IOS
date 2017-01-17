//
//  DBProgressAnimation.m
//  ShenHuaCar
//
//  Created by 段博 on 16/5/6.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBProgressAnimation.h"

@implementation DBProgressAnimation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)addProgressAnimationWithViewControl:(UIViewController*)viewControl
{
    if (_progress == nil)
    {

        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        [viewControl.view addSubview:_backView];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.alpha = 1 ;
        
        
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 25 , ScreenHeight/3 - 40, 50, 50)];
        
        backView.backgroundColor = [UIColor grayColor];
        backView.layer.cornerRadius = 5;
        [_backView addSubview:backView];

        
        UILabel * title  = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(backView.frame)+10 ,ScreenWidth , 20)];
        title.text = @"加载数据" ;
        title.textAlignment = 1 ;
        title.font = [UIFont systemFontOfSize:13];
//        [_backView addSubview:title];
        
        
        _progress = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];

        [backView addSubview:_progress];
        
        NSMutableArray * imageArray = [NSMutableArray array];
        for (int i = 0; i < 8; i++)
        {
            NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"progress%d",i+1] ofType:@"png"] ;
            UIImage * image = [UIImage imageWithContentsOfFile:path] ;
            [imageArray addObject:image] ;
        }

        [_progress setAnimationImages:imageArray];
        
        //设置帧动画的图片
        _progress.animationImages = imageArray ;
        
        //动画时间
        _progress.animationDuration =8 * 0.1;
        
        //设置动画的重复次数
        _progress.animationRepeatCount = 0 ;
        
        //开启动画
        [_progress startAnimating] ;
        

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_progress.isAnimating)
            {
                
                [self removeProgressAnimation];
            }
            
        });
    }
}


-(void)removeProgressAnimation
{

    [UIView animateWithDuration:0.5 animations:^{
        CGFloat alpha = _progress.alpha ;
        alpha = 0 ;
        _progress.alpha = alpha;
        _backView.alpha = alpha ;
        
    } completion:^(BOOL finished) {
        
        [_progress removeFromSuperview];
        [_backView removeFromSuperview];
        _progress = nil ;
    }];
    
    
    
    
}

@end
