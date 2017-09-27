//
//  DCCouponModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/9/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBCouponModel : JSONModel

@property (strong, nonatomic) NSString<Optional>* amount;
@property (strong, nonatomic) NSString<Optional>* title;

@property (strong, nonatomic) NSString<Optional>* id;

@end
