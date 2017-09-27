//
//  DBSignInViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/6.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCarModel.h"
#import "DBFreeRideModel.h"

@interface DBSignInViewController : UIViewController


{
    DBTextField *userNameField;
    DBTextField *passWordField;
}


//记录传递数据的页面



@property (nonatomic)NSInteger indexControl;

@property (nonatomic,strong)DBCarModel * model ;
@property (nonatomic,strong)NSDictionary * activityDic;

@property (nonatomic,strong)DBFreeRideModel * FreeRideModel ;

@end
