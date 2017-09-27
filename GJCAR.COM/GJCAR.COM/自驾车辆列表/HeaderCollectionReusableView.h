//
//  HeaderCollectionReusableView.h
//  UICollectionView
//
//  Created by smith on 15/12/10.
//  Copyright © 2015年 smith. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^changeMonthBlock)(NSString*);

@interface HeaderCollectionReusableView : UICollectionReusableView

@property ( nonatomic,strong)UIButton * lastBt;
@property (nonatomic,strong)UIButton * nextBt ;
@property (nonatomic,strong)UILabel * timeLabel ;


@property (nonatomic,strong)changeMonthBlock  changeMonthBlock;


-(instancetype)initWithFrame:(CGRect)frame;

//-(void)config:(NSString*)date;
@end
