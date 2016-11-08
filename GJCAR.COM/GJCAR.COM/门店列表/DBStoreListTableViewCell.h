//
//  DBStoreListTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBStoreListTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * storeName ;
@property (nonatomic,strong)UILabel * storeAddr ;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
