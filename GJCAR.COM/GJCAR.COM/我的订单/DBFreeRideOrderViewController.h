//
//  DBOderInfoViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOrderModel.h"


//@interface Product : NSObject{
//@private
//    float     _price;
//    NSString *_subject;
//    NSString *_body;
//    NSString *_orderId;
//}
//
//
//@property (nonatomic, assign) float price;
//@property (nonatomic, copy) NSString *subject;
//@property (nonatomic, copy) NSString *body;
//@property (nonatomic, copy) NSString *orderId;
//
//
//@end


@interface DBFreeRideOrderViewController : UIViewController

@property (nonatomic,strong)DBOrderModel *  model ;

@property (nonatomic,assign)NSInteger  orderIndex ;
@end
