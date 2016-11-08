
//
//  DBShowListModel.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBShowListModel.h"

@implementation DBShowListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"avgShow.avgAmount": @"avgAmount",
                                                       @"avgShow.basicInsuranceAmount": @"basicInsuranceAmount",
                                                       @"avgShow.delayAmount": @"delayAmount",
                                                       @"avgShow.modelId": @"modelId",
                                                       @"avgShow.prepayAmount": @"prepayAmount",
                                                       @"avgShow.storeId": @"storeId",
                                                       @"avgShow.totalAmount": @"totalAmount",
                                                       @"avgShow.totalDay": @"totalDay",
                                                        @"avgShow.activityShow": @"activityShow",
                                                        @"avgShow.activityShows": @"activityShows",
                                                       
                                                       
                                                       
                                                       //storeShow
                                                       @"storeShow.id": @"id",
                                                       
//                                                        @"storeShow.businessHoursEnd": @"businessHoursEnd",
//                                                        @"storeShow.businessHoursStart": @"businessHoursStart",
 
                                                       }];
}


@end
