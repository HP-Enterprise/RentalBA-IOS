//
//  DBJPUSHData.h
//  GJCARDRIVER
//
//  Created by 段博 on 2016/11/16.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBJPUSHData : NSObject

@property (nonatomic,strong)NSMutableArray * notificationArray;



+(instancetype)shareDBJPUSHData;
//添加通知
-(void)addNotification:(NSDictionary*)dic;
//删除所有通知
-(void)removeAllNotification ;

@end
