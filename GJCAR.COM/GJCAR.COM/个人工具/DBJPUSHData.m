//
//  DBJPUSHData.m
//  GJCARDRIVER
//
//  Created by 段博 on 2016/11/16.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBJPUSHData.h"

@implementation DBJPUSHData

+(instancetype)shareDBJPUSHData
{
    static DBJPUSHData *JPushdata;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JPushdata = [[DBJPUSHData alloc]init];
        
    });

    return JPushdata ;
}


-(instancetype)init
{
    if (self == [super init]) {
        
        
        
        self.notificationArray = [NSMutableArray array];
    }
    return self;
}

-(void)addNotification:(NSDictionary*)dic{
    [self.notificationArray addObject:dic];
    DBLog(@"%@ %ld",self.notificationArray,self.notificationArray.count);
}


-(void)removeAllNotification{
    
    [self.notificationArray removeAllObjects];
}


@end
