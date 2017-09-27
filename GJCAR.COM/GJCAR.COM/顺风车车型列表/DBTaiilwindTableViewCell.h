//
//  DBTaiilwindTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/24.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "DBFreeRideModel.h"


@interface DBTaiilwindTableViewCell : UITableViewCell

//取车时间选择
@property (nonatomic,strong)UIButton    * takeTime;

//还车时间选择
@property (nonatomic,strong)UIButton    * returnTime;

@property (nonatomic,strong)UIImageView * imageV;
@property (nonatomic,strong)UILabel     * carName;
@property (nonatomic,strong)UILabel     * carkind;

@property (nonatomic,strong)UILabel     * week;
@property (nonatomic,strong)UILabel     * returnWeek;
@property (nonatomic,strong)UILabel     * pricelabel;
@property (nonatomic,strong)UILabel     * number;






-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)conFigWithModel:(DBFreeRideModel*)model;
@end
