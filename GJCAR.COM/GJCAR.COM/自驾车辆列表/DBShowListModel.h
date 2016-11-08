//
//  DBShowListModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

#import "DBActivityShows.h"



@interface DBShowListModel : JSONModel


@property (strong, nonatomic) NSString<Optional>* avgAmount;
@property (strong, nonatomic) NSString<Optional>* basicInsuranceAmount;
@property (strong, nonatomic) NSString<Optional>* delayAmount;
@property (strong, nonatomic) NSString<Optional>* modelId;
@property (strong, nonatomic) NSString<Optional>* prepayAmount;
@property (strong, nonatomic) NSString<Optional>* storeId;
@property (strong, nonatomic) NSString<Optional>* totalAmount;
@property (strong, nonatomic) NSString<Optional>* totalDay;


@property (strong, nonatomic) NSDictionary<Optional>* activityShow ;
@property (strong, nonatomic) NSArray<Optional>* activityShows ;



@property (strong, nonatomic) NSString<Optional>* id;





//@property (assign, nonatomic) NSString* brandId;
//@property (assign, nonatomic) NSString* carGroup;



@end
