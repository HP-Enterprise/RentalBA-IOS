//
//  DBRentalViews.m
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBRentalViews.h"

@implementation DBRentalViews

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(UIView*)createActiveViewWithFrame:(CGRect)frame{
    
    UIView * saleView ;
    
    
    
    UIView * grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    grayBackView.backgroundColor = [UIColor grayColor];
    grayBackView.alpha = 0.5 ;
    [saleView addSubview:grayBackView];
    
    
    // 白色背景
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(30, 150, ScreenWidth - 60, 250)];
    baseView.layer.cornerRadius = 5 ;
    baseView.layer.masksToBounds = YES ;
    baseView.backgroundColor = [UIColor whiteColor];
    [saleView addSubview:baseView];
    
    
    //活动背景
    UIView * remainBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseView.frame.size.width, 30)];
    remainBack.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [baseView addSubview:remainBack];
    
    
    //热门活动
    UILabel * remainLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.5 * remainBack.frame.size.width - 15, remainBack.frame.size.height)];
    remainLable.text =@"热门活动" ;
    remainLable.font = [UIFont systemFontOfSize:12];
    [remainBack addSubview:remainLable];
    
    
    
    saleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, baseView.frame.size.width, 190)style:UITableViewStylePlain];
    [baseView addSubview:saleTableView];
    
    saleTableView.showsVerticalScrollIndicator = NO ;
    saleTableView.showsHorizontalScrollIndicator = NO ;
    saleTableView.dataSource = self ;
    saleTableView.delegate = self ;
    saleTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    
    //确定按钮
    UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBt.frame = CGRectMake(0 , 220 , baseView.frame.size.width, 30);
    submitBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
    [submitBt setTitle:@"确定" forState:UIControlStateNormal];
    submitBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBt addTarget:self action:@selector(submitBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:submitBt];

    
    return saleView ;
}
@end
