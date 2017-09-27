//
//  DBNetwork.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/1/21.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBNetwork : NSObject

+ (void)activateStatisticalPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

+ (void)sigUpStatisticalPOST:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


@end
