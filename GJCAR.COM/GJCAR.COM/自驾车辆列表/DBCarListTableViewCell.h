//
//  DBCarListTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DBCarListTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>



//日历控件
@property (nonatomic,strong)UICollectionView * collcetionView;
//日历控件天数
@property (nonatomic,strong)NSMutableArray * daysArray;

@property (nonatomic,strong)NSArray * priceArray ;


//当前月份
@property (nonatomic,copy)NSString * nowMonth;



//当前月份
@property (nonatomic,copy)NSString * nowDate;
//判断第一次进来

@property (nonatomic) BOOL isFirst;

//选择的租车日期
@property (nonatomic,strong)NSMutableArray * rentalArray;

-(void)config:(NSArray*)array withPriceDaysArray:(NSArray*)daysArray;

@end
