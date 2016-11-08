//
//  DBreturnCarCityShowModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBreturnCarCityShowModel : JSONModel


@property (strong, nonatomic) NSString<Optional>* cityName;
@property (strong, nonatomic) NSString<Optional>* cityNum;
@property (strong, nonatomic) NSString<Optional>* id;
@property (strong, nonatomic) NSString<Optional>* isHot;

@property (strong, nonatomic) NSString<Optional>* latitude;
@property (strong, nonatomic) NSString<Optional>* longitude;


@end
