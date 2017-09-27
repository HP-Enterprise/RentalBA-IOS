//
//  DBChooseDateViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/4/30.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^dateBlock)(NSString * str,NSString * hour,NSInteger index);


@interface DBChooseDateViewController : UIViewController


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


@property (nonatomic ,strong)dateBlock  DateBlock;


- (void)initWithProData:(NSArray*)proArray withCityData:(NSArray*)cityArray;


@end
