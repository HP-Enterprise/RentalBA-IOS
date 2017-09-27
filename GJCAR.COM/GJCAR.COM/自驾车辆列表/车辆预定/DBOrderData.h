//
//  DBOrderData.h
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBCarModel.h" 



@interface DBOrderData : NSObject

+(NSMutableDictionary*)createOrderInfoWithPriceDic:(NSDictionary*)priceDic CarDic:(DBCarModel *)carModel Price:(NSString*)price PayWay:(NSString*)payWay WithAddValueArr:(NSArray*)array;
@end
