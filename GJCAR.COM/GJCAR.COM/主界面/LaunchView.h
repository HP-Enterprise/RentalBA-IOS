//
//  LaunchViewController.h
//  GJCAR.COM
//
//  Created by inCar on 2017/9/22.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLLaunchDelegate;

@interface LaunchView : UIView

@property (nonatomic ,strong) id<MLLaunchDelegate> delegate;

- (instancetype)initWith:(NSDictionary*)dic;
@end

@protocol MLLaunchDelegate <NSObject>

@optional

// 用户点击启动屏幕调用的方法
- (void)touchView;

// 用户没有点击屏幕调用的方法
- (void)ending;

@end
