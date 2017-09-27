//
//  DBOrderServeViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBCarModel.h"

@interface DBOrderServeViewController : UIViewController


@property (nonatomic,strong)UISwitch * commissionSwitch;
@property (nonatomic,strong)UIControl * tipControl;
@property (nonatomic,strong)DBCarModel * model ;
@property (nonatomic,strong)NSDictionary * activityDic ;
@property (nonatomic,strong)NSString * activityId;

@property (nonatomic,strong)NSDictionary * addValueDic;
@property (nonatomic,copy)NSString * index;
@end
