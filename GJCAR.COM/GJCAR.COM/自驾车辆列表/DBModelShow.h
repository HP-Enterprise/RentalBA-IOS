//
//  DBModelShow.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/22.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBModelShow : JSONModel

@property (strong, nonatomic) NSString<Optional>* brandId;
@property (strong, nonatomic) NSString<Optional>* carGroup;
@property (strong, nonatomic) NSString<Optional>* carTrunk;
@property (strong, nonatomic) NSString<Optional>* createDate;
@property (strong, nonatomic) NSString<Optional>* createUser;
@property (strong, nonatomic) NSString<Optional>* displacement;
@property (strong, nonatomic) NSString<Optional>* fuel;
@property (strong, nonatomic) NSString<Optional>* gear;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* isEnable;
@property (strong, nonatomic) NSString<Optional>* licenseType;
@property (strong, nonatomic) NSString<Optional>* model;
@property (strong, nonatomic) NSString<Optional>* modifyDate;
@property (strong, nonatomic) NSString<Optional>* modifyUser;
@property (strong, nonatomic) NSString<Optional>* picture;
@property (strong, nonatomic) NSString<Optional>* plateType;
@property (strong, nonatomic) NSString<Optional>* seats;
@property (strong, nonatomic) NSString<Optional>* seriesId;


@end
