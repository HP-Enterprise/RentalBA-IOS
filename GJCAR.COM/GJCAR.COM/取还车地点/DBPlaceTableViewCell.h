//
//  DBPlaceTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/29.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBPlaceTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * title ;
@property (nonatomic,strong)UILabel * subTitle ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;

@end
