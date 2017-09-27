//
//  DBForgetPwViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBForgetPwViewController : UIViewController
{
    DBTextField *userNameField;
    DBTextField *ValidateField;
    DBTextField *passWordField;
    NSInteger time;
    NSTimer *timer;
}
@end
