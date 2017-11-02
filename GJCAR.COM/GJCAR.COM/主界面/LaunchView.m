//
//  LaunchViewController.m
//  GJCAR.COM
//
//  Created by inCar on 2017/9/22.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "LaunchView.h"



@implementation LaunchView


- (instancetype)initWith:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithWhite:0.2 alpha:0.8];
        UIButton *button = [[UIButton alloc]init];
//        [button setBackgroundImage:[UIImage imageNamed:@"nationalDayActivity"] forState:UIControlStateNormal];
//        [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,dic[@"picUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nationalDayActivity"]];

        [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://182.61.22.210:8081%@",dic[@"picUrl"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nationalDayActivity"]];
        [self addSubview:button];

        CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.8;
        CGFloat height = width * 560 / 510;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(100);
//            make.left.equalTo(self).offset(left);
//            make.bottom.equalTo(self).offset(-110);
//            make.right.equalTo(self).offset(-left);
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.center.equalTo(self);
        }];
//        [button addTarget:_delegate action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        button.clipsToBounds = YES;

        UIButton *submitButton = [[UIButton alloc]init];
        [submitButton setBackgroundColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1]];
        [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [submitButton setTitle:@"朕 去 试 试"forState:UIControlStateNormal];
        [self addSubview:submitButton];
        [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(-80);
            make.centerX.equalTo(button);
            make.width.mas_offset(width * 0.7);
            make.height.mas_offset(30);
        }];
        submitButton.layer.cornerRadius = 5;
        submitButton.layer.masksToBounds = YES;
        submitButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [submitButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *deleteButton = [[UIButton alloc]init];
//        [deleteButton setImage:[UIImage imageNamed:@"delete"]
//    forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        deleteButton.titleLabel.font =[UIFont systemFontOfSize:12];
        [deleteButton setTitle:@"朕知道了"forState:UIControlStateNormal];
        [self addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(-45);
            make.centerX.equalTo(button);
            make.width.mas_offset(100);
            make.height.mas_offset(20);
        }];
        [deleteButton addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)deleteBtnClick{
    [self removeFromSuperview];
}






@end
