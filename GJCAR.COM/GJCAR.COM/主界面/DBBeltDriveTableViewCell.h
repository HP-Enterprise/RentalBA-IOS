//
//  DBBeltDriveTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/8/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBBeltDriveTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * carImageView;

@property (nonatomic,strong)UILabel * carName ;

@property (nonatomic,strong)UILabel * carInfo ;

@property (nonatomic,strong)UILabel * price ;

@property (nonatomic,strong)UILabel * describe ;

@property (nonatomic,strong)UIButton * reserve ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
