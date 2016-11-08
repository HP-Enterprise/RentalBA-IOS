//
//  DBvoucherTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBvoucherTableViewCell : UITableViewCell

{
    NSString * totalPrice ;
}

@property (nonatomic,strong)UILabel * titleLael ;
@property (nonatomic,strong)UILabel * timelabel ;
@property (nonatomic,strong)UILabel * scoreLabel ;
@property (nonatomic,strong)UILabel * consumeLabel;
@property (nonatomic,strong)UILabel * useLabel ;
-(void)config:(NSDictionary*)dic;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
