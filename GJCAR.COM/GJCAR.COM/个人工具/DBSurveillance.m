//
//  DBSurveillance.m
//  GJCAR.COM
//
//  Created by 段博 on 2017/1/13.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "DBSurveillance.h"
#import <AdSupport/AdSupport.h>

#import "DBNetwork.h"
@implementation DBSurveillance

//1151833888 appid
/*
{
    "mediaId": "新闻",
    "deviceId": "1151833888",    （这个是appkey）
    "ifa": "511F7987-6E2F-423A-BFED-E4C52CB5A6DC",
    "ifamd5": "",
    "signKey": "a8e20b0be06e4bbc1bc1d5fd2589fcf1",
    "userId": "4124bc0a9335c27f086f24ba207a4912",
    "appVersion" : "2.0.1",
    "channel" : "00"
}
 */
#pragma mark 首次激活申报
-(void)activateReport{

    [DBNetwork activateStatisticalPOST:nil parameters:[self getActiveInfoDic] success:^(id responseObject) {

    } failure:^(NSError *error) {

    }];

}


-(void)registerReport{
    
    [DBNetwork sigUpStatisticalPOST:nil parameters:[self getRegisterInfoDic] success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSString*)getIDFA{
//    if ( [self loadIDFa] ) {
//
//
//         DBLog(@"%@",[self loadIDFa]);
//        return [self loadIDFa] ;
//       
//    }

//    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   
    
    DBLog(@"%@",idfa);
    
//    [self saveIDFAdata:idfa];
    
    return idfa ;
 
}
- (NSDictionary*)getActiveInfoDic{

    NSUserDefaults * user= [NSUserDefaults standardUserDefaults];

    NSString* version =[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];
    
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];

    infoDic[@"mediaId"] = @"00" ;
    infoDic[@"deviceId"] = @"1151833888" ;
    infoDic[@"ifa"] = [self getIDFA] ;
    infoDic[@"ifamd5"] = @"" ;
    infoDic[@"signKey"] = @"a8e20b0be06e4bbc1bc1d5fd2589fcf1" ;
    infoDic[@"userId"] = [user objectForKey:@"userId"] ;
    infoDic[@"appVersion"] = version ;
    infoDic[@"channel"] = @"00" ;
    return infoDic;
}

- (NSDictionary*)getRegisterInfoDic{
    
    NSUserDefaults * user= [NSUserDefaults standardUserDefaults];
    
    NSString* version =[[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];
    
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionary];
    
    infoDic[@"mediaId"] = @"00" ;
    infoDic[@"deviceId"] = @"1151833888" ;
    infoDic[@"ifa"] = [self getIDFA] ;
    infoDic[@"ifamd5"] = @"" ;
    infoDic[@"signKey"] = @"a8e20b0be06e4bbc1bc1d5fd2589fcf1" ;
    infoDic[@"userId"] = [user objectForKey:@"userId"] ;
    infoDic[@"appVersion"] = version ;
    infoDic[@"channel"] = @"00" ;
    return infoDic;
}

////获取设备当前网络IP地址
//- (NSString *)getIPAddress:(BOOL)preferIPv4
//{
//    NSArray *searchArray = preferIPv4 ?
//    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
//    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//    
//    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
//    
//    __block NSString *address;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     {
//         address = addresses[key];
//         if(address) *stop = YES;
//     } ];
//    return address ? address : @"0.0.0.0";
//}

////获取所有相关IP信息
//- (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//    
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                NSString *type;
//                if(addr->sin_family == AF_INET) {
//                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv4;
//                    }
//                } else {
//                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                        type = IP_ADDR_IPv6;
//                    }
//                }
//                if(type) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    return [addresses count] ? addresses : nil;
//}

//- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
//    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
//            (id)kSecClassGenericPassword,(id)kSecClass,
//            service, (id)kSecAttrService,
//            service, (id)kSecAttrAccount,
//            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
//            nil];
//}
//
//- (void)saveIDFAdata:(id)data {
//    
//    NSString * KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
//    NSString * KEY_USERNAME = @"com.company.app.username";
//    //    NSString * KEY_PASSWORD = @"com.company.app.password";
//    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
//    
//    [usernamepasswordKVPairs setObject:data  forKey:KEY_USERNAME];
//    
//    
//    //Get search dictionary
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_USERNAME_PASSWORD];
//    //Delete old item before add new item
//    SecItemDelete((CFDictionaryRef)keychainQuery);
//    //Add new object to search dictionary(Attention:the data format)
//    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:usernamepasswordKVPairs] forKey:(id)kSecValueData];
//    //Add item to keychain with the search dictionary
//    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
//    
//}
//
//- (id)loadIDFa {
//    
//    NSString * KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
//    DBLog(@"%@",[[[DBSurveillance alloc]init]getIPAddress:YES]);
//    id ret = nil;
//    
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_USERNAME_PASSWORD];
//    //Configure the search setting
//    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
//    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
//    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
//  
//    CFDataRef keyData = NULL;
//    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
//        @try {
//            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
//        } @catch (NSException *e) {
//            NSLog(@"Unarchive of failed: %@", e);
//        } @finally {
//        }
//    }
//    if (keyData)
//        CFRelease(keyData);
//    return ret;
//}
//
//- (void)delete:(NSString *)service {
//    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
//    SecItemDelete((CFDictionaryRef)keychainQuery);
//}

@end
