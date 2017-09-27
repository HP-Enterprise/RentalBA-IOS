//
//  DBStoresListViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/7/18.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^storeChooseBlock)(NSDictionary * city,NSString * index);
@interface DBStoresListViewController : UIViewController

@property (nonatomic,strong)NSString * cityId;
@property (nonatomic,strong)NSString * cityName;

@property (nonatomic,strong)NSString * index ;

@property (nonatomic,strong)storeChooseBlock storeChooseBlock;
@end
