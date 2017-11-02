//
//  DBScoreExchangeTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/8/22.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBColorCircleView.h"
@interface DBScoreExchangeTableViewCell : UITableViewCell

{
    NSString * totalPrice ;
}

@property (nonatomic,strong)UILabel * titleLael ;
@property (nonatomic,strong)UILabel * subtitle;
@property (nonatomic,strong)UILabel * timelabel ;

@property (nonatomic,strong)DBColorCircleView * progressView;
@property (nonatomic,strong)UILabel * scoreLabel ;
@property (nonatomic,strong)UILabel * leftoverNumber;
@property (nonatomic,strong)UILabel * useLabel ;

-(void)config:(NSDictionary*)dic;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
