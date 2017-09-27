//
//  DBOrderModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/29.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

#import "DBActivityModel.h"
#import "DBCouponModel.h"
#import "DBModelShow.h"
@interface DBOrderModel : JSONModel



//@property (strong, nonatomic) NSString* activityId;
//@property (strong, nonatomic) NSString* activityShow;
@property (strong, nonatomic) NSString<Optional>* averagePrice;
@property (strong, nonatomic) NSString<Optional>* basicInsuranceAmount;
//@property (strong, nonatomic) NSString* brandId;

@property (strong, nonatomic) NSString<Optional>* carGroupstr;
@property (strong, nonatomic) NSString<Optional>* carTrunkStr;
@property (strong, nonatomic) NSString<Optional>* seatsStr;
//@property (strong, nonatomic) NSString* couponShowForAdmin;
//@property (strong, nonatomic) NSString* createDate;

//@property (strong, nonatomic) NSString* createUser;
//@property (strong, nonatomic) NSString* displacement;
//@property (strong, nonatomic) NSString* finishDate;
//@property (strong, nonatomic) NSString* fuelStr;
//@property (strong, nonatomic) NSString* gear;

//@property (strong, nonatomic) NSString* hasContract;
//@property (strong, nonatomic) NSString* id;
//@property (strong, nonatomic) NSString* isEnable;
//@property (strong, nonatomic) NSString* licenseTypeStr;
//@property (strong, nonatomic) NSString* maxMileage;

@property (strong, nonatomic) NSString<Optional>* model;
//@property (strong, nonatomic) NSString* modelId;
@property (strong, nonatomic) NSString<Optional>* orderId;
@property (strong, nonatomic) NSString<Optional>* orderState;
@property (strong, nonatomic) NSString<Optional>* orderType;
//
@property (strong, nonatomic) NSString<Optional>* payAmount;
@property (strong, nonatomic) NSString<Optional>* payWay;
@property (strong, nonatomic) NSString<Optional>* picture;
@property (strong, nonatomic) NSString<Optional>* poundageAmount;
@property (strong, nonatomic) NSString<Optional>* tenancyDays;

@property (strong, nonatomic) NSString<Optional>* timeoutPrice;
@property (strong, nonatomic) NSString<Optional>* totalTimeoutPrice;

//
@property (strong, nonatomic) NSString<Optional>* rentalAmount;
@property (strong, nonatomic) NSString<Optional>* returnCarAddress;
@property (strong, nonatomic) NSString<Optional>* returnCarCity;
@property (strong, nonatomic) NSString<Optional>* returnCarDate;
@property (strong, nonatomic) NSString<Optional>* returnCarStoreId;
//
@property (strong, nonatomic) NSString<Optional>* takeCarAddress;
@property (strong, nonatomic) NSString<Optional>* takeCarCity;
@property (strong, nonatomic) NSString<Optional>* takeCarDate;
@property (strong, nonatomic) NSString<Optional>* takeCarStoreId;

@property (strong, nonatomic) NSString<Optional>* hasContract;


@property (strong, nonatomic) DBActivityModel <Optional>* activityShow;

@property (strong, nonatomic) DBCouponModel <Optional>* couponShowForAdmin;

@property (nonatomic,strong)DBModelShow <Optional>* vehicleModelShow ;

@end
