
//
//  DBTaiilwindTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/24.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBTaiilwindTableViewCell.h"



@implementation DBTaiilwindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    
    return self ;
}


-(void)createUI

{
    
    //cell 顶部
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 0 , ScreenWidth, 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:toplineView];

    
    UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 10)];
    
    backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [self addSubview:backView ];

    
    
    
    //时间地点分割线
    UIView * toplineView1 = [[UIView alloc]initWithFrame:CGRectMake( 0 , 9.5 , ScreenWidth, 0.5)];
    toplineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:toplineView1];

    
    
    
    
    
    
    //创建车辆图片
    _imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(20, 20, 80, 50)];
    _imageV.image = [UIImage imageNamed:@"img-05.jpg"];
    [self addSubview:_imageV];

    //车辆名称
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth /2 , _imageV.frame.origin.y + 10 , ScreenWidth/3 +10 , 15)];
    
    _carName.text = @"中华 H330-1.5手动挡 ";
    //    if (_indexControl == 0 )
    //    {
    //        carName.text = [[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carName.text = [[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    

    _carName.font = [UIFont systemFontOfSize:12];
    [self addSubview:_carName];
    
    
    //车辆类型
    _carkind = [[UILabel alloc]initWithFrame:CGRectMake(_carName.frame.origin.x, CGRectGetMaxY(_carName.frame)+5, _carName.frame.size.width, 11 )];
    
    _carkind.text = @"手动/三厢/5座" ;
    
    //    if (_indexControl == 0 )
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //
    //    }
    
    

    _carkind.font = [UIFont systemFontOfSize:10];
    _carkind.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [self addSubview:_carkind];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(_imageV.frame)+10 , ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView];
    
    
    
    
    
    //用车时间
    

    //获取却车时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    
    NSString * dateString = [formatter stringFromDate:date]; ;
    
    
    _takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _takeTime.frame =CGRectMake( 10,CGRectGetMaxY(lineView.frame)+10, ScreenWidth / 4, 20);
    
    [_takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_takeTime setTitle:@"杭州" forState:UIControlStateNormal];
    
    //    [_takeTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:_takeTime];
    
    
    //星期
    _week = [[UILabel alloc]initWithFrame:CGRectMake(_takeTime.frame.origin.x,CGRectGetMaxY(_takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    _week.text =[NSString stringWithFormat:@"%@ %@",[dateString substringWithRange:NSMakeRange(5, 5)],[DBcommonUtils weekdayStringFromDate:date withDateStr:nil]];
    
    _week.textAlignment = 1 ;
    _week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    _week.font = [UIFont systemFontOfSize:12 ];
    [self addSubview:_week];
    
    
    //添加选取时间点击事件
    
    //    UIControl * takeDateChontrol = [[UIControl alloc]initWithFrame:CGRectMake(0, self.takeTime.frame.origin.y, ScreenWidth/4, 20)];
    //    [takeDateChontrol addTarget:self action:@selector(setTakeDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:takeDateChontrol];
    

    
    _returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _returnTime.frame =CGRectMake(ScreenWidth * 3 /4  - 10 ,_takeTime.frame.origin.y, ScreenWidth/4  , 20);
    _returnTime.titleLabel.textAlignment = 1 ;
    
    
    //获取还车时间
    [_returnTime setTitle:@"温州" forState:UIControlStateNormal];
    
    [_returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    //    [_returnTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    _returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_returnTime];
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSDate * returnDate = [formatter1 dateFromString:[DBcommonUtils dateWithDays:2]];
    
    
    //    星期
    _returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(_returnTime.frame.origin.x , _week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    _returnWeek.text =[NSString stringWithFormat:@"%@ %@",[[DBcommonUtils dateWithDays:2] substringWithRange:NSMakeRange(5, 5)],[DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil]];
    
    _returnWeek.font = [UIFont systemFontOfSize:12];
    _returnWeek.textAlignment = 1 ;
    _returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    _returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [self addSubview:_returnWeek];
    //
    
    
    
    
    //价格
    
    _pricelabel =[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth / 3 , CGRectGetMaxY(lineView.frame)+5, ScreenWidth / 3 , 20)];
    
    _pricelabel.text=@"￥ 100";
    _pricelabel.font = [UIFont systemFontOfSize:16];
    _pricelabel.textColor =  [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    _pricelabel.textAlignment = 1 ;
    
    [self addSubview:_pricelabel];
    
    
    
    
    //租车天数
    
    //中间图标
    UIImageView * imageView = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - 60 , 110, 120 , 22 )];
    imageView.image = [UIImage imageNamed:@"tailwindDays"];
    [self addSubview:imageView];
    
    
    //天数结果
    _number = [[UILabel alloc]initWithFrame:CGRectMake( 0 , 0 , imageView.frame.size.width , 22)];
    _number.text =@"限租4天";
    _number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    _number.textAlignment =1 ;
    _number.font = [UIFont systemFontOfSize:10 ];
    [imageView addSubview:_number];
    

    //时间地点分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(_returnWeek.frame)+15 , ScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView1];
    
    
    
    NSLog(@"%f",CGRectGetMaxY(lineView1.frame));
    
    
    
}


-(void)conFigWithModel:(DBFreeRideModel*)model
{
    
    
    NSString* encodedString = [[NSString stringWithFormat:@"%@%@",Host,[model.vehicleShow.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:
                                  encodedString] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];

    
    
//    [_imageV sd_setImageWithURL:[NSURL URLWithString:
//                                             [NSString stringWithFormat:@"%@%@",Host,model.vehicleShow.vehicleModelShow.picture]] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
    
    
    [_takeTime setTitle:model.takeCarCityShow.cityName forState:UIControlStateNormal];
    [_returnTime setTitle:model.returnCarCityShow.cityName forState:UIControlStateNormal];
//    _imageV.image
    _carName.text = model.vehicleShow.vehicleModelShow.model;
    
    
    NSString * carGroup ;
    switch ([model.vehicleShow.vehicleModelShow.carGroup integerValue])
    {
        case 1:
            carGroup = @"经济型";
            break;
        case 2:
            carGroup = @"舒适型";
            break;
        case 3:
            carGroup = @"豪华型";
            break;
        case 4:
            carGroup = @"SUV";
            break;
        case 5:
            carGroup = @"MPV";
            break;
            
        default:
            break;
    }
    
    
    
    NSString * carTurnk;
    
    if (model.vehicleShow.vehicleModelShow.carTrunk == nil)
    {
        carTurnk = @"";
        
    }
    else{
        if ([model.vehicleShow.vehicleModelShow.carTrunk integerValue] == 1 )
        {
            carTurnk = @"3厢";
        }
        else if ([model.vehicleShow.vehicleModelShow.carTrunk integerValue] == 2)
        {
            carTurnk = @"2厢";
        }
        else{
            carTurnk = @"";
        }
    }
    
    
    NSString * seat ;
    
    if (model.vehicleShow.vehicleModelShow.seats == nil)
    {
        seat = @"";
        
    }
    else{
        seat =[NSString stringWithFormat:@"%@座",model.vehicleShow.vehicleModelShow.seats] ;
    }
    
    _carkind.text = [NSString stringWithFormat:@"%@ | %@ | %@",carGroup,carTurnk,seat];

    
//    if ([model.vehicleShow.vehicleModelShow.carTrunk integerValue] == 1)
//    {
//        _carkind.text = [NSString stringWithFormat:@"%@ | 3厢 | %@座",carGroup,model.vehicleShow.vehicleModelShow.seats];
//
//    }
//     else if ([model.vehicleShow.vehicleModelShow.carTrunk integerValue] == 2)
//     {
//         _carkind.text = [NSString stringWithFormat:@"%@ | 2厢 | %@座",carGroup,model.vehicleShow.vehicleModelShow.seats];
//
//     }
    
    
    NSString * takeWeek =[DBcommonUtils weekdayStringFromDate:nil withDateStr:model.takeCarDateStart];
    
    NSString * returnWeek =[DBcommonUtils weekdayStringFromDate:nil withDateStr:model.takeCarDateEnd];

    _week.text =[NSString stringWithFormat:@"%@ %@",takeWeek,[model.takeCarDateStart substringWithRange:NSMakeRange(5, 5)]] ;
    _returnWeek.text =[NSString stringWithFormat:@"%@ %@",returnWeek,[model.takeCarDateEnd substringWithRange:NSMakeRange(5, 5)]] ;
    _pricelabel.text =[NSString stringWithFormat:@"￥ %@",model.price] ;
    _number.text = [NSString stringWithFormat:@"限租%@天",model.maxRentalDay] ;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
