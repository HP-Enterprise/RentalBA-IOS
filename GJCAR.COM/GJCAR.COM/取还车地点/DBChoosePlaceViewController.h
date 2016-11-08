//
//  DBChoosePlaceViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/17.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface DBChoosePlaceViewController : UIViewController

typedef void (^placeChooseBlock)(NSDictionary * city,NSString * index);

@property (nonatomic,strong)NSString * index ;

@property (nonatomic,strong)NSString * city ;

//城市信息
@property (nonatomic,strong)NSDictionary * takeCityInfoDic ;


@property (nonatomic,strong)placeChooseBlock placeChooseBlock ;

//当前位置坐标
@property (nonatomic)CLLocationCoordinate2D coor ;
@end
