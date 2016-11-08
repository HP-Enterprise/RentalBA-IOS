//
//  DBChangePhoneViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/8/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBChangePhoneViewController : UIViewController
{
    DBTextField *userNameField;
    DBTextField *ValidateField;
    DBTextField *passWordField;
    NSInteger time;
    NSTimer *timer;
}
@end
