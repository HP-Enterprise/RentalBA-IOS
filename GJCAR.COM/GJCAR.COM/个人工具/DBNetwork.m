//
//  DBNetwork.m
//  GJCAR.COM
//
//  Created by 段博 on 2017/1/21.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "DBNetwork.h"

@implementation DBNetwork

// 用户首次激活
+ (void)activateStatisticalPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    
    url = [NSString stringWithFormat:@"%@/api/advertise/jf/ios/active",Host];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(success) {
            
            DBLog(@"%@",[responseObject objectForKey:@"message"]);
            success(responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            
            DBLog(@"%@",error);
            failure(error);
            
        }
    }];
}

// 用户注册
+ (void)sigUpStatisticalPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    
    url = [NSString stringWithFormat:@"%@/api/advertise/jf/ios/register",Host];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(success) {
            
            DBLog(@"%@",[responseObject objectForKey:@"message"]);
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            
            DBLog(@"%@",error);
            failure(error);
        }
    }];
}


@end
