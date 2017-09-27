//
//  DBScoreExchangeTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/22.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBScoreExchangeTableViewCell.h"

@implementation DBScoreExchangeTableViewCell

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
    
    
    UIImageView * voucher =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 125, 20, 250, 65)];
    
    voucher.image = [UIImage imageNamed:@"voucherImage"];
    [self addSubview:voucher];
    
    
    
    
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10, voucher.frame.size.width * 2 /5 , 20)];
    _scoreLabel.textAlignment = 1 ;
    [voucher addSubview:_scoreLabel];
    
    
    
    totalPrice = [NSString stringWithFormat:@"100"];
    
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@积分",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,totalPrice.length + 2)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange( 0 , totalPrice.length)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( totalPrice.length , 2)];
    
    _scoreLabel.attributedText = totleCostStr;
    
    
//    //使用渠道
//    _useLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_scoreLabel.frame)+5, _scoreLabel.frame.size.width, 10)];
//    _useLabel.textAlignment = 1 ;
//    
//    _useLabel.font =[ UIFont systemFontOfSize:10];
//    _useLabel.textColor = [UIColor whiteColor];
//    
//    [voucher addSubview:_useLabel];
    
    
    _leftoverNumber = [[UILabel alloc]initWithFrame:CGRectMake(_scoreLabel.frame.origin.x, CGRectGetMaxY(self.scoreLabel.frame)+5, voucher.frame.size.width * 2 /5 , 20)];
//    _leftoverNumber.text = [NSString stringWithFormat:@"剩余9张"];
    _leftoverNumber.textAlignment = 1 ;
    _leftoverNumber.textColor = [UIColor whiteColor];
    _leftoverNumber.font = [UIFont systemFontOfSize:12];
    [voucher addSubview:_leftoverNumber];
    
    
    
    
    //优惠名称
    _titleLael = [[UILabel alloc]initWithFrame:CGRectMake(voucher.frame.size.width * 2 / 5 + 20, 10, voucher.frame.size.width * 3 / 5 - 20, 30)];
    
//    _titleLael.text = @"Acer光环半折优惠";
    _titleLael.numberOfLines = 0 ;
    _titleLael.font = [UIFont systemFontOfSize:12];
    [voucher addSubview:_titleLael];
    

    
    
    
    //优惠时间
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(voucher.frame.size.width * 2 / 5 + 20, CGRectGetMaxY(_titleLael.frame)+ 5, voucher.frame.size.width * 3 / 5 - 20, 10)];
    
//    _timelabel.text = @"2016.07.01 -- 2016.09.01";
    _timelabel.font = [UIFont systemFontOfSize:10];
    [voucher addSubview:_timelabel];
    
    
    
    

    
}

-(void)config:(NSDictionary*)dic
{
    _titleLael.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    
    
    totalPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"accumulate"]];
    
    _leftoverNumber.text = [NSString stringWithFormat:@"剩余%@张",[dic objectForKey:@"remainNum"]];

    
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 积分",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,totalPrice.length + 3)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( totalPrice.length, 3)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange( 0 , totalPrice.length)];
    
    _scoreLabel.attributedText = totleCostStr;
    
    
//    NSInteger applySource ;
//    if (![[dic objectForKey:@"applySource"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"applySource"]isEqualToString:@""]) {
//        
//        applySource = [[dic objectForKey:@"applySource"]integerValue];
//        
//    }
//    
//    if (applySource == 1) {
//        _useLabel.text = @"WEB 可使用";
//    }
//    else if (applySource == 2){
//        _useLabel.text = @"APP 可使用";
//        
//    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    if (![[dic objectForKey:@"validityBegin"]isKindOfClass:[NSNull class]]  &&  ![[dic objectForKey:@"validityEnd"]isKindOfClass:[NSNull class]])
    {
        NSDate * takeDate =[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"validityBegin"] doubleValue]/1000];
        
        NSDate * returnDate =[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"validityEnd"] doubleValue]/1000];
        
        NSString * takeTimeStr =[formatter stringFromDate:takeDate];
        NSString * returnTimeStr =[formatter stringFromDate:returnDate];
        
        
        _timelabel.text = [NSString stringWithFormat:@"%@--%@",takeTimeStr,returnTimeStr];
    }
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
