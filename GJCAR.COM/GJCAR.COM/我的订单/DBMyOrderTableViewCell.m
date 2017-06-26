//
//  DBMyOrderTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/23.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBMyOrderTableViewCell.h"



@implementation DBMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        
        if ([reuseIdentifier isEqualToString:@"orderCell"])
        {
            self.orderIndex = 0 ;
        }
        else if ([reuseIdentifier isEqualToString:@"doortodoorCell"])
        {
            self.orderIndex = 1 ;
        }
        
        
        [self setCarInfoView];
    }
    return self;
}


#pragma mark ---创建车辆信息页面
-(void)setCarInfoView
{
    

    UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 10)];
    
    backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
    [self addSubview:backView ];

    //横线
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0, 9.5 , ScreenWidth, 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:toplineView];
    
    
    //订单编号
    
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake( 20, 10, ScreenWidth / 5 , 30)];
    orderLabel.text = @"订单编号 :" ;
    orderLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:orderLabel];
    
    
    
    //订单号
    
    
    _orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderLabel.frame),  10 , ScreenWidth - CGRectGetMaxX(orderLabel.frame)  - 50, 30)];
    _orderNumber.text = @"" ;
    _orderNumber.font = [UIFont systemFontOfSize:12];
    [self addSubview:_orderNumber];
    
    
    //订单状态
    _orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 50 , 10, 50 , 30)];
    
    _orderStatus.text = @"" ;
    _orderStatus.font = [UIFont systemFontOfSize:12];
    [self addSubview:_orderStatus];
    
    
    //横线
    UIView * orderlineView = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(orderLabel.frame)-0.5 , ScreenWidth, 0.5)];
    orderlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:orderlineView];

    
    
    
    //创建车辆图片
    _imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(orderlineView.frame)+10, 80, 50)];
    _imageV.image = [UIImage imageNamed:@"img-05.jpg"];
    [self addSubview:_imageV];

    
    
    //车辆名称
    _carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, _imageV.frame.origin.y + 10 , ScreenWidth - CGRectGetMaxX(_imageV.frame) , 15)];

    
    _carName.text = @"";
    //    if (_indexControl == 0 )
    //    {
    //        carName.text = [[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carName.text = [[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    
    
    _carName.font = [UIFont systemFontOfSize:13];
    [self addSubview:_carName];
    
    
    //车辆类型
    _carkind = [[UILabel alloc]initWithFrame:CGRectMake(_carName.frame.origin.x, CGRectGetMaxY(_carName.frame)+5, _carName.frame.size.width, 11 )];
    
    _carkind.text = @"" ;
    
    //    if (_indexControl == 0 )
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //
    //    }
    
    
    
    _carkind.font = [UIFont systemFontOfSize:11];
    _carkind.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [self addSubview:_carkind];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(_imageV.frame)+10 , ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView];
    
    
    
    //用车时间
    
    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(lineView.frame)+20, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [self addSubview:takeCar];
    
    //获取却车时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate date];
    
    NSString * dateString = [formatter stringFromDate:date]; ;
    
    
    _takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _takeTime.frame =CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20);
    
    [_takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_takeTime setTitle:[dateString substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    //    [_takeTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
     
    _takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:_takeTime];
    
    
    //星期
    _week = [[UILabel alloc]initWithFrame:CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(_takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    _week.text =[NSString stringWithFormat:@"%@ 10:00",[DBcommonUtils weekdayStringFromDate:date withDateStr:nil]];
    
    _week.textAlignment = 1 ;
    _week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    _week.font = [UIFont systemFontOfSize:12 ];
    [self addSubview:_week];
    
    
    //添加选取时间点击事件
    
    //    UIControl * takeDateChontrol = [[UIControl alloc]initWithFrame:CGRectMake(0, self.takeTime.frame.origin.y, ScreenWidth/4, 20)];
    //    [takeDateChontrol addTarget:self action:@selector(setTakeDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:takeDateChontrol];
    
    
    //还车时间
    UILabel * returnCartime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 4 - 10 ,takeCar.frame.origin.y, ScreenWidth/4, 10)];
    returnCartime.text = @"还车时间";
    returnCartime.textAlignment = 1 ;
    returnCartime.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCartime.font = [UIFont systemFontOfSize:12 ];
    [self addSubview:returnCartime];
    
    //时间
    
    _returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _returnTime.frame =CGRectMake
    (returnCartime.frame.origin.x ,_takeTime.frame.origin.y, ScreenWidth/4  , 20);
    _returnTime.titleLabel.textAlignment = 1 ;
    
    
    //获取还车时间
    [_returnTime setTitle:[[DBcommonUtils dateWithDays:2] substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    [_returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    //    [_returnTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    _returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_returnTime];
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSDate * returnDate = [formatter1 dateFromString:[DBcommonUtils dateWithDays:2]];
    
    
    //    星期
    _returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(returnCartime.frame.origin.x , _week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    _returnWeek.text =[NSString stringWithFormat:@"%@ 10:00",[DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil]];
    
    _returnWeek.font = [UIFont systemFontOfSize:12];
    _returnWeek.textAlignment = 1 ;
    _returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    _returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [self addSubview:_returnWeek];
    //
    
    
    //租车天数
    
    //中间图标
    UIImageView * imageView = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 4 + 10, CGRectGetMaxY(_takeTime.frame) -5 -ScreenWidth / 4 * 47 / 136, ScreenWidth / 2 - 20 , (ScreenWidth / 2 - 20) * 47 / 136 )];
    imageView.image = [UIImage imageNamed:@"zcDays"];
    [self addSubview:imageView];
    
    
    //天数结果
    _number = [[UILabel alloc]initWithFrame:CGRectMake(0 , 8, imageView.frame.size.width-2, 20)];
    _number.text =@"2";
    _number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    _number.textAlignment =1 ;
    _number.font = [UIFont systemFontOfSize:24 ];
    [imageView addSubview:_number];
    
    
    UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_number.frame)+5, _number.frame.size.width, 10)];
    day.text = @"天";
    day.textAlignment =1 ;
    day.textColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    day.font = [UIFont systemFontOfSize:12 ];
    [imageView addSubview:day];
    
    
    //时间地点分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( lineView.frame.origin.x , CGRectGetMaxY(_returnWeek.frame)+20 , lineView.frame.size.width, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView1];
    
    
    
    //取还车
    
    
    [self createPlace:lineView1.frame];
    
}

//创建取车地点
-(void)createPlace:(CGRect)frame
{
    
    //取车地点
    
    UILabel * takeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+10, CGRectGetMaxY(frame), ScreenWidth/3 - frame.origin.x, 40)];

    takeLabel.font = [ UIFont systemFontOfSize:12];
    
    takeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [self addSubview:takeLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeLabel addSubview:lineView1];
    
    
    //取车地点
    
    _takePlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(takeLabel.frame), takeLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(takeLabel.frame) - 10, takeLabel.frame.size.height)];
    _takePlace.text = @"武汉" ;
    
    _takePlace.font = [ UIFont systemFontOfSize:12];
    
    _takePlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [self addSubview:_takePlace];

    //取还车分割线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(takeLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView2];
    
    
    
    //**************************还车地点
    
    //还车地点
    
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(takeLabel.frame.origin.x, CGRectGetMaxY(takeLabel.frame), takeLabel.frame.size.width, 40)];

    if (self.orderIndex == 0){
        takeLabel.text = @"取车地点";
        returnLabel.text = @"还车地点";
    }
    else if (self.orderIndex ==1){
        takeLabel.text = @"取车地点";
        returnLabel.text = @"还车地点";
    }
    else if (self.orderIndex ==3){
        takeLabel.text = @"取车门店";
        returnLabel.text = @"还车门店";
    }

    
    returnLabel.font = [ UIFont systemFontOfSize:12];
    
    returnLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [self addSubview:returnLabel];
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( returnLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [returnLabel addSubview:lineView3];
    
    
    //还车地点
    
    _retuenPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame), returnLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(returnLabel.frame) - 10, returnLabel.frame.size.height)];
    
    _retuenPlace.text = @"武汉光谷";
    _retuenPlace.font = [ UIFont systemFontOfSize:12];
    
    _retuenPlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [self addSubview:_retuenPlace];
    
    
    //取还车分割线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(returnLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView4];
    

    //取还车分割线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView4.frame)+20 , ScreenWidth  , 0.5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self addSubview:lineView5];

    NSLog(@"%f",CGRectGetMaxY(lineView5.frame));
}



-(void)cellConfigWithModel:(DBOrderModel*)model
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * takeDate =[NSDate dateWithTimeIntervalSince1970:[model.takeCarDate doubleValue]/1000];
    NSDate * returnDate =[NSDate dateWithTimeIntervalSince1970:[model.returnCarDate doubleValue]/1000];
    NSString * takeTimeStr =[formatter stringFromDate:takeDate];
    NSString * returnTimeStr =[formatter stringFromDate:returnDate];
    NSLog(@"%@",takeTimeStr);
   
    
    
    
    NSString* encodedString;
    if ([model.orderType isEqualToString:@"2"]) {
        
        encodedString = [[NSString stringWithFormat:@"%@%@",Host,[model.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _carName.text = model.vehicleModelShow.model ;
        
        NSString * carGroup ;
        if (model.vehicleModelShow.carGroup == nil)
        {
            carGroup = @"" ;
        }
        else
        {
            if ([model.vehicleModelShow.carGroup isEqualToString:@"1"]) {
                carGroup = @"自动挡";
            }
            else{
                carGroup = @"手动挡";
            }
        }
        
        NSString * trunk ;
        if (model.vehicleModelShow.carTrunk == nil){
            trunk = @"" ;
        }
        
        else
        {
            if ([model.vehicleModelShow.carTrunk isEqualToString:@"1"]) {
                trunk = @"3厢";
            }
            else{
                trunk = @"2厢";
            }
        }
        
        NSString * seats ;
        if (model.vehicleModelShow.seats == nil)
        {
            seats = @"" ;
        }
        else
        {
            seats =[NSString stringWithFormat:@"%@座",model.vehicleModelShow.seats];

        }
            
        _carkind.text =[NSString stringWithFormat:@"%@ | %@ | %@",carGroup,trunk,seats];

        
    }
    else if ([model.orderType isEqualToString:@"1"]){
        encodedString = [[NSString stringWithFormat:@"%@%@",Host,[model.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        _carName.text = model.model ;
        
        NSString * carGroup ;
        if (model.carGroupstr == nil) {
            carGroup = @"" ;
        }
        else {
            carGroup = model.carGroupstr;
        }
        NSString * trunk ;
        if (model.carTrunkStr == nil){
            trunk = @"" ;
        }
        else {
            trunk = model.carTrunkStr ;
        }
        NSString * seats ;
        if (model.seatsStr == nil)  {
            seats = @"" ;
        }
        else{
            seats = model.seatsStr ;
        }
        _carkind.text =[NSString stringWithFormat:@"%@ | %@ | %@",carGroup,trunk,seats];

    }
    [_imageV sd_setImageWithURL:[NSURL URLWithString:
                                encodedString] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];

 
    [_takeTime setTitle:[takeTimeStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    [_returnTime setTitle:[returnTimeStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    

    
    

    //取还车星期
    _week.text =[NSString stringWithFormat:@"%@ %@",[DBcommonUtils weekdayStringFromDate:takeDate withDateStr:nil],[takeTimeStr substringWithRange:NSMakeRange(11, 5)]];

    _returnWeek.text =[NSString stringWithFormat:@"%@ %@",[DBcommonUtils weekdayStringFromDate:returnDate withDateStr:nil],[returnTimeStr substringWithRange:NSMakeRange(11, 5)]];
    
    //取还车地址
    
    
    _takePlace.text = model.takeCarAddress ;
    _retuenPlace.text = model.returnCarAddress;
    
    //订单
    _orderNumber.text = [NSString stringWithFormat:@"%@",model.orderId] ;
    
    //天数
    if (model.tenancyDays == nil)
    {
        _number.text  =@"0";
    }
    else
    {
        _number.text = [NSString stringWithFormat:@"%@",model.tenancyDays];
    }

    //jsonObject.put("orderState", 1);//订单状态（0：待支付，1：已下单 2：租赁中 3：已还车 4：已完成 5：已取消 6：NoShow）

    
    NSString * status ;
    
    //自驾
    if (self.orderIndex == 0)
    {
        switch ([model.orderState integerValue])
        {
            case 0:
            {
                status = @"待支付";
            }
                break;
            case 1:
            {
                status = @"已下单";
            }
                break;
                
            case 2:
            {
                status = @"租赁中";
            }
                break;
                
            case 3:
            {
                status = @"已还车";
            }
                break;
            case 4:
            {
                status = @"已完成";
            }
                break;
            case 5:
            {
                status = @"已取消";
            }
                break;
        }
    }
    else if (self.orderIndex ==1)
    {
        switch ([model.orderState integerValue])
        {
            case 0:
            {
                status = @"待支付";
            }
                break;
            case 1:
            {
                status = @"已下单";
            }
                break;
            case 2:
            {
                status = @"已下单";
            }
                break;
            case 3:
            {
                status = @"已下单";
            }
                break;
                
            case 4:
            {
                status = @"租赁中";
            }
                break;
            case 5:
            {
                status = @"租赁中";
            }
                break;
            case 6:
            {
                status = @"租赁中";
            }
                break;
                
            case 7:
            {
                status = @"已还车";
            }
                break;

            case 9:
            {
                status = @"已取消";
            }
                break;
        }
    }
    _orderStatus.text = status;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
