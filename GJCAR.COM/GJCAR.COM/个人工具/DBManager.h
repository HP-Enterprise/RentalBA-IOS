//
//  DBManager.h
//  FMDB
//
//  Created by MS on 15/12/24.
//  Copyright © 2015年 LjxProduct. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "DBUserInfoModel.h"

@interface DBManager : NSObject
{
    
    FMDatabase * _db;
}

+(instancetype)shareManager;



-(void)addUserInfoWithModel:(DBUserInfoModel*)model;
//增加用户数据
- (void)addUserValueUserid:(NSString*)uid WithUserName:(NSString*)name andPaw:(NSString*)paw andToken:(NSString*)token;
//修改参数
- (void)changeNckNameWithValue:(NSString*)Value withID:(NSString*)userId;




//增加订单数据
- (void)addOrderTimeWithValueTakeCarDate:(NSString*)takeCarDate withReturnCarDate:(NSString*)returnCarDate withTakeCarTime:(NSString*)takeTime withReturnTime:(NSString*)returnTime withID:(NSString*)ID;
//修改时间参数
- (void)changeTakeCarDate:(NSString*)takeCarDate withID:(NSString*)ID;

//修改时间参数
- (void)changeReturnCarDate:(NSString*)returnCarDate withID:(NSString*)ID;

//修改时间参数
- (void)changeTakeCarTime:(NSString*)takeTime withID:(NSString*)ID;

//修改时间参数
- (void)changeReturnTime:(NSString*)returnTime withID:(NSString*)ID;

//查找全部
- (NSDictionary*)searchAll;
//按条件查找数据
- (NSDictionary*)searchWithUserId:(NSString*)UserId;
//全部删除
- (void)deletAll;



@end
