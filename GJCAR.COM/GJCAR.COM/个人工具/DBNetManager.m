//
//  DBNetManager.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/27.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBNetManager.h"

@implementation DBNetManager


//创建网络监测单例
+ (DBNetManager *)sharedManager

{
    static DBNetManager * netManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        netManager = [[self alloc] init];
    });
    
    return netManager;
}


@end
