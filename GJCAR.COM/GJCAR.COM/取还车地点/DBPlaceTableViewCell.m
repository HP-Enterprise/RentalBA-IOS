//
//  DBPlaceTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/29.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBPlaceTableViewCell.h"

@implementation DBPlaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createView];
    }
    return self;
}



-(void)createView
{
    //地址名
    _title  = [[UILabel alloc]initWithFrame:CGRectMake(20,  5 , ScreenWidth  - 20, 20)];
    
    _title.font = [UIFont systemFontOfSize:12];

    [self addSubview:_title];
    
    
    //地址名
    _subTitle  = [[UILabel alloc]initWithFrame:CGRectMake(20,  CGRectGetMaxY(_title.frame) , ScreenWidth  - 20, 15)];

    _subTitle.font = [UIFont systemFontOfSize:10];
    [self addSubview:_subTitle];
    
    
    
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
