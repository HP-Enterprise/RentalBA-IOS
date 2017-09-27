//
//  DBBeltDriveTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBBeltDriveTableViewCell.h"

@implementation DBBeltDriveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self creatUI];
    }
    return self;
}


-(void)creatUI
{
    
    
    //预定按钮
    _reserve = [UIButton buttonWithType:UIButtonTypeCustom];
    _reserve.frame = CGRectMake(ScreenWidth - 70 , self.contentView.frame.size.height/2 -10, 50, 20);
    [_reserve setTitle:@"预定" forState:UIControlStateNormal];
    [_reserve setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _reserve.layer.cornerRadius = 2 ;
    _reserve.backgroundColor =  [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    _reserve.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_reserve];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
