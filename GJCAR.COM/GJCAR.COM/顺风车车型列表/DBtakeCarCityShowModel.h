//
//  DBtakeCarCityShowModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBtakeCarCityShowModel : JSONModel



@property (strong, nonatomic) NSString<Optional>* cityName;
@property (strong, nonatomic) NSString<Optional>* cityNum;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* isHot;

@property (strong, nonatomic) NSString<Optional>* latitude;
@property (strong, nonatomic) NSString<Optional>* longitude;


//@property (strong, nonatomic) NSString* permit;
//@property (strong, nonatomic) NSString* pid;
//@property (strong, nonatomic) NSString* plate;
//@property (strong, nonatomic) NSString* plateType;
//@property (strong, nonatomic) NSString* sid;
//
//@property (strong, nonatomic) NSString* state;
//@property (strong, nonatomic) NSString* storesId;


@end
