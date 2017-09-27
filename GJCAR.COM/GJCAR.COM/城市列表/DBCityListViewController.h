//
//  DBCityListViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cityChooseBlock)(NSDictionary * city,NSString * index);

@interface DBCityListViewController : UIViewController


//记录取车还是还车
@property (nonatomic,strong)NSString * index ;



//顺风车类型
//记录驾车类型 0自驾  1带驾  2顺风车  3长租
@property (nonatomic,assign)NSInteger  indexKind ;
//取车城市id
@property (nonatomic,strong)NSString * cityId;


@property (nonatomic,strong)cityChooseBlock cityChooseBlock ;

@end
