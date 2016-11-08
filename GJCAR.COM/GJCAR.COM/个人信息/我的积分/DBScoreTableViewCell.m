//
//  DBScoreTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/5.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBScoreTableViewCell.h"

@implementation DBScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self ;
}




-(void)createUI
{
    _titleLael = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenWidth/ 2, 20)];
    _titleLael.text = @"Acer光环半价优惠";
    _titleLael.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLael];
    
    
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLael.frame)+ 5, ScreenWidth/2, 10)];
    
    _timelabel.text =@"2016-07-01" ;
    _timelabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timelabel];
    
    
    
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 25, ScreenWidth/2 - 30 , 20)];
    
    _scoreLabel.text = @"¥ 100" ;
    _scoreLabel.textAlignment = 2 ;
    _scoreLabel.font = [UIFont systemFontOfSize:14];
    _scoreLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [self addSubview:_scoreLabel];
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
