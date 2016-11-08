//
//  DBChangePwViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/31.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^signInBlock)(NSString * name,NSString * pw);


@interface DBChangePwViewController : UIViewController

{
    
    DBTextField *oldPwField;
    DBTextField *newPwField;
    DBTextField *newPwAgField;
    
}

@property (nonatomic,strong)signInBlock signInblock ;
@end
