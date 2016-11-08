//
//  DBCityTableViewCell.m
//  ShenHuaCar
//
//  Created by 段博 on 16/4/18.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCityTableViewCell.h"

@implementation DBCityTableViewCell

- (void)awakeFromNib {
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

//创建自定义cell
-(void)createView
{
    
    self.city = [[UILabel alloc]initWithFrame: CGRectMake(20,  5, self.frame.size.width , 20 )];
    self.city.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.city];
    
    self.addr = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.city.frame), self.frame.size.width -20, 15)];
    self.addr.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    self.addr.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.addr];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
