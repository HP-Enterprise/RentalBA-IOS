//
//  DBStoreTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 2017/7/18.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBStoreTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * storeName ;
@property (nonatomic,strong)UILabel * storeAddr ;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)configWith:(NSDictionary*)dic;
@end
