//
//  FooterCollectionReusableView.h
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterCollectionReusableView : UICollectionReusableView


@property (nonatomic,strong)UILabel * premiumLabel;
@property (nonatomic,strong)UILabel * costLabel;


-(instancetype)initWithFrame:(CGRect)frame;

@end
