//
//  DBKeyChain.m
//  GJCAR.COM
//
//  Created by 段博 on 2017/1/13.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "DBKeyChain.h"
#import "DBSurveillance.h"

@implementation DBKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)saveIDFAdata:(id)data {
    
    NSString * KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
    NSString * KEY_USERNAME = @"com.company.app.username";
//    NSString * KEY_PASSWORD = @"com.company.app.password";
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    
//    [usernamepasswordKVPairs setObject:[DBSurveillance getIDFA]  forKey:KEY_USERNAME];

    
   
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_USERNAME_PASSWORD];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:usernamepasswordKVPairs] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
}

+ (id)loadIDFa {
    
    NSString * KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
    DBLog(@"%@",[[[DBSurveillance alloc]init]getIPAddress:YES]);
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:KEY_USERNAME_PASSWORD];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of failed: %@", e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
