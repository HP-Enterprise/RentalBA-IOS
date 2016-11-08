//
//  DBNetTool.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChangePwBlock)(NSDictionary *dic);

//验证验证码回调
typedef void (^verifyCodeBlock)(NSDictionary *dic);

//取消订单
typedef void (^cancelOrderBlock)(NSDictionary *dic);

@interface DBNetworkTool : NSObject



@property (nonatomic,strong)ChangePwBlock changePwBlock;

@property (nonatomic,strong)verifyCodeBlock verifyCodeBlock;

@property (nonatomic,strong)cancelOrderBlock  cancelOrderBlcok;

//md5加密
+(NSString *)getDictKeysValues:(NSDictionary *)dic;
+(NSString*)md5Digest:(NSString *)str;

// get 方法调用
+ (void)Get:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

// post 方法调用
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;
//DELETE 方法调用
+ (void)DELETE:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


//登录
+ (void)signInPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//获取验证码
+ (void)codeValidatePOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure ;

//验证验证码
-(void)verifyCodePUT:(NSString *)url parameters:(NSDictionary *)parameters;


//提交注册
+ (void)verifyPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

// 用户查询个人信息
+ (void)getUserInfoGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//修改个人信息
- (void)changeUserInfoPUT:(NSString *)url parameters:(NSDictionary *)parameters;


//更改密码
- (void)changePwdPUT:(NSString *)url parameters:(NSDictionary *)parameters ;

//车辆信息
+ (void)rentalPackGet:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//添加订单
+ (void)addOrderPost:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//查询订单
+ (void)checkOrderGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;



#pragma mark 赶脚
+(void)getAllCitysGET:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


//取消订单
-(void)cancelOrderPUT:(NSString *)url parameters:(NSDictionary *)parameters;

@end
