//
//  DBHotCityTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cityClickBlock)(NSInteger);

@interface DBHotCityTableViewCell : UITableViewCell

@property (nonatomic,strong)cityClickBlock cityCilickBlock ;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNumber:(NSInteger)nmumber;

-(void)config:(NSArray*)array ;

@end
