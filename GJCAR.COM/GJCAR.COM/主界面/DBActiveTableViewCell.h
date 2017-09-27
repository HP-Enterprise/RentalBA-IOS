//
//  DBActiveTableViewCell.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBActiveTableViewCell : UITableViewCell

//查看相信
@property (nonatomic,strong)UIButton    * more;

//还车时间选择
@property (nonatomic,strong)UIButton    * returnTime;

@property (nonatomic,strong)UIImageView * imageV;
@property (nonatomic,strong)UILabel     * title;
@property (nonatomic,strong)UILabel     * time;

@property (nonatomic,strong)UILabel     * descriptionLabel;
@property (nonatomic,strong)NSString    * link;
@property (nonatomic,strong)NSString    * id;
@property (nonatomic,strong)UILabel     * number;






-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)conFigWithModel:(NSDictionary*)dic;

@end
