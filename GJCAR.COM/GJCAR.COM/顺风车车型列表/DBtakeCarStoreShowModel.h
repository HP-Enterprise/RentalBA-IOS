//
//  DBtakeCarStoreShowModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/4.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBtakeCarStoreShowModel : JSONModel

@property (strong, nonatomic) NSString<Optional>* available;
@property (strong, nonatomic) NSString<Optional>* businessHoursEnd;
@property (strong, nonatomic) NSString<Optional>* businessHoursStart;
@property (strong, nonatomic) NSString<Optional>* cityId;

@property (strong, nonatomic) NSString<Optional>* latitude;
@property (strong, nonatomic) NSString<Optional>* longitude;
@property (strong, nonatomic) NSString<Optional>* storeAddr;
@property (strong, nonatomic) NSString<Optional>* storeName;
//@property (strong, nonatomic) NSString* takeCarStoreId;


@end
