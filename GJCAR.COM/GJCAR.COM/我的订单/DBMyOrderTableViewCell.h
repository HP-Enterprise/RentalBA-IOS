//
//  DBMyOrderTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/23.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBOrderModel.h"

@interface DBMyOrderTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger orderIndex ;

@property(nonatomic,strong)UIImageView * imageV ;
//车辆名称
@property (nonatomic,strong) UILabel * carName ;
//车辆名称
@property (nonatomic,strong) UILabel * carkind ;

//取车时间
@property (nonatomic,strong) UIButton * takeTime ;
//取车星期
@property (nonatomic,strong) UILabel * week;
//还车时间
@property (nonatomic,strong) UIButton * returnTime ;
//还车星期
@property (nonatomic,strong) UILabel * returnWeek;

//租车天数
@property (nonatomic,strong) UILabel * number;

//取车地点
@property (nonatomic,strong) UILabel  * takePlace ;

//还车地点
@property (nonatomic,strong) UILabel  * retuenPlace ;

//订单编号
@property (nonatomic,strong) UILabel  * orderNumber ;

//订单状态
@property (nonatomic,strong) UILabel  * orderStatus ;

-(void)cellConfigWithModel:(DBOrderModel*)model ;

@end
