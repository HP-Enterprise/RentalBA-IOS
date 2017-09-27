//
//  DBExplainView.h
//  GJCAR.COM
//
//  Created by 段博 on 2016/11/2.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUserInfoModel.h"

@interface DBExplainView : UIView <UIScrollViewDelegate>
{
    CGRect oldframe ;
}

@property (nonatomic,strong)UIScrollView * myScrollView ;
@property(nonatomic,strong)UIView * contenView;
@property (nonatomic,strong)DBUserInfoModel * userInfo ;

-(instancetype)initWithFrame:(CGRect)frame withData:(DBUserInfoModel*)model;
@end
