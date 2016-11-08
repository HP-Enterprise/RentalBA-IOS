//
//  DBOderInfoViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/28.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBOrderModel.h"



@interface DBOderInfoViewController : UIViewController

@property (nonatomic,strong)DBOrderModel *  model ;

@property (nonatomic,assign)NSInteger  orderIndex ;
@end
