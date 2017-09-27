//
//  DBAlertView.m
//  ShenHuaCar
//
//  Created by 段博 on 16/3/9.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBAlertView.h"

@implementation DBAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTipName:(NSString *)tipName withTipMessage:(NSString *)tipMessageStr withButtonNameArray:(NSArray *)buttonArray {
     
     self = [super init];
     
     if(self != nil) {
         
         CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
         CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
         
         self.frame = [UIScreen mainScreen].bounds;
         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
         
         // 基础View
         CGFloat baseViewW = kWidth - 2 * kWidth * 0.1;
         CGFloat baseViewH = 300;
         CGFloat baseViewX = kWidth * 0.1;
         CGFloat baseViewY = 130 / 568.0 * kHeight;
         UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(baseViewX, baseViewY, baseViewW, baseViewH)];
         baseView.backgroundColor = [UIColor whiteColor];
         [self addSubview:baseView];
         baseView.layer.cornerRadius = 7.5;
         baseView.clipsToBounds = YES;
         
         // 提示标题
         CGFloat tipLabW = baseViewW;
         CGFloat tipLabH = 40 / 568.0 * kHeight;
         CGFloat tipLabX = 0;
         CGFloat tipLabY = 0;
         UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(tipLabX, tipLabY, tipLabW, tipLabH)];
         tipLab.backgroundColor = [UIColor whiteColor];
         tipLab.text = tipName;
         tipLab.textAlignment = NSTextAlignmentCenter;
         tipLab.font = [UIFont systemFontOfSize:17 / 320.0 * kWidth];
         [baseView addSubview:tipLab];
         tipLab.layer.cornerRadius = 7.5;
         //        tipLab.clipsToBounds = YES;
         
         // 分界线
         CGFloat lineViewW = baseViewW;
         CGFloat lineViewH = 1;
         CGFloat lineViewX = 0;
         CGFloat lineViewY = CGRectGetMaxY(tipLab.frame);
         UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH)];
         lineView.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:144 / 255.0 blue:145 / 255.0 alpha:1];
         [baseView addSubview:lineView];
         
         
         // 提示文本
         NSString *fenStr = tipMessageStr;
         NSMutableDictionary *fenDic = [[NSMutableDictionary alloc] init];
         fenDic[NSFontAttributeName] = [UIFont systemFontOfSize:15 / 320.0 * kWidth];
         fenDic[NSForegroundColorAttributeName] = [UIColor blackColor];
         CGRect fenRect = [fenStr boundingRectWithSize:CGSizeMake(baseViewW - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fenDic context:nil];
         CGFloat msgLabW = baseViewW - 40;
         CGFloat msgLabH = fenRect.size.height + 6;
         CGFloat msgLabX = 20;
         CGFloat msgLabY = CGRectGetMaxY(tipLab.frame) + 20;
         UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(msgLabX, msgLabY, msgLabW, msgLabH)];
         msgLab.numberOfLines = 0;
         msgLab.font = [UIFont systemFontOfSize:15 / 320.0 * kWidth];
         msgLab.textColor = [UIColor colorWithRed:143 / 255.0 green:144 / 255.0 blue:145 / 255.0 alpha:1];
         msgLab.textAlignment = NSTextAlignmentCenter;
         
         // 设置行距
         NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:tipMessageStr];
         NSMutableParagraphStyle *paStyle = [[NSMutableParagraphStyle alloc] init];
         paStyle.lineSpacing = 2;
         [attStr addAttribute:NSParagraphStyleAttributeName value:paStyle range:NSMakeRange(0, [tipMessageStr length])];
         msgLab.attributedText = attStr;
         
         //        [msgLab sizeToFit]; // 这个是自适应
         [baseView addSubview:msgLab];
         
         // 下方按钮
         CGFloat okButW = baseViewW;
         CGFloat okButH = tipLabH;
         CGFloat okButX = 0;
         CGFloat okButY= CGRectGetMaxY(msgLab.frame) + 20;
         _okBut = [UIButton buttonWithType:UIButtonTypeCustom];
         _okBut.frame = CGRectMake(okButX, okButY, okButW, okButH);
         [baseView addSubview:_okBut];
         CGFloat okLabW = 60;
         CGFloat okLabH = 30;
         CGFloat okLabX = (baseViewW - okLabW) / 2.0;
         CGFloat okLabY = (okButH - okLabH) / 2.0;
         UILabel *okLab = [[UILabel alloc] initWithFrame:CGRectMake(okLabX, okLabY, okLabW, okLabH)];
         okLab.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:96 / 255.0 blue:1 / 255.0 alpha:1];
         okLab.textColor = [UIColor whiteColor];
         okLab.text = buttonArray[0];
         okLab.textAlignment = NSTextAlignmentCenter;
         okLab.layer.cornerRadius = 7.5;
         okLab.clipsToBounds = YES;
         [_okBut addSubview:okLab];
         //        _okBut.layer.cornerRadius = 7.5;
         //        _okBut.clipsToBounds = YES;
         
         [_okBut addTarget:self action:@selector(okButClick) forControlEvents:UIControlEventTouchUpInside];
         
         CGFloat baseViewH2 = CGRectGetMaxY(_okBut.frame);
         baseView.frame = CGRectMake(baseViewX, baseViewY, baseViewW, baseViewH2);
         
     }
     
     return self;
}


- (instancetype)initWithTipName:(NSString *)tipName withTipMessage:(NSString *)tipMessageStr withButtonNameArray:(NSArray *)buttonArray withRightUpButtonNormalImage:(UIImage *)butNorImg withRightUpButtonHightImage:(UIImage *)butHigImg {
    
    self = [super init];
    
    if(self != nil) {
        
        CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        // 基础View
        CGFloat baseViewW = kWidth - 2 * kWidth * 0.1;
        CGFloat baseViewH = 300;
        CGFloat baseViewX = kWidth * 0.1;
        CGFloat baseViewY = 130 / 568.0 * kHeight;
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(baseViewX, baseViewY, baseViewW, baseViewH)];
        baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:baseView];
        baseView.layer.cornerRadius = 7.5;
        baseView.clipsToBounds = YES;
        
        // 提示栏View
        CGFloat topViewW = baseViewW;
        CGFloat topViewH = 55 / 568.0 * kHeight;
        CGFloat topViewX = 0;
        CGFloat topViewY = 0;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(topViewX, topViewY, topViewW, topViewH)];
        topView.backgroundColor = [UIColor whiteColor];
        [baseView addSubview:topView];
        
        // 提示标题
        CGFloat tipLabW = baseViewW - 20;
        CGFloat tipLabH = 40 / 568.0 * kHeight;
        CGFloat tipLabX = 10;
        CGFloat tipLabY = 15 / 568.0 * kHeight;
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(tipLabX, tipLabY, tipLabW, tipLabH)];
        tipLab.backgroundColor = [UIColor whiteColor];
        tipLab.text = tipName;
        tipLab.textAlignment = NSTextAlignmentLeft;
        tipLab.font = [UIFont systemFontOfSize:17 / 320.0 * kWidth];
        [topView addSubview:tipLab];
        tipLab.layer.cornerRadius = 7.5;
        //        tipLab.clipsToBounds = YES;
        
        // 右上方按钮
        CGFloat rightUpButW = topViewW - 7.5 / 568 * kHeight;
        CGFloat rightUpButH = 40 / 568.0 * kHeight;
        CGFloat rightUpButX = 0;
        CGFloat rightUpButY = 0;
        UIButton *rightUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
        rightUpBut.frame = CGRectMake(rightUpButX, rightUpButY, rightUpButW, rightUpButH);
        [rightUpBut setImage:butNorImg forState:UIControlStateNormal];
        [rightUpBut setImage:butHigImg forState:UIControlStateHighlighted];
        rightUpBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [topView addSubview:rightUpBut];
        [rightUpBut addTarget:self action:@selector(okButClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 分界线
        CGFloat lineViewW = baseViewW;
        CGFloat lineViewH = 1;
        CGFloat lineViewX = 0;
        CGFloat lineViewY = CGRectGetMaxY(topView.frame);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH)];
        lineView.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:144 / 255.0 blue:145 / 255.0 alpha:1];
        [baseView addSubview:lineView];
        
        // 提示文本
        NSString *fenStr = tipMessageStr;
        NSMutableDictionary *fenDic = [[NSMutableDictionary alloc] init];
        fenDic[NSFontAttributeName] = [UIFont systemFontOfSize:15 / 320.0 * kWidth];
        fenDic[NSForegroundColorAttributeName] = [UIColor blackColor];
        CGRect fenRect = [fenStr boundingRectWithSize:CGSizeMake(baseViewW - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fenDic context:nil];
        CGFloat msgLabW = baseViewW - 40;
        CGFloat msgLabH = fenRect.size.height + 6;
        CGFloat msgLabX = 20;
        CGFloat msgLabY = CGRectGetMaxY(tipLab.frame) + 20;
        UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(msgLabX, msgLabY, msgLabW, msgLabH)];
        msgLab.numberOfLines = 0;
        msgLab.font = [UIFont systemFontOfSize:15 / 320.0 * kWidth];
        msgLab.textColor = [UIColor colorWithRed:143 / 255.0 green:144 / 255.0 blue:145 / 255.0 alpha:1];
        msgLab.textAlignment = NSTextAlignmentCenter;
       
        // 设置行距
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:tipMessageStr];
        NSMutableParagraphStyle *paStyle = [[NSMutableParagraphStyle alloc] init];
        paStyle.lineSpacing = 2;
        [attStr addAttribute:NSParagraphStyleAttributeName value:paStyle range:NSMakeRange(0, [tipMessageStr length])];
        msgLab.attributedText = attStr;
        //        [msgLab sizeToFit]; // 这个是自适应
        [baseView addSubview:msgLab];
        
        // 下方按钮
        NSString *nameStr = buttonArray[0];
        NSMutableDictionary *attDic = [[NSMutableDictionary alloc] init];
        attDic[NSFontAttributeName] = [UIFont systemFontOfSize:14.5 / 320.0 * kWidth];
        attDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
        CGRect strRect = [nameStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil];
        CGFloat okButW = baseViewW;
        CGFloat okButH = tipLabH;
        CGFloat okButX = 0;
        CGFloat okButY= CGRectGetMaxY(msgLab.frame) + 20;
        _okBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBut.frame = CGRectMake(okButX, okButY, okButW, okButH);
        [baseView addSubview:_okBut];
        CGFloat okLabW = strRect.size.width + 20;
        CGFloat okLabH = 30;
        CGFloat okLabX = (baseViewW - okLabW) / 2.0;
        CGFloat okLabY = (okButH - okLabH) / 2.0;
        UILabel *okLab = [[UILabel alloc] initWithFrame:CGRectMake(okLabX, okLabY, okLabW, okLabH)];
        okLab.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:96 / 255.0 blue:1 / 255.0 alpha:1];
        okLab.textColor = [UIColor whiteColor];
        okLab.text = nameStr;
        okLab.font = [UIFont systemFontOfSize:14.5 / 320.0 * kWidth];
        okLab.textAlignment = NSTextAlignmentCenter;
        okLab.layer.cornerRadius = 7.5;
        okLab.clipsToBounds = YES;
        [_okBut addSubview:okLab];
        _okBut.layer.cornerRadius = 7.5;
        
        [_okBut addTarget:self action:@selector(okButClick) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat baseViewH2 = CGRectGetMaxY(_okBut.frame);
        baseView.frame = CGRectMake(baseViewX, baseViewY, baseViewW, baseViewH2);
        
    }
    
    return self;
}

- (void)okButClick {
    
    [self removeFromSuperview];
    
}


@end
