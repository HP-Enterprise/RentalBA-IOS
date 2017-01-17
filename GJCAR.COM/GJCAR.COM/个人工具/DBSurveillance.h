//
//  DBSurveillance.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/1/13.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>


//#import <AdSupport/AdSupport.h>
//首先导入头文件信息
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface DBSurveillance : NSObject

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@property (nonatomic,copy)NSString * appkey ;
@property (nonatomic,copy)NSString * acttype ;
@property (nonatomic,copy)NSString * ifa ;
@property (nonatomic,copy)NSString * ifamd5 ;
//用户行为时间
@property (nonatomic,copy)NSString * acttime ;

@property (nonatomic,copy)NSString * sign ;
@property (nonatomic,copy)NSString * userid ;



//+(NSString*)getIDFA ;
- (NSString *)getIPAddress:(BOOL)preferIPv4;



@end
