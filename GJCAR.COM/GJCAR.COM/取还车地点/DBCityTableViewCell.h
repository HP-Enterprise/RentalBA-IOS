//
//  DBCityTableViewCell.h
//  ShenHuaCar
//
//  Created by 段博 on 16/4/18.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBCityTableViewCell : UITableViewCell




//商圈名
@property (nonatomic,strong)UILabel * city;

//商圈地址
@property (nonatomic,strong)UILabel * addr ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
