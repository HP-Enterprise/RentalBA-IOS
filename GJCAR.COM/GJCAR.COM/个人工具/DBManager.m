//
//  DBManager.m
//  FMDB
//
//  Created by MS on 15/12/24.
//  Copyright © 2015年 LjxProduct. All rights reserved.
//

#import "DBManager.h"



static DBManager * manager;
@implementation DBManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc]init];
    });
    return manager;
}
-(instancetype)init{
    
    if (self = [super init]) {
        //创建数据库
        //
        //_db = [FMDatabase alloc]initWithPath:<#(NSString *)#>
     NSArray * paths=    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString * documentPath= paths[0];
     NSString * _path =[documentPath stringByAppendingString:@"/user.db"];
        
        
        
    NSLog(@"path==%@",_path);
        
    _db = [FMDatabase databaseWithPath:_path];
        
        if ([_db open]) {
            //第一次是创建成功
            
            NSLog(@"打开成功");
            //开始创建表格
            //字段自定义名字
            
            //创建用户表格
            BOOL isFinish = [_db executeUpdate:@"create table if not exists user(record_id integer PRIMARY KEY,id varchar(0),nickName varchar(0),realName varchar(0),gender varchar(0),birth varchar(0),country varchar(0),address varchar(0),postCode varchar(0),phone varchar(0),email varchar(0),emailStatus varchar(0),credentialType varchar(0),credentialNumber varchar(0),contactPerson varchar(0),contactPhone varchar(0),registerWay varchar(0),customerSource varchar(0),modifyDate varchar(0),createDate varchar(0),createUser varchar(0),isEnable varchar(0),userName varchar(0),passWord varchar(0),token varchar(0))"];

            if (isFinish) {
                NSLog(@"创建表成功");
                //打开成功
            }else{
                NSLog(@"创建表失败");
            }

            
            //创建订单信息表格
            BOOL isCreate = [_db executeUpdate:@"create table if not exists orderInfo(record_id integer PRIMARY KEY,id varchar(0),takeCarDate varchar(0),returnCarDate varchar(0),takeCarTime varchar(0),returnCarTime varchar(0))"];
            if (isCreate) {
                NSLog(@"创建表成功");
                //打开成功
            }else{
                NSLog(@"创建表失败");
            }

            
            
            
            
        }else{
            NSLog(@"打开失败");
        }
 
    }
    
    
    
    
    
    
    return self;
}




-(void)addUserInfoWithModel:(DBUserInfoModel*)model
{
    
    
    
    
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    
    FMResultSet * set = [_db executeQuery:@"select * from user where id = ?",model.id];
    while ([set next]) {
        
        dic[@"userName"]  = [set stringForColumn:@"userName"];
        dic[@"phone"] = [set stringForColumn:@"phone"];
    }
    

    
    if (dic.count == 0 )
    {
        
        [self deletAll];
        
        if (model.realName != nil && model.credentialNumber!= nil) {
            BOOL isInsert = [_db executeUpdate:@"insert into user (id,nickName,phone,realName,credentialNumber) values(?,?,?,?,?)",model.id,model.nickName,model.phone,model.realName,model.credentialNumber];
            if (isInsert) {
                NSLog(@"新用户插入成功");
            }else{
                NSLog(@"插入失败");
            }

        }

        else
        {
            BOOL isInsert = [_db executeUpdate:@"insert into user (id,nickName,phone) values(?,?,?)",model.id,model.nickName,model.phone];
            if (isInsert) {
                NSLog(@"新用户插入成功");
            }else{
                NSLog(@"插入失败");
            }

            
        }

        NSLog(@"没找到");
    }
    
    else
    {

        
        
        
    }
    
    
   
}




//增加用户数据
- (void)addUserValueUserid:(NSString*)uid WithUserName:(NSString*)name andPaw:(NSString*)paw andToken:(NSString*)token {
    BOOL isInsert = [_db executeUpdate:@"insert into user (id,userName,passWord,token) values(?,?,?,?)",uid,name,paw,token];
    if (isInsert) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}



//增加订单数据
- (void)addOrderTimeWithValueTakeCarDate:(NSString*)takeCarDate withReturnCarDate:(NSString*)returnCarDate withTakeCarTime:(NSString*)takeTime withReturnTime:(NSString*)returnTime withID:(NSString*)ID{
    BOOL isInsert = [_db executeUpdate:@"insert into orderInfo (id,takeCarDate,returnCarDate,takeCarTime,returnCarTime) values(?,?,?,?,?)",takeCarDate,returnCarDate,takeTime,returnTime];
    if (isInsert) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
}

//修改时间参数
- (void)changeTakeCarDate:(NSString*)takeCarDate withID:(NSString*)ID
{
    
     BOOL isInsert = [_db executeUpdate:@"update orderInfo set takeCarDate = ? where record_id = ?",takeCarDate,@"1"];
    if (isInsert) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}

//修改时间参数
- (void)changeReturnCarDate:(NSString*)returnCarDate withID:(NSString*)ID
{
    BOOL isInsert = [_db executeUpdate:@"update orderInfo set returnCarDate=?  where record_id=?",returnCarDate,ID];
    if (isInsert) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}


//修改时间参数
- (void)changeTakeCarTime:(NSString*)takeTime withID:(NSString*)ID
{
    BOOL isInsert = [_db executeUpdate:@"update orderInfo set takeTime=?  where id=?",takeTime,ID];
    if (isInsert) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}


//修改时间参数
- (void)changeReturnTime:(NSString*)returnTime withID:(NSString*)ID
{
    BOOL isInsert = [_db executeUpdate:@"update orderInfo set returnTime=?  where record_id=?",returnTime,ID];
    if (isInsert) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}


//withReturnCarDate:(NSString*)returnCarDate withTakeCarTime:(NSString*)takeTime withReturnTime:(NSString*)returnTime

//修改昵称参数
- (void)changeNckNameWithValue:(NSString*)Value withID:(NSString*)userId
{
    BOOL isInsert = [_db executeUpdate:@"update user set nickName=? where id=?",Value,userId];
    if (isInsert) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}

//按条件查找数据
- (NSDictionary*)searchWithUserId:(NSString*)UserId{
    
    
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];

    FMResultSet * set = [_db executeQuery:@"select * from user where id = ?",UserId];
    while ([set next]) {

       dic[@"userName"]  = [set stringForColumn:@"userName"];
       dic[@"phone"] = [set stringForColumn:@"phone"];
    }
    
    if (dic.count == 0 )
    {
        
        
        NSLog(@"没找到");
    }
    
    return dic ;
}
//全部查找
- (NSDictionary*)searchAll{
    FMResultSet * set = [_db executeQuery:@"select * from user"];
    
    
    NSMutableDictionary * dic =[NSMutableDictionary dictionary];
    while ([set next]) {
        
        
        dic[@"nickName"] = [set stringForColumn:@"nickName"];
        dic[@"phone"] = [set stringForColumn:@"phone"];
        dic[@"realName"] = [set stringForColumn:@"realName"];
        dic[@"credentialNumber"]  = [set stringForColumn:@"credentialNumber"];
        
    }
    
    
    
    return [NSDictionary dictionaryWithDictionary:dic];
}
//正序查找
- (void)searchLIMIT{
    
    
  FMResultSet * set = [_db executeQuery:@"select * from user order by record_id LIMIT 1,4"];
    
    while ([set next]) {
        NSLog(@"%@-%@-%d",[set stringForColumn:@"name"],[set stringForColumn:@"score"],[set intForColumn:@"record_id"]);
    }
    
}
//倒序查找
- (void)searchdescLIMIT{
    FMResultSet * set = [_db executeQuery:@"select * from user order by record_id DESC LIMIT 1,4"];
    
    while ([set next]) {
        NSLog(@"%@-%@-%d",[set stringForColumn:@"name"],[set stringForColumn:@"score"],[set intForColumn:@"record_id"]);
    }
}
//按条件删除
- (void)deletWith:(NSString*)name{
    
   BOOL isDelet = [_db executeUpdate:@"delete from user where name = ? and record_id = ?",name,@"3"];
    if (isDelet) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

- (void)updata:(NSString*)name{
    
    [_db executeUpdate:@"updata user "];
    
}
//全部删除
- (void)deletAll{
    
    BOOL isdeleteAll = [_db executeUpdate:@"delete from user"];
    
    if (isdeleteAll) {
        NSLog(@"删除全部成功");
    }else{
        NSLog(@"删除全部失败");
    }
}
@end
