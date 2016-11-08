//
//  DBOrderSubmitViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBCarModel.h"

@interface DBOrderSubmitViewController : UIViewController

@property(nonatomic,strong)NSString * payWay;
//车辆信息
@property (nonatomic,strong)DBCarModel * model ;
//价格信息
@property (nonatomic,strong)NSDictionary * priceDic ;

@property (nonatomic,strong)NSDictionary * activityDic ;
//增值服务
@property (nonatomic,strong)NSArray * addValueArr;

@end
