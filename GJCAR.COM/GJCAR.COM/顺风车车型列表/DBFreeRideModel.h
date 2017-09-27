//
//  DBFreeRideModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"
#import "DBFreeRideReturnCarStoreShowsModel.h"

#import "DBvehicleShowModel.h"

#import "DBreturnCarCityShowModel.h"



#import "DBtakeCarCityShowModel.h"
#import "DBtakeCarStoreShowModel.h"







@interface DBFreeRideModel : JSONModel



@property(nonatomic,strong)NSString <Optional>* price ;
@property (strong, nonatomic) NSString<Optional>* takeCarDateEnd;
@property (strong, nonatomic) NSString<Optional>* takeCarDateStart;
@property (strong, nonatomic) NSString<Optional>* takeCarStoreId;
@property (strong, nonatomic) NSString<Optional>* maxRentalDay;
@property (strong, nonatomic) NSString<Optional>* maxMileage;
@property (strong, nonatomic) NSString<Optional>* id;


@property(nonatomic,strong)DBvehicleShowModel * vehicleShow ;
@property(nonatomic,strong)DBtakeCarStoreShowModel * takeCarStoreShow ;
@property(nonatomic,strong)DBtakeCarCityShowModel * takeCarCityShow ;
@property(nonatomic,strong)DBreturnCarCityShowModel * returnCarCityShow ;
//@property(nonatomic,strong)NSArray <DBFreeRideReturnCarStoreShowsModel>*returnCarStoreShows ;

@end
