//
//  DBOrderPayViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/4/21.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCarModel.h"
#import "DBNewFreeRideModel.h"


@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}





@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;


@end



@interface DBOrderPayViewController : UIViewController




//车辆信息
@property (nonatomic,strong)DBCarModel * model ;
@property (nonatomic,strong)DBNewFreeRideModel * freeRideModel ;

//价格信息
@property (nonatomic,strong)NSDictionary * priceDic ;

@property (nonatomic)NSInteger  orderIndex ;


@property(nonatomic,strong)NSString *carInfo;
@property(nonatomic,strong)NSString *useDays;
@property(nonatomic,strong)NSString *orderNumber;
@property(nonatomic,strong)NSString *totalCost;
@property(nonatomic,strong)NSString * payWay;


@end
