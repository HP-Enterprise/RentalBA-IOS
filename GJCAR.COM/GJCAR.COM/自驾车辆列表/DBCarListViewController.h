//
//  DBCarListViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^changeMonthBlock)(NSString*);


@interface DBCarListViewController : UIViewController

//取车城市地点信息
@property (nonatomic,strong)NSDictionary * takeCityInfoDic ;
@property (nonatomic,strong)NSDictionary * takePlaceInfoDic ;

@property (nonatomic,strong)NSDictionary * takeStoreInfoDic;

//还车城市信息

@property (nonatomic,strong)NSDictionary * returnCityInfoDic ;
@property (nonatomic,strong)NSDictionary * returnPlaceInfoDic ;

@property (nonatomic,strong)NSDictionary * returnStoreInfoDic;


@property (nonatomic,weak)changeMonthBlock  changeMonthBlock;

@end
