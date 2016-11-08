
//
//  DBHotCityTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBHotCityTableViewCell.h"

@implementation DBHotCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNumber:(NSInteger)number
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createView:number];
    }
    return self;
}

-(void)createView:(NSInteger)number
{
    NSInteger count ;
    
    if (number % 3)
    {
        count =  number/3 +1 ;
    }
    else{
        count = number/3 ;
    }


    
    for (int i = 0 ; i < count; i ++)
    {
        
        
        
        for (int j = 0 ; j < 3 ; j ++)
        {
            
            if (number > 0)
            {
                UIButton * button = [ UIButton buttonWithType:UIButtonTypeCustom];
                
                button.frame = CGRectMake(10 + j *( 20 +(ScreenWidth - 10 - 80 )/3),  15 + i * 45, (ScreenWidth - 10- 80 )/3, 30);
                [button setTitle:@"城市" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0.5 ;
                button.layer.borderColor= [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor ;
                
                button.layer.cornerRadius = 3;
                
                button.tag = 200 + i * 3 + j ;
                [button addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];

                number -= 1 ;
            }
            else break ;
            
            
            
            
        }
    }
}

//热门城市点击
-(void)cityClick:(UIButton*)button
{
    self.cityCilickBlock(button.tag - 200);
    
}

-(void)config:(NSArray*)array
{
    
    
    for (int i  = 0 ; i < array.count; i++)
    {
        UIButton * button = [self.contentView viewWithTag:200 + i];
        [button setTitle:[array[i]objectForKey:@"cityName"] forState:UIControlStateNormal];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
