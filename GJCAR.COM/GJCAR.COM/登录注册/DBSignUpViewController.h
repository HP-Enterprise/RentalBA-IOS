//
//  DBSignUpViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^signInBlock)(NSString * name,NSString * pw);

@interface DBSignUpViewController : UIViewController

{
    DBTextField *userNameField;
    DBTextField *ValidateField;
//    DBTextField *passWordField;
    DBTextField *newPwField;
    NSTimer *timer;
    int time;
}

@property (nonatomic,strong)signInBlock signInblock ;

@end
