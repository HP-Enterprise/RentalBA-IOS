//
//  DBFreeRideDateViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/29.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBFreeRideModel.h"


typedef void (^freeRidedateBlock)(NSString * str,NSString * hour);

@interface DBFreeRideDateViewController : UIViewController



@property (nonatomic ,strong)UIPickerView * pickerView ;

//取消按钮
@property (nonatomic ,strong)UIButton * cancelBt;

//确定按钮
@property (nonatomic ,strong)UIButton * selectBt ;

//取还车label
@property (nonatomic, strong)UILabel *label ;

//年份数组
@property (nonatomic ,strong)NSMutableArray * yearArray;


//时间时间数组
@property (nonatomic,strong)NSArray * hourArray;

//判断取车时间还是还车时间的参数
@property (nonatomic)NSInteger index;


@property (nonatomic ,strong)freeRidedateBlock  freeRidedateBlock;


- (void)initWithProData:(DBFreeRideModel*)model withCityData:(DBFreeRideModel*)model1;


@end
