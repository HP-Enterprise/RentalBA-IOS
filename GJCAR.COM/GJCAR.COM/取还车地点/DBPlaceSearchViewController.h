//
//  DBPlaceSearchViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/1.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^placeBlock)(NSDictionary * city);


@interface DBPlaceSearchViewController : UIViewController
//城市信息
@property (nonatomic,strong)NSDictionary * takeCityInfoDic ;


//搜索范围经纬度
@property (nonatomic,strong)NSArray * serveScopeArray;


@property (nonatomic,strong)placeBlock placeBlock ;



@end
