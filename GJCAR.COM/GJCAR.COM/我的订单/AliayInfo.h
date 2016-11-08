//
//  AliayInfo.h
//  GJCAR.COM
//
//  Created by 段博 on 16/8/16.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}





@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;


@end



typedef void (^payBlock)(NSDictionary*dic);

@interface AliayInfo : NSObject


//下单成功生成订单
@property(nonatomic,strong)Product *product ;
@property(nonatomic,strong)payBlock payblock ;

- (void)generateData:(NSDictionary*)dic with:(NSString *)price;

@end
