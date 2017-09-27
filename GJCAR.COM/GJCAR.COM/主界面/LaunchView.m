//
//  LaunchViewController.m
//  GJCAR.COM
//
//  Created by inCar on 2017/9/22.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "LaunchView.h"



@implementation LaunchView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithWhite:0.2 alpha:0.8];
        
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"nationalDayActivity"] forState:UIControlStateNormal];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(100);
            make.left.equalTo(self).offset(50);
            make.bottom.equalTo(self).offset(-110);
            make.right.equalTo(self).offset(-50);
        }];
        [button addTarget:_delegate action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(25);
            make.centerX.equalTo(button);
            make.width.mas_offset(30);
            make.height.mas_offset(30);
        }];
        [deleteButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)deleteBtnClick{
    [self removeFromSuperview];
}






@end
