//
//  DBOrderPriceViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/7/31.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCarModel.h"


@protocol activityChangedelegate <NSObject>

-(void)activitChange:(NSString*)index;

@end
@interface DBOrderPriceViewController : UIViewController
@property(nonatomic,strong)NSString * payWay;
//车辆信息
@property (nonatomic,strong)DBCarModel * model ;
//价格信息
@property (nonatomic,strong)NSDictionary * priceDic ;

@property (nonatomic,strong)NSDictionary * addvalue;
@property (nonatomic,assign)BOOL isChoose;
@property (nonatomic,copy)NSString * index;
@property (nonatomic,strong)NSDictionary * activityDic ;
//增值服务
@property (nonatomic,strong)NSArray * addValueArr;


@property (nonatomic,strong)id<activityChangedelegate>delegate;
@end
