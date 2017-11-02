//
//  DBColorCircleView.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/10/25.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBColorCircleView : UIView
//数组里面装的是字典，，字典里有两个key -> strokeColor和precent
@property (nonatomic,assign) NSArray *circleArray;


- (void)initType;

@end
