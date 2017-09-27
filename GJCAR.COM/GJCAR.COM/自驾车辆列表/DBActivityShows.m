//
//  DBActivityShows.m
//  GJCAR.COM
//
//  Created by 段博 on 16/9/9.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBActivityShows.h"

@implementation DBActivityShows


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"activityTypeShow.hostTypeDascribe":@"hostTypeDascribe",
                                                       }];
}


@end
