//
//  DBCityStoreViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^storeChooseBlock)(NSDictionary * city,NSString * index);

@interface DBCityStoreViewController : UIViewController

@property (nonatomic,strong)NSString * cityId;
@property (nonatomic,strong)NSString * cityName;

@property (nonatomic,strong)NSString * index ;

@property (nonatomic,strong)storeChooseBlock storeChooseBlock;

@end
