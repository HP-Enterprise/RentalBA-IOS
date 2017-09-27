//
//  DBResetViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/3.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBResetViewController : UIViewController
{
   
    DBTextField *newPwField;
    DBTextField *ValidateField;
    DBTextField *newPwAgField;
    
}
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy)NSString *code;
@end
