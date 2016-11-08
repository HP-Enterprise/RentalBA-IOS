    //
//  DBNetTool.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBNetworkTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DBNetworkTool



#pragma mark md5加密

//加密
+(NSString *)getDictKeysValues:(NSDictionary *)dic{
    NSMutableString *pmv=[[NSMutableString alloc] init];
    for (int i=0; i<[[dic allKeys] count]; i++) {
        NSString *key1=[[dic allKeys] objectAtIndex:i];
        [pmv appendFormat:@"%@",[dic valueForKey:key1]];
    }
    NSString *ipmv = [NSString stringWithString:pmv];
    NSLog(@"ipmv=%@",ipmv);
    ipmv=[self md5Digest:ipmv];
    return ipmv;
}


+(NSString*)md5Digest:(NSString *)str{
    
    //32位MD5小写
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
}


// 登录
+ (void)signInPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id responseObject) {
        
        if(success) {
            success(responseObject);
        }
        
//        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//        AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
//        NSString *token = [userDefaultes objectForKey:@"autoken"];
//        [manager2.requestSerializer setValue:token forHTTPHeaderField:@"Cookie"];
//        NSString *URLString = [NSString stringWithFormat:@"%@/technician/pushId",Host];
//        NSString *pushId = [userDefaultes objectForKey:@"clientId"];
//        [manager2 POST:URLString parameters:@{@"pushId":pushId} success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//            NSLog(@"个推ID更新成功－－%@",responseObject);
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"---更新失败了－－%@",error);
//        }];
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了－－%@",error);
        if(failure) {
            failure(error);
        }
    }];
}

// get 方法调用
+ (void)Get:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
  
    
    
    
//    AFJSONResponseSerializer *response = (AFJSONResponseSerializer *)manager.responseSerializer;
//    response.removesKeysWithNullValues = YES;
//    
//    
    
//    [manager.requestSerializer setValue:@"475B963189D936F470C0F6E52C9B939A"forHTTPHeaderField:@"Cookie"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}


// POST 方法调用
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//
//    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"Cookie"];
//
//    NSLog(@"token打印出来了%@",[user objectForKey:@"token"]);
    
   

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}

//DELETE 方法调用
+ (void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];
    
    NSLog(@"注销 token打印出来了%@",[user objectForKey:@"token"]);

    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}


//  获取验证码
+ (void)codeValidatePOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}

// 验证验证码
- (void)verifyCodePUT:(NSString *)url parameters:(NSDictionary *)parameters  {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //
    //    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];
    //
    //    NSLog(@"token打印出来了%@",[user objectForKey:@"token"]);
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.verifyCodeBlock(responseObject);
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


// 注册
+ (void)verifyPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if(success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}


// 用户查询个人信息 方法调用
+ (void)getUserInfoGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];
    
    NSLog(@"查询个人信息 token打印出来了%@",[user objectForKey:@"token"]);
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}

// 更改个人信息
- (void)changeUserInfoPUT:(NSString *)url parameters:(NSDictionary *)parameters  {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];
    
    
    NSLog(@"token打印出来了%@",[user objectForKey:@"token"]);
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        
        self.changePwBlock(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];
}



// 忘记密码
+ (void)forgetPwdPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}


// 更改密码
- (void)changePwdPUT:(NSString *)url parameters:(NSDictionary *)parameters  {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
  
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];

    
    NSLog(@"token打印出来了%@",[user objectForKey:@"token"]);
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];

    
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.changePwBlock(responseObject);
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    

        NSDictionary * dic = @{@"status":@"false"};
        self.changePwBlock(dic);
    }];
}





//车辆信息
+ (void)rentalPackGet:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}

//提交订单
+ (void)addOrderPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}

//查询订单
+ (void)checkOrderGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];
}


#pragma mark 赶脚

+(void)getAllCitysGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    

    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure) {
            failure(error);
        }
    }];

}

-(void)cancelOrderPUT:(NSString *)url parameters:(NSDictionary *)parameters
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[user objectForKey:@"token"] forHTTPHeaderField:@"cookie"];
    
    
    NSLog(@"token打印出来了%@",[user objectForKey:@"token"]);
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/plain",@"application/json",nil];
    
    
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        self.cancelOrderBlcok(responseObject);

        
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}




@end
