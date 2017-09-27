
//
//  DBvoucherTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBvoucherTableViewCell.h"

@implementation DBvoucherTableViewCell

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
    
    
    UIImageView * voucher =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 125, 20, 250, 70)];
    
    voucher.image = [UIImage imageNamed:@"voucherImage"];
    [self addSubview:voucher];
    
    
    
    
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, voucher.frame.size.width * 2 /5,20)];
    _scoreLabel.textAlignment = 1 ;
    [voucher addSubview:_scoreLabel];
    
    
    
    totalPrice = [NSString stringWithFormat:@""];
    
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,totalPrice.length + 2)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange( 0 , 1)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange( 1 , totalPrice.length+ 1)];
    
    _scoreLabel.attributedText = totleCostStr;
    
    
    //使用渠道
    _useLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_scoreLabel.frame)+5, _scoreLabel.frame.size.width, 10)];
    _useLabel.textAlignment = 1 ;
    
    _useLabel.font =[ UIFont systemFontOfSize:10];
    _useLabel.textColor = [UIColor whiteColor];

    [voucher addSubview:_useLabel];
    
    
    
    //剩余数量
    _consumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_useLabel.frame), _scoreLabel.frame.size.width, 20)];
    _consumeLabel.textAlignment = 1 ;

    _consumeLabel.font =[ UIFont systemFontOfSize:10];
    _consumeLabel.textColor = [UIColor whiteColor];
//    _consumeLabel.textColor= [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] ;
    [voucher addSubview:_consumeLabel];
    
    
    //优惠名称
    _titleLael = [[UILabel alloc]initWithFrame:CGRectMake(voucher.frame.size.width * 2 / 5 + 20, 10, voucher.frame.size.width * 3 / 5 - 20, 30)];
    
 
    _titleLael.numberOfLines = 0 ;
    _titleLael.font = [UIFont systemFontOfSize:12];

    [voucher addSubview:_titleLael];
    
    //优惠时间
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(voucher.frame.size.width * 2 / 5 + 20, CGRectGetMaxY(_titleLael.frame)+ 5, voucher.frame.size.width * 3 / 5 - 20, 10)];
    
   
    _timelabel.font = [UIFont systemFontOfSize:10];
    _timelabel.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] ; 
    [voucher addSubview:_timelabel];

    
    

//    _titleLael = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenWidth/ 2, 20)];
//    _titleLael.text = @"Acer光环半价优惠";
//    _titleLael.font = [UIFont systemFontOfSize:12];
//    [self addSubview:_titleLael];
//    
//    
//    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLael.frame)+ 5, ScreenWidth/2, 10)];
//    
//    _timelabel.text =@"2016-07-01" ;
//    _timelabel.font = [UIFont systemFontOfSize:10];
//    [self addSubview:_timelabel];
//    
//    
//    
//    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 25, ScreenWidth/2 - 30 , 20)];
//    
//    _scoreLabel.text = @"¥ 100" ;
//    _scoreLabel.textAlignment = 2 ;
//    _scoreLabel.font = [UIFont systemFontOfSize:12];
//    _scoreLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
//    [self addSubview:_scoreLabel];
//    
//    
    
    
}

-(void)config:(NSDictionary*)dic
{
    _titleLael.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    
    
    totalPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"amount"]];
    
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,totalPrice.length + 2)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange( 0 , 1)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange( 1 , totalPrice.length+ 1)];
    
    _scoreLabel.attributedText = totleCostStr;
    
    
    _consumeLabel.text = [NSString stringWithFormat:@"最低消费金额:%@",[dic objectForKey:@"consume"]];
    
    
    NSInteger applySource ;
    if (![[dic objectForKey:@"applySource"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"applySource"]isEqualToString:@""]) {
        
        applySource = [[dic objectForKey:@"applySource"]integerValue];

    }
    
    if (applySource == 1) {
        _useLabel.text = @"WEB 可使用";
    }
    else if (applySource == 2){
        _useLabel.text = @"APP 可使用";

    }
    
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
