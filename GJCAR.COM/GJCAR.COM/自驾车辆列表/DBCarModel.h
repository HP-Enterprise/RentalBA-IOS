//
//  DBCarModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

#import "DBShowListModel.h"
#import "DBModelShow.h"


@protocol DBShowListModel<NSObject>
@end



@interface DBCarModel : JSONModel


@property (nonatomic,strong)DBModelShow * vehicleModelShow ;

@property (strong,nonatomic) NSArray<DBShowListModel>*vendorStorePriceShowList;
//@property (strong, nonatomic) NSString* carTrunk;
//@property (assign, nonatomic) NSString* displacement;
//@property (assign, nonatomic) NSString* fuel;
//@property (strong, nonatomic) NSString* gear;
//@property (assign, nonatomic) NSString* id;
//@property (assign, nonatomic) NSString* licenseType;
//@property (strong, nonatomic) NSString* model;
//@property (assign, nonatomic) NSURL* picture;
//@property (assign, nonatomic) NSString* plateType;
//@property (strong, nonatomic) NSString* seats;
//@property (assign, nonatomic) NSString* seriesId;
//
//
//
////价格

@end
