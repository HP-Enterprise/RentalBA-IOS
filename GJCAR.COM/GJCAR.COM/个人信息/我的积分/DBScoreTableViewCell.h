//
//  DBScoreTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/5.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBScoreTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * titleLael ;
@property (nonatomic,strong)UILabel * timelabel ;
@property (nonatomic,strong)UILabel * scoreLabel ;



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
