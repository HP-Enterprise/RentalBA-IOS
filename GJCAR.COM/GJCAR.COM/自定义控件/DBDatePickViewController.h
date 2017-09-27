//
//  DBDatePickViewController.h
//  ShenHuaCar
//
//  Created by 段博 on 16/4/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void (^BtBlock)(NSString * str,NSInteger index);

@interface DBDatePickViewController : UIViewController



@property (nonatomic ,strong)UIPickerView * pickerView ;
@property (nonatomic ,strong)UIButton * cancelBt;
@property (nonatomic ,strong)UIButton * selectBt ;


//省份数组
@property (nonatomic ,strong)NSArray * dataArray;

//城市数组
@property (nonatomic ,strong)NSArray * cityArray;


@property (nonatomic ,strong)BtBlock  btBlock;


- (void)initWithProData:(NSArray*)proArray withCityData:(NSArray*)cityArray;

@end
