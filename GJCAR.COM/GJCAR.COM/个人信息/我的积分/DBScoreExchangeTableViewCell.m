//
//  DBScoreExchangeTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/22.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBScoreExchangeTableViewCell.h"
#import "DBcommonUtils.h"
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
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange( 0 , totalPrice.length)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( totalPrice.length , 2)];
    
    _scoreLabel.attributedText = totleCostStr;
    
    
//    //使用渠道
//    _useLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , CGRectGetMaxY(_scoreLabel.frame)+5, _scoreLabel.frame.size.width, 10)];
//    _useLabel.textAlignment = 1 ;
//    
//    _useLabel.font =[ UIFont systemFontOfSize:10];
//    _useLabel.textColor = [UIColor whiteColor];
//    [voucher addSubview:_useLabel];
    
    
    _leftoverNumber = [[UILabel alloc]initWithFrame:CGRectMake(_scoreLabel.frame.origin.x, CGRectGetMaxY(self.scoreLabel.frame)+5, voucher.frame.size.width * 2 /5 , 20)];
//    _leftoverNumber.text = [NSString stringWithFormat:@"剩余9张"];
    _leftoverNumber.textAlignment = 1 ;
    _leftoverNumber.textColor = [UIColor whiteColor];
    _leftoverNumber.font = [UIFont systemFontOfSize:10];
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

    
    

    _progressView = [[DBColorCircleView alloc]init];
    _progressView.frame = CGRectMake(voucher.frame.size.width * 2 /5  / 2 - 20,5, 40 , 40);
    [voucher addSubview:_progressView];
//
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_2);
    [_progressView setTransform:transform];
    
    _scoreLabel.frame = CGRectMake(0,CGRectGetMaxY(_progressView.frame)+2, voucher.frame.size.width * 2 /5 , 20);
    
    UILabel * bye = [[UILabel alloc]initWithFrame:CGRectMake(voucher.frame.size.width * 2 /5  / 2 - 15, 10 , 30 , 15)];
    [voucher addSubview:bye];
    bye.text = @"已抢";
    bye.textColor =[UIColor whiteColor];
    bye.textAlignment= 1;
    bye.font = [UIFont systemFontOfSize:10];
    _leftoverNumber.frame = CGRectMake(voucher.frame.size.width * 2 /5  / 2 - 15, 23 , 30 , 15);
}


-(void)config:(NSDictionary*)dic
{
    _titleLael.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    
    
    totalPrice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"accumulate"]];
    
    
    float a,b,c;
    NSInteger remainNum = [dic[@"remainNum"]integerValue];
    NSInteger designNum = [dic[@"designNum"]integerValue];
   
    NSNumber * percent;
    if ([dic[@"percent"]isKindOfClass:[NSNull class]]) {
        percent = @0;
    }
    else{
        percent = dic[@"percent"];
        if ([percent integerValue]>=1) {
            percent = @1;
        }
        else if ([[NSString stringWithFormat:@"%@",percent] isEqualToString:@"0"]) {
            percent = @0;
        }
    }
    if ([percent integerValue]>=1) {
        percent = @1;
        _leftoverNumber.text = [NSString stringWithFormat:@"100%%"];
    }
    else if ([[NSString stringWithFormat:@"%@",percent] isEqualToString:@"0"]) {
        percent = @0;
        _leftoverNumber.text = [NSString stringWithFormat:@"0%%"];
    }
    else{
        _leftoverNumber.text = [NSString stringWithFormat:@"%.1f%%",[percent floatValue]*100];
        
    }

    a = [dic[@"designNum"]doubleValue] - [dic[@"remainNum"]doubleValue];
    b = remainNum;
    c = 0;
    
    _progressView.circleArray =@[
                                 @{
                                     @"strokeColor":[DBcommonUtils getColor:@"FF3333"],
                                     @"precent"    :@([percent floatValue])
                                     },
                                 @{
                                     @"strokeColor":[UIColor whiteColor],
                                     @"precent"    :@(1-[percent floatValue])
                                     },
                                 @{
                                     @"strokeColor":[UIColor yellowColor],
                                     @"precent"    :@(c/(a+b+c))
                                     }
                                 ];
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 积分",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,totalPrice.length + 3)];

    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( totalPrice.length, 3)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange( 0 , totalPrice.length)];
    
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
