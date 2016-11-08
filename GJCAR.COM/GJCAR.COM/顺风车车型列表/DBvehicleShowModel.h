//
//  DBvehicleShowModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

#import "DBvehicleModelShowModel.h"

@interface DBvehicleShowModel : JSONModel

//"bid" : 1,
//"business" : null,
//"colour" : "红色",
//"description" : "已失效",
//"gps" : "GPS005",
//"id" : 2,
//
//
//"mileage" : 1000,
//"modelId" : 3,
//"obd" : "OBD005",
//"oil" : "15L",
//
//"permit" : "LIC005",
//"pid" : 1,
//"plate" : "鄂AE2354",
//"plateType" : "普通牌",
//"sid" : 3,
//
//"state" : "locked",
//"storesId" : 1,
//
//"vehicleBrandShow" : null,
//"vehicleIdShow" : null,
//"vehicleModelShow" : {
//    "brandId" : 2,
//    "carGroup" : 3,
//    "carTrunk" : 1,
//    "createDate" : 1467451677000,
//    "createUser" : "",
//    "displacement" : "2.5L",
//    "fuel" : 1,
//    "gear" : "1",
//    "id" : 3,
//    "isEnable" : "1",
//    "licenseType" : 6,
//    "model" : "宝斯通-v1",
//    "modifyDate" : 1467451677000,
//    "modifyUser" : "",
//    "picture" : "",
//    "plateType" : 4,
//    "seats" : 5,
//    "seriesId" : 9,
//    "vehicleBrandShow" : {
//        "brand" : "安凯客车",
//        "id" : 2
//    },
//    "vehicleSeriesShow" : {
//        "id" : 9,
//        "series" : "宝斯通"
//    }

//
@property (strong, nonatomic) NSString<Optional>* bid;
@property (strong, nonatomic) NSString<Optional>* business;
@property (strong, nonatomic) NSString<Optional>* colour;
@property (strong, nonatomic) NSString<Optional>* gps;
    
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* mileage;
@property (strong, nonatomic) NSString<Optional>* modelId;
@property (strong, nonatomic) NSString<Optional>* obd;
@property (strong, nonatomic) NSString<Optional>* oil;
    
@property (strong, nonatomic) NSString<Optional>* permit;
@property (strong, nonatomic) NSString<Optional>* pid;
@property (strong, nonatomic) NSString<Optional>* plate;
@property (strong, nonatomic) NSString<Optional>* plateType;
@property (strong, nonatomic) NSString<Optional>* sid;

@property (strong, nonatomic) NSString<Optional>* state;
@property (strong, nonatomic) NSString<Optional>* storesId;
@property (strong, nonatomic) DBvehicleModelShowModel * vehicleModelShow;






@end
