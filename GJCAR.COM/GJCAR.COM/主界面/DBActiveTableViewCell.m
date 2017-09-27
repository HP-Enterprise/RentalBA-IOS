//
//  DBActiveTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBActiveTableViewCell.h"

@implementation DBActiveTableViewCell

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
    
    //cell 顶部
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 0 , ScreenWidth, 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:toplineView];
    
    
    UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 10)];
    
    backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [self addSubview:backView ];
    
    
    
    
    //时间地点分割线
    UIView * toplineView1 = [[UIView alloc]initWithFrame:CGRectMake( 0 , 9.5 , ScreenWidth, 0.5)];
    toplineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:toplineView1];
    
    
    
    
    
    //活动名
    _title = [[UILabel alloc]initWithFrame:CGRectMake(25 , 20 , ScreenWidth - 25 , 15)];
    
    _title.text = @"这个是标题";

    
    _title.font = [UIFont systemFontOfSize:12];
    [self addSubview:_title];
    
    //活动时间
    _time = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_title.frame)+5, _title.frame.size.width, 11 )];
    
    _time.text = @"2016-06-24 16:03:26" ;
    
    
    _time.font = [UIFont systemFontOfSize:10];
    _time.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [self addSubview:_time];

    
    
    //活动图片
    _imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(_time.frame)+5,ScreenWidth - 50,150)];
    _imageV.image = [UIImage imageNamed:@"截图"];
    [self addSubview:_imageV];
    
    
    //活动介绍
    _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_imageV.frame), ScreenWidth - 50, 60 )];
    _descriptionLabel.numberOfLines = 5 ;
    _descriptionLabel.font = [UIFont systemFontOfSize:11];
//    _descriptionLabel.adjustsFontSizeToFitWidth = YES ;
    _descriptionLabel.text = @"活动概要";
    _descriptionLabel.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [self addSubview:_descriptionLabel];

    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 25 , CGRectGetMaxY(_descriptionLabel.frame) + 5 , ScreenWidth - 50, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView];
    
    
    
    
    
    //查看详情
    UILabel * more = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, CGRectGetMaxY(lineView.frame), ScreenWidth - 50, 30 )];
    more.text = @"查看详情";
    
    more.font = [UIFont systemFontOfSize:12];
    more.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [self addSubview:more];
    
    

}


-(void)conFigWithModel:(NSDictionary*)dic
{
    
    _title.text = [dic objectForKey:@"title"];
    _time.text = [dic objectForKey:@"createDate"];
    NSString * newdescripion = [[dic objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//   CGSize size = [DBcommonUtils calculateStringLenth:newdescripion withWidth:(ScreenWidth - 50) withFontSize:11];
    
    
    _descriptionLabel.text = newdescripion;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:
                                 [NSString stringWithFormat:@"%@%@",Host,[dic objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
