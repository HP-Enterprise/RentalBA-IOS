#pragma mark ---创建费用View//
//  DBOrderSubmitViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBOrderPriceViewController.h"
#import "DBMyOrderViewController.h"
#import "DBOrderPayViewController.h"
#import "DBShowListModel.h"
#import "DBActivityShows.h"
#import "DBOrderData.h"

@interface DBOrderPriceViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UIButton * showCarBt ;
    DBTextField *nameFiled;
    DBTextField *cardNumberFiled;
    UIView * temporaryView ;
    NSMutableDictionary * userInfoDic ;
    //优惠券数据
    NSArray * couponArray;
    //当前展示数据
    NSArray * showArray;
    //记录上一次选的优惠活动
    UIControl * lastBt;
    //记录优惠活动还是优惠券
    UIControl * actBt ;
    //活动弹窗
    UIView * saleView ;
    //费用合计
    UIView * totleCostView;
    //选择的优惠选项
    NSDictionary * showDic ;
    //优惠说明
    UILabel *  reduceExplace ;
    //优惠价格
    UILabel *  reducePrice ;
    //费用合计
    UILabel * totleCost ;
    UITableView * saleTableView ;
    //优惠券id
    NSString * couponId ;
    //优惠活动id
    NSString * activityId ;
    //同意按钮
    UIView * baseView ;
    
    //记录两次点击是否相同
    BOOL isSame ;
    
}
//取车时间选择
@property (nonatomic,strong)UIButton * takeTime;
//还车时间选择
@property (nonatomic,strong)UIButton * returnTime;
@property (nonatomic,strong)UIScrollView * orderScrollView;
@property (nonatomic,strong)UIView * priceView ;
//增值费用
@property (nonatomic,strong)NSString * addValuePrice ;
//费用总数
@property (nonatomic,strong)NSString * totalePrice ;
@property (nonatomic,strong)UIView * avtivityBackView;
//错误提示
@property (nonatomic,strong)UIView  *tipView;
@property (nonatomic,strong)DBProgressAnimation * progress ;
@end

@implementation DBOrderPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建导航栏
    [self setNavgationView];
    
    //创建scrollView
    //    [self setOrderScrollview];
    
    //加载个人信息
    [self loadUserInfo];
    
}


//门店取车价格加载
-(void)loadStorePrice:(NSInteger)button
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
    NSString * url ;
    NSString * activityBtId ;
    
    if (button == 660) {
        activityBtId = [self.activityDic objectForKey:@"id"];
        url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=%@&modelId=%@&storeId=%@&userId=%@",Host,activityBtId,_model.vehicleModelShow.id,model.id,[user objectForKey:@"userId"]];
    }
    
    else if(button == 661 || button == 662)
    {
        
        url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=&modelId=%@&storeId=%@&userId=%@",Host,_model.vehicleModelShow.id,model.id,[user objectForKey:@"userId"]];
        
    }
    
    NSMutableDictionary * pardic = [NSMutableDictionary dictionary];
    
    pardic[@"endDate"]= [ user objectForKey:@"returnTime"];
    pardic[@"startDate"]= [ user objectForKey:@"takeTime"];
    pardic[@"takeCityId"] =[ user objectForKey:@"takeCityId"];
    pardic[@"returnCityId"] =[ user objectForKey:@"returnCityId"];
    pardic[@"returnStoreId"] =[[user objectForKey:@"returnStore"]objectForKey:@"id"];
    
    NSLog(@"%@",[ user objectForKey:@"returnTime"]);
    NSLog(@"%@",[ user objectForKey:@"takeTime"]);
    
    [self addProgress];
    __weak typeof(self)weak_self = self ;
    
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {
        
        [weak_self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _priceDic = [responseObject objectForKey:@"message"];
            
            NSNumber * number = [NSNumber numberWithInteger:button];
            
            if (button == 661) {
                
                [weak_self loadCoupons];
            }
            else{
                [weak_self performSelectorOnMainThread:@selector(configView:) withObject:number waitUntilDone:YES];
            }
            
        }
        
    } failure:^(NSError *error) {
        //        NSNumber * number = [NSNumber numberWithInteger:662];
        //        [weak_self performSelectorOnMainThread:@selector(configView:) withObject:number waitUntilDone:YES];
        [weak_self tipShow:@"加载失败"];
        [weak_self removeProgress];
    }];
}


-(void)loadPrice{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
    NSString * url ;

    url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=&modelId=%@&storeId=%@&userId=%@",Host,_model.vehicleModelShow.id,model.id,[user objectForKey:@"userId"]];
    
    NSMutableDictionary * pardic = [NSMutableDictionary dictionary];
    
    pardic[@"endDate"]= [ user objectForKey:@"returnTime"];
    pardic[@"startDate"]= [ user objectForKey:@"takeTime"];
    pardic[@"takeCityId"] =[ user objectForKey:@"takeCityId"];
    pardic[@"returnCityId"] =[ user objectForKey:@"returnCityId"];
    pardic[@"returnStoreId"] =[[user objectForKey:@"returnStore"]objectForKey:@"id"];
    
    NSLog(@"%@",[ user objectForKey:@"returnTime"]);
    NSLog(@"%@",[ user objectForKey:@"takeTime"]);
    
    [self addProgress];
    __weak typeof(self)weak_self = self ;
    isSame = NO ;
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {
        
        [weak_self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _priceDic = [responseObject objectForKey:@"message"];

            [weak_self performSelectorOnMainThread:@selector(configView:) withObject:[NSNumber numberWithInteger:662] waitUntilDone:YES];
            
        }
        else{
            [weak_self tipShow:@"加载失败"];
        }
        
    } failure:^(NSError *error) {
        //        NSNumber * number = [NSNumber numberWithInteger:662];
        //        [weak_self performSelectorOnMainThread:@selector(configView:) withObject:number waitUntilDone:YES];
        [weak_self tipShow:@"加载失败"];
        [weak_self removeProgress];
    }];
}

#pragma mark 加载优惠券

-(void)loadCoupons
{
    [self.tipView removeFromSuperview];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    if (!couponArray)
    {
        couponArray = [NSArray array];
        
        
        couponArray = [NSArray array];
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
        
        //        NSString * url = [NSString stringWithFormat:@"%@/api/me/coupon?consume=%@&currentPage=1&pageSize=100&state=2&willBeUseTimeBegin=%@&willBeUseTimeEnd=%@&source=5",Host,[_priceDic objectForKey:@"totalPrice"],willBeUseTimeBegin,willBeUseTimeEnd];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd+HH:MM:ss"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        
        
        
        NSString * url = [NSString stringWithFormat:@"%@/api/me/canUsedCoupon?consume=%@&rental=%@&cityId=%@&storeId=%@&modelId=%@&useTime=%@&uid=%@&state=2&source=5&currentPage=1&pageSize=100",Host,[_priceDic objectForKey:@"totalPrice"],[_priceDic objectForKey:@"totalAmount"],[user objectForKey:@"takeCityId"],model.id,_model.vehicleModelShow.id,dateTime,[user objectForKey:@"userId"]];
        NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
        parDic[@"uid"]= [user objectForKey:@"userId"];
        //        parDic[@"willBeUseTimeBegin"] = willBeUseTimeBegin;
        //        parDic[@"willBeUseTimeEnd"]= willBeUseTimeEnd;
        
        __weak typeof(self)weak_self = self ;
        
        [DBNetworkTool Get:url parameters:nil success:^(id responseObject)
         {
             
             
             if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
             {
                 
                 if (![[responseObject objectForKey:@"message"]isKindOfClass:[NSNull class]] && [responseObject objectForKey:@"message"] != nil && [NSArray arrayWithArray:[responseObject objectForKey:@"message"]].count > 0  )
                 {
                     
                     couponArray = [responseObject objectForKey:@"message"];
                     showArray  = couponArray ;
                     
                     [self addView];
                 }
                 else
                 {
                     [weak_self tipShow:@"没有可用的优惠券"];
                     [self configView:@662];
                     
                 }
             }
             else
             {
                 [weak_self tipShow:@"没有可用的优惠券"];
                 [self configView:@662];
                 
             }
             
         } failure:^(NSError *error) {
             
             
             [weak_self tipShow:@"加载失败"];
             
         }];
    }
    
    else
    {
        
        if (couponArray.count>0){
            [self addView];
        }
        else{
            [self tipShow:@"没有可用优惠券"];
            [self configView:@662];
        }
        
        
    }
    
    
}


#pragma mark 加载个人信息

-(void)loadUserInfo{
    
    userInfoDic  = [NSMutableDictionary dictionary];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me",Host];
    
    [self addProgress];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        
        [self removeProgress];
        
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            userInfoDic =[NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"message"]];
            [self performSelectorOnMainThread:@selector(setOrderScrollview) withObject:nil waitUntilDone:YES];
            
        }
        else  {
            [self tipShow:@"登录信息有误"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark 加载动画
-(void)addProgress
{
    _progress = [[DBProgressAnimation alloc]init];
    [_progress addProgressAnimationWithViewControl:self];
    
}


-(void)removeProgress
{
    if (_progress != nil)
    {
        [_progress removeProgressAnimation];
    }
}


#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"确认订单" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    
    [self.view addSubview:nav];
    
    isSame = YES ;
}

#pragma mark ---创建scrollview
//创建scrollview
-(void)setOrderScrollview
{
    
    
    
    
    _orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight- 64 )];
    
    NSUserDefaults  * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:@"takeState"]isEqualToString:@"1"])
    {
        _orderScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight );
        
        if (_addValueArr.count > 0)
        {
            _orderScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight +40 * _addValueArr.count );
            
        }
        
    }
    else
    {
        _orderScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 64 );
        
        if (_addValueArr.count > 0)
        {
            _orderScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 64 + 40 * _addValueArr.count );
            
        }
        
        
    }
    
    
    NSString* deviceType = [UIDevice currentDevice].model;
    NSLog(@"deviceType = %@", deviceType);
    if ([deviceType isEqualToString:@"iPad"]) {
        
        _orderScrollView.contentSize = CGSizeMake(ScreenWidth, _orderScrollView.contentSize.height + 80 );
    }
    
    _orderScrollView.delegate = self;
    
    
    _orderScrollView.showsVerticalScrollIndicator = NO;
    _orderScrollView.showsHorizontalScrollIndicator = NO;
    
    
    [self.view addSubview:_orderScrollView];
    
    
    //创建车辆信息页面
    
    [self setCarInfoView];
    
}

#pragma mark ---创建车辆信息页面
-(void)setCarInfoView
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    
    
    //创建车辆图片
    UIImageView * imageV = [[UIImageView  alloc]initWithFrame:CGRectMake(50, 10, 80, 50)];
    
    
    NSString * encodedString = [[NSString stringWithFormat:@"%@%@",Host,[self.model.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:
                                encodedString] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
    
    [_orderScrollView addSubview:imageV];
    imageV.tag = 801 ;
    
    
    //车辆名称
    UILabel * carName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame)+10, imageV.frame.origin.y + 5 , ScreenWidth - CGRectGetMaxX(imageV.frame) , 15)];
    carName.tag = 802;
    
    carName.text = self.model.vehicleModelShow.model ;
    //    if (_indexControl == 0 )
    //    {
    //        carName.text = [[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carName.text = [[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"model"];
    //    }
    
    
    carName.font = [UIFont systemFontOfSize:13];
    [_orderScrollView addSubview:carName];
    
    
    //车辆类型
    UILabel * carkind = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carName.frame)+5, carName.frame.size.width, 11 )];
    
    
    NSString * carGroup ;
    switch ([self.model.vehicleModelShow.carGroup integerValue])
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
    
    if (self.model.vehicleModelShow.carTrunk == nil)
    {
        carTurnk = @"";
        
    }
    else
    {
        if ([self.model.vehicleModelShow.carTrunk integerValue] == 1 )
        {
            carTurnk =@"3厢";
        }
        else if ([self.model.vehicleModelShow.carTrunk integerValue] == 2)
        {
            carTurnk = @"2厢";
        }
        
    }
    
    
    NSString * seat ;
    if (self.model.vehicleModelShow.seats == nil)
    {
        seat = @"";
    }
    else{
        seat = [NSString stringWithFormat:@"%@座",self.model.vehicleModelShow.seats];
    }
    
    carkind.text =[NSString stringWithFormat:@"%@ | %@ | %@",carGroup,carTurnk,seat];
    
    
    //    if (_indexControl == 0 )
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.storeDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //    }
    //    else if (_indexControl == 1)
    //    {
    //        carkind.text =[NSString stringWithFormat:@"自动挡 | %@厢 | %@座 | %@",[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"carTrunk"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"seats"],[[self.carInfoDic objectForKey:@"vehicleModelShow"]objectForKey:@"displacement"]];
    //
    //    }
    
    carkind.font = [UIFont systemFontOfSize:11];
    carkind.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    [_orderScrollView addSubview:carkind];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(imageV.frame)+10 , ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView];
    
    //用车时间
    
    //取车时间
    UILabel * takeCar = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(lineView.frame)+20, ScreenWidth/4, 10)];
    takeCar.text = @"取车时间";
    takeCar.textAlignment = 1 ;
    takeCar.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCar.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_orderScrollView addSubview:takeCar];
    
    //获取却车时间
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    NSDate* date = [NSDate date];
    
    NSString * dateString = [user objectForKey:@"takeCarDate"] ;
    
    
    _takeTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _takeTime.frame =CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(takeCar.frame)+5, ScreenWidth / 4, 20);
    
    [_takeTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_takeTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    [_takeTime setTitle:[dateString substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    //    [_takeTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _takeTime.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [_orderScrollView addSubview:_takeTime];
    
    
    //星期
    UILabel * week = [[UILabel alloc]initWithFrame:CGRectMake(takeCar.frame.origin.x,CGRectGetMaxY(_takeTime.frame)+5, ScreenWidth/4, 10 )];
    
    week.text =[user objectForKey:@"takeWeek"];
    
    week.textAlignment = 1 ;
    week.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    week.font = [UIFont systemFontOfSize:12 ];
    [_orderScrollView addSubview:week];
    
    
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
    [_orderScrollView addSubview:returnCartime];
    
    //时间
    
    _returnTime = [UIButton buttonWithType:UIButtonTypeCustom ];
    
    _returnTime.frame =CGRectMake
    (returnCartime.frame.origin.x ,_takeTime.frame.origin.y, ScreenWidth/4  , 20);
    _returnTime.titleLabel.textAlignment = 1 ;
    
    NSString * returnStr = [user objectForKey:@"returnCarDate"];
    //获取还车时间
    [_returnTime setTitle:[returnStr substringWithRange:NSMakeRange(5, 5)] forState:UIControlStateNormal];
    
    [_returnTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //    [_returnTime setTitleColor:[DBcommonUtils getColor:@"1b8cce"] forState:UIControlStateNormal];
    //    [_returnTime addTarget:self action:@selector(setDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    _returnTime.titleLabel.font = [UIFont systemFontOfSize:16];
    [_orderScrollView addSubview:_returnTime];
    
    
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //    星期
    UILabel * returnWeek = [[UILabel alloc]initWithFrame:CGRectMake(returnCartime.frame.origin.x , week.frame.origin.y, ScreenWidth/4, 10)];
    
    
    returnWeek.text =[user objectForKey:@"returnWeek"];
    
    returnWeek.font = [UIFont systemFontOfSize:12];
    returnWeek.textAlignment = 1 ;
    returnWeek.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnWeek.font = [UIFont systemFontOfSize:12 * ScreenWidth / 320];
    [_orderScrollView addSubview:returnWeek];
    //
    
    
    //租车天数
    
    //中间图标
    UIImageView * imageView = [[ UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 4 + 10, CGRectGetMaxY(_takeTime.frame) -5 -ScreenWidth / 4 * 47 / 136, ScreenWidth / 2 - 20 , (ScreenWidth / 2 - 20) * 47 / 136 )];
    imageView.image = [UIImage imageNamed:@"zcDays"];
    [_orderScrollView addSubview:imageView];
    
    
    //天数结果
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(0 , 8, imageView.frame.size.width-2, 20)];
    number.text =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"daySum"]];
    number.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    number.textAlignment =1 ;
    number.font = [UIFont systemFontOfSize:24 ];
    [imageView addSubview:number];
    
    
    UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(number.frame)+5, number.frame.size.width, 10)];
    day.text = @"天";
    day.textAlignment =1 ;
    day.textColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    day.font = [UIFont systemFontOfSize:12 ];
    [imageView addSubview:day];
    
    
    //时间地点分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( lineView.frame.origin.x , CGRectGetMaxY(returnWeek.frame)+20 , lineView.frame.size.width, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView1];
    
    //取还车
    
    [self createPlace:lineView1.frame];
    
}

//创建取车地点
-(void)createPlace:(CGRect)frame
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //取车地点
    
    UILabel * takeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+10, CGRectGetMaxY(frame), ScreenWidth/3 - frame.origin.x, 40)];
    takeLabel.text = @"取车地点";
    takeLabel.font = [ UIFont systemFontOfSize:12];
    
    takeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_orderScrollView addSubview:takeLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [takeLabel addSubview:lineView1];
    
    
    //取车地点
    
    UILabel * takePlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(takeLabel.frame) , takeLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(takeLabel.frame) - 40, takeLabel.frame.size.height)];
    
    //判断是门店取车还是送车上门
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        takePlace.text = [[user objectForKey:@"takePlace"]objectForKey:@"name"] ;
    }
    else
    {
        takePlace.text =[NSString stringWithFormat:@"%@(%@)",[[user objectForKey:@"takeStore"]objectForKey:@"storeName"],[[user objectForKey:@"takeStore"]objectForKey:@"detailAddress"]] ;
        
    }
    
    
    DBLog(@"%@",[user objectForKey:@"takeStore"]);
    
    
    
    takePlace.numberOfLines = 2 ;
    takePlace.font = [ UIFont systemFontOfSize:11];
    
    takePlace.adjustsFontSizeToFitWidth = YES ;
    
    takePlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_orderScrollView addSubview:takePlace];
    
    
    
    
    //地图图标
    
    UIImageView  * mapView = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth - 40, takePlace.frame.origin.y+11.5, 12, 17)];
    
    mapView.image = [UIImage imageNamed:@"mapCenter"];
    //    [_orderScrollView addSubview:mapView];
    
    //取车地点
    //地图点击事件
    UIControl * takeMap =[[UIControl alloc]initWithFrame:CGRectMake(mapView.frame.origin.x - 20, takePlace.frame.origin.y, 42, 40)];
    
    [takeMap addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    takeMap.tag = 550 ;
    
    [_orderScrollView addSubview:takeMap];
    
    
    
    //取还车分割线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(takeLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView2];
    
    
    
    //**************************还车地点
    
    //还车地点
    
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(takeLabel.frame.origin.x, CGRectGetMaxY(takeLabel.frame), takeLabel.frame.size.width, 40)];
    returnLabel.text = @"还车地点";
    returnLabel.font = [ UIFont systemFontOfSize:12];
    
    returnLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_orderScrollView addSubview:returnLabel];
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( returnLabel.frame.size.width - 20 , 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [returnLabel addSubview:lineView3];
    
    
    //还车地点
    
    UILabel * retuenPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnLabel.frame) , returnLabel.frame.origin.y,ScreenWidth - CGRectGetMaxX(returnLabel.frame) - 40, returnLabel.frame.size.height)];
    
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        retuenPlace.text = [[user objectForKey:@"returnPlace"]objectForKey:@"name"] ;
    }
    else
    {
        retuenPlace.text =[NSString stringWithFormat:@"%@(%@)",[[user objectForKey:@"returnStore"]objectForKey:@"storeName"],[[user objectForKey:@"returnStore"]objectForKey:@"detailAddress"]] ;
        
    }
    
    
    
    
    
    retuenPlace.numberOfLines = 2 ;
    retuenPlace.font = [ UIFont systemFontOfSize:11];
    retuenPlace.adjustsFontSizeToFitWidth = YES ;
    retuenPlace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    [_orderScrollView addSubview:retuenPlace];
    
    
    //取还车分割线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(returnLabel.frame) , ScreenWidth - 40 , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView4];
    
    
    //地图图标
    
    UIImageView  * mapView1 = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth - 40, returnLabel.frame.origin.y+11.5, 12, 17)];
    
    mapView1.image = [UIImage imageNamed:@"mapCenter"];
    //    [_orderScrollView addSubview:mapView1];-
    
    
    //取车地点
    //地图点击事件
    UIControl * returnMap =[[UIControl alloc]initWithFrame:CGRectMake(mapView1.frame.origin.x - 20, returnLabel.frame.origin.y, 42, 40)];
    
    [returnMap addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    returnMap.tag = 551 ;
    
    [_orderScrollView addSubview:returnMap];
    
    
    
    //取还车分割线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView4.frame)+20 , ScreenWidth  , 0.5)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_orderScrollView addSubview:lineView5];
    
    
    //创建信息填写
    [self fullInUserInfo:lineView5.frame];
    
    
    
    
    
}

#pragma mark ---创建信息完善页面
-(void)fullInUserInfo:(CGRect)frame
{
    
    
    
    temporaryView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 120)];
    
    
    //联系人信息
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    
    //    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    //    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    //    [mustCost addSubview:lineView];
    
    [temporaryView addSubview:mustCost];
    
    //联系人信息
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"联系人信息";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    
    //姓名
    
    nameFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mustCost.frame), ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    nameFiled.backgroundColor = [UIColor whiteColor];
    nameFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    nameFiled.field.delegate = self ;
    nameFiled.field.placeholder = @"请输入姓名";
    [nameFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [nameFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    nameFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    
    
    
    UIView * changePwLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 0.5)];
    changePwLine.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    
    [nameFiled addSubview:changePwLine];
    [temporaryView addSubview:nameFiled];
    
    
    
    //证件号码
    
    cardNumberFiled = [[DBTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameFiled.frame), ScreenWidth, 40 ) withImage:nil withTitle:nil];
    
    cardNumberFiled.backgroundColor = [UIColor whiteColor];
    cardNumberFiled.field.font = [UIFont systemFontOfSize:12];
    //    nameFiled.layer.cornerRadius = 5 ;
    //    nameFiled.layer.borderWidth = 0.5 ;
    //    nameFiled.layer.borderColor = [DBcommonUtils getColor:@"9e9e9f"].CGColor;
    
    cardNumberFiled.field.delegate = self ;
    cardNumberFiled.field.placeholder = @"请输入身份证号码";
    [cardNumberFiled.field setValue:[UIFont systemFontOfSize:12 ] forKeyPath:@"_placeholderLabel.font"];
    [cardNumberFiled.field setValue:[DBcommonUtils getColor:@"9e9e9f"] forKeyPath:@"_placeholderLabel.textColor"];
    cardNumberFiled.field.textColor = [DBcommonUtils getColor:@"9e9e9f"];
    [temporaryView addSubview:cardNumberFiled];
    
    
    
    
    
    
    
    //创建费用view
    
    if ([userInfoDic objectForKey:@"credentialNumber"]==nil || [[userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"credentialNumber"]isEqualToString:@""] || [userInfoDic objectForKey:@"realName"]==nil || [[userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"realName"]isEqualToString:@""])
    {
        
        
        
        [_orderScrollView addSubview:temporaryView];
        
        _orderScrollView.contentSize = CGSizeMake(ScreenWidth, _orderScrollView.contentSize.height + 120 );
        [self preferentialViewWithFrme:temporaryView.frame];
        
    }
    
    else
    {
        [self preferentialViewWithFrme:frame];
        
    }
    
    
    
}


#pragma mark ---优惠活动选择页面
-(void)preferentialViewWithFrme:(CGRect)frame
{
    
    //判断是否有优惠活动
    
    //    DBShowListModel * model = [[NSArray arrayWithArray:self.model.vendorStorePriceShowList]firstObject] ;
    
    
    _avtivityBackView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 100)];
    _avtivityBackView.backgroundColor = [UIColor whiteColor];
    
    
    [_orderScrollView addSubview:_avtivityBackView];
    
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [_avtivityBackView addSubview:mustCost];
    
    
    CGRect temporaryFrame = mustCost.frame ;
    
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"选择优惠";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    
    
    //车辆活动
    
    UILabel * activityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(mustCost.frame) + 7.5, 15, 15)];
    activityLabel.tag = 599 ;
    activityLabel.frame = CGRectMake(20, CGRectGetMaxY(mustCost.frame) + 7.5, 15, 15);
    activityLabel.backgroundColor = [UIColor whiteColor];
    activityLabel.layer.borderWidth = 1;
    activityLabel.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    
    
    
    //优惠活动
    UILabel * activityLabelName = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(mustCost.frame), 80 , 30)];
    activityLabelName.text = @"优惠活动";
    activityLabelName.numberOfLines = 2 ;
    activityLabelName.font = [ UIFont systemFontOfSize:12];
    activityLabelName.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    activityLabelName.tag = 699 ;
    
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 , 29.5 , ScreenWidth , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [activityLabelName addSubview:lineView2];
    
    lineView2.tag = 700 ;
    
    UIButton * activityChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    activityChoose.frame = CGRectMake(120, activityLabel.frame.origin.y, ScreenWidth / 3 +50,activityLabel.frame.size.height );
    [activityChoose setTitle:@"请选择优惠活动" forState:UIControlStateNormal] ;
    activityChoose.titleLabel.font = [UIFont systemFontOfSize:10];
    activityChoose.titleLabel.numberOfLines = 0;
    [activityChoose setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
    activityChoose.hidden = YES;
    //    [activityChoose addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    activityChoose.tag = 652 ;
    
    if ([self.index isEqualToString:@"1"]) {
        
    }
    
    
    UIControl * activityC = [[UIControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mustCost.frame), ScreenWidth, 30)];
    
    [activityC addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    activityC.tag = 660 ;
    
    
    if (self.activityDic) {
        if ([self.index isEqualToString:@"0"]) {
            [activityChoose setTitle:[[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"activityDescription"]  forState:UIControlStateNormal] ;
            activityChoose.titleLabel.adjustsFontSizeToFitWidth = YES;
            activityChoose.hidden = NO;
            
            activityC.selected = YES ;
            actBt = activityC ;
        }
        _avtivityBackView.frame = CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 130) ;
        temporaryFrame = activityLabelName.frame ;
        [_avtivityBackView addSubview:activityLabel];
        [_avtivityBackView addSubview:activityLabelName];
        [_avtivityBackView addSubview:activityChoose];
        
        [_avtivityBackView addSubview:activityC];
    }
    //优惠券
    UILabel * copuLabel = [[UILabel alloc]init];
    
    copuLabel.tag = 600 ;
    
    copuLabel.frame = CGRectMake(20, CGRectGetMaxY(temporaryFrame) + 7.5, 15, 15);
    copuLabel.backgroundColor = [UIColor whiteColor];
    copuLabel.layer.borderWidth = 1;
    copuLabel.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    [_avtivityBackView addSubview:copuLabel];
    
    //优惠券
    UILabel * carCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(temporaryFrame), 80 , 30)];
    carCostLabel.text = @"使用优惠券";
    carCostLabel.numberOfLines = 2 ;
    carCostLabel.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_avtivityBackView addSubview:carCostLabel];
    
    
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( 0 , 29.5 , ScreenWidth , 0.5)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [carCostLabel addSubview:lineView3];
    
    
    UIButton * couponBt = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBt.frame = CGRectMake(120, carCostLabel.frame.origin.y, ScreenWidth - 120,carCostLabel.frame.size.height );
    [couponBt setTitle:@"请选择优惠券" forState:UIControlStateNormal] ;
    couponBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [couponBt setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
    
    //    [couponBt addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    couponBt.tag = 651 ;
    couponBt.hidden = YES ;
    [_avtivityBackView addSubview:couponBt];
    
    //    UIControl * couponC = [[UIControl alloc]initWithFrame:CGRectMake(carCostLabel.frame.origin.x, carCostLabel.frame.origin.y, ScreenWidth - 50,carCostLabel.frame.size.height )];
    //    [backView addSubview:couponC];
    //
    //    couponC.tag = 651 ;
    //
    //    [couponC addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];

    UIControl * copuC = [[UIControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(temporaryFrame), ScreenWidth, 30)];
    
    [copuC addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_avtivityBackView addSubview:copuC];
    
    copuC.tag = 661 ;
    
    if (![[self.priceDic objectForKey:@"activityShows"] isKindOfClass:[NSNull class]])
    {
        if ([self.index isEqualToString:@"0"]) {
            copuC.selected = NO ;
        }else{
            copuC.selected = YES ;
        }
        
        
    }
    else
    {
        copuC.selected = YES ;
        
    }
    
    
    //不适用优惠券
    UILabel * coupuLabel2 = [[UILabel alloc]init];
    coupuLabel2.tag = 601 ;
    
    coupuLabel2.frame = CGRectMake(20, CGRectGetMaxY(carCostLabel.frame) + 7.5, 15, 15);
    coupuLabel2.backgroundColor = [UIColor whiteColor];
    coupuLabel2.layer.borderWidth = 1;
    coupuLabel2.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    [_avtivityBackView addSubview:coupuLabel2];
    
    
    UIControl * coupuLabel2C = [[UIControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carCostLabel.frame), ScreenWidth, 30)];
    
    [coupuLabel2C addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_avtivityBackView addSubview:coupuLabel2C];
    
    coupuLabel2C.tag = 662 ;
    coupuLabel2C.selected = NO ;
    
    //优惠券
    UILabel * carCostLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(carCostLabel.frame), ScreenWidth / 3 , 30)];
    carCostLabel2.text = @"不使用优惠券";
    
    carCostLabel2.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel2.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_avtivityBackView addSubview:carCostLabel2];
    
    
    
    
    
    
    CGFloat H =  _orderScrollView.contentSize.height ;
    
    
    
    
    
    if (![[self.priceDic objectForKey:@"activityShows"] isKindOfClass:[NSNull class]]){
     
        _orderScrollView.contentSize = CGSizeMake(_orderScrollView.contentSize.width, H + 130);
        if ([self.index isEqualToString:@"0"]) {
            activityLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
            lastBt = activityC ;
            
        }else{
            coupuLabel2.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
            actBt = coupuLabel2C ;
            lastBt = coupuLabel2C ;
        }
    }
    else
    {
        coupuLabel2.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        _orderScrollView.contentSize = CGSizeMake(_orderScrollView.contentSize.width, H + 100);
        actBt = coupuLabel2C ;
        lastBt = coupuLabel2C ;
    }

    [self setCostViewWithFrame:_avtivityBackView.frame];
    
}

#pragma mark ---创建费用View
-(void)setCostViewWithFrame:(CGRect)frame{
    
    _priceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 360)];
    //    _priceView.backgroundColor = [UIColor greenColor];
    [_orderScrollView addSubview:_priceView] ;
    
    
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * toplineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 0 , ScreenWidth , 0.5)];
    toplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:toplineView];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [_priceView addSubview:mustCost];
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"费用明细";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    //车辆费用
    UILabel * carCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(mustCost.frame), ScreenWidth / 3 - 40 , 40)];
    carCostLabel.text = @"车辆租金";
    carCostLabel.numberOfLines = 2 ;
    carCostLabel.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_priceView addSubview:carCostLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(carCostLabel.frame)+10,CGRectGetMaxY(mustCost.frame) + 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_priceView addSubview:lineView1];
    
    
    //车辆费用
    UILabel * carCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+10 , carCostLabel.frame.origin.y, ScreenWidth / 3 +50, carCostLabel.frame.size.height)];
    
    carCost.font = [UIFont systemFontOfSize:11];
    
    [_priceView addSubview:carCost];
    
    
    NSString * averagePrice = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"averagePrice"]];
    NSString *  daySum = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"daySum"]];
    NSString *commissionStr = [NSString stringWithFormat:@"均价%@元/天,共%@天",averagePrice,daySum];
    
    carCost.text = commissionStr;
    
    
    //车辆总费用
    UILabel * carCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , carCostLabel.frame.origin.y, ScreenWidth / 3 - 20, carCostLabel.frame.size.height)];
    
    carCostTotal.textAlignment = 2;
    
    
    [_priceView addSubview:carCostTotal];
    
    NSString * totalAmount = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"totalAmount"]];
    
    NSMutableAttributedString *carCostTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalAmount]];
    
    
    [carCostTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalAmount.length + 2)];
    
    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [carCostTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalAmount.length + 1)];
    carCostTotal.attributedText = carCostTotalStr;
    
    
    //
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(carCostLabel.frame) , ScreenWidth , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_priceView addSubview:lineView2];
    
    
    //基本保险费
    UILabel * premiumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView2.frame), ScreenWidth / 3 - 40 , 40)];
    premiumLabel.text = @"基本保险金额";
    premiumLabel.numberOfLines = 2 ;
    premiumLabel.font = [ UIFont systemFontOfSize:12];
    premiumLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [_priceView addSubview:premiumLabel];
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(premiumLabel.frame)+10,premiumLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [_priceView addSubview:lineView3];
    
    
    //保险费用
    UILabel * premiumCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+10 , premiumLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];
    [_priceView addSubview:premiumCost];
    
    
    NSString * basicInsuranceAmount =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"basicInsuranceAmount"]];
    NSString*costPremiumStr = [NSString stringWithFormat:@"均价%@元/天,共%@天",basicInsuranceAmount,daySum];
    NSLog(@"%@",costPremiumStr);
    premiumCost.font = [UIFont systemFontOfSize:11];
    premiumCost.text = costPremiumStr;
    
    
    //保险总费用
    UILabel * premiumCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , premiumLabel.frame.origin.y, ScreenWidth / 3 - 20, premiumLabel.frame.size.height)];
    
    premiumCostTotal.textAlignment = 2;
    
    [_priceView addSubview:premiumCostTotal];
    
    NSString *  totalBasicInsuranceAmount =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"totalBasicInsuranceAmount"]];
    
    NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalBasicInsuranceAmount]];
    //
    
    [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalBasicInsuranceAmount.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalBasicInsuranceAmount.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    premiumCostTotal.attributedText = costPremiumTotalStr;
    
    
    //
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(premiumCostTotal.frame) , ScreenWidth , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_priceView addSubview:lineView4];
    
    
    CGRect temporaryFrame = lineView4.frame ;
    
    
    
    //超时费用
    UILabel * timeOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, CGRectGetMaxY(lineView4.frame), ScreenWidth / 3 - 40 , 40)];
    timeOutLabel.text = @"超时费";
    timeOutLabel.numberOfLines = 2 ;
    timeOutLabel.font = [ UIFont systemFontOfSize:12];
    timeOutLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    

    //
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(timeOutLabel.frame)+10,timeOutLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    

    //超时费用
    UILabel * timeOutCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+10 , timeOutLabel.frame.origin.y, ScreenWidth / 3 , carCostLabel.frame.size.height)];
    NSString * timeOutprice =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"delayAmount"]];
    NSString* timeOutpriceStr = [NSString stringWithFormat:@"均价%@元/小时",timeOutprice];
    NSLog(@"%@",costPremiumStr);
    timeOutCost.font = [UIFont systemFontOfSize:11];
    timeOutCost.text = timeOutpriceStr;
    

    //超时费用
    UILabel * timeOutpriceTotalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , timeOutCost.frame.origin.y, ScreenWidth / 3 - 20, premiumLabel.frame.size.height)];
    
    timeOutpriceTotalLabel.textAlignment = 2;
    NSString *  timeOutpriceTotal =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"totalDelayAmount"]];
    NSMutableAttributedString *timeOutpriceTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",timeOutpriceTotal]];
    //
    [timeOutpriceTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,timeOutpriceTotal.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [timeOutpriceTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [timeOutpriceTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, timeOutpriceTotal.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    timeOutpriceTotalLabel.attributedText = timeOutpriceTotalStr;
    
    
    UIView * lineView6 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(timeOutpriceTotalLabel.frame) , ScreenWidth , 0.5)];
    lineView6.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    
    if ([[_priceDic objectForKey:@"totalDelayAmount"] integerValue] > 0 ) {

        [_priceView addSubview:timeOutLabel];
        [_priceView addSubview:timeOutCost];
        [_priceView addSubview:lineView5];
        [_priceView addSubview:timeOutpriceTotalLabel];
        [_priceView addSubview:lineView6];
        temporaryFrame  = lineView6.frame ;
        
        CGSize newSize = _orderScrollView.contentSize ;
        newSize.height += 40 ;
        _orderScrollView.contentSize = newSize;
        

        
    }

    //增值服务费

    UIView * addbaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(temporaryFrame), ScreenWidth, 40 * _addValueArr.count )];
    [_priceView addSubview:addbaseView];
    
    if (_addValueArr.count>0) {
        CGRect newFrame = _priceView.frame ;
        newFrame.size.height += 40  *_addValueArr.count;
        _priceView.frame= newFrame;
        
        for (int i = 0 ; i < _addValueArr.count ; i ++)
        {
            //不计免赔服务
            UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(premiumLabel.frame.origin.x, i*40, ScreenWidth/3 -40 , 40)];
            commissionLabel.text = [_addValueArr[i]objectForKey:@"chargeName"];
            commissionLabel.font = [ UIFont systemFontOfSize:11];
            commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            [addbaseView addSubview:commissionLabel];
            
            //
            UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(commissionLabel.frame)+10 , 10 + i*40, 0.5 , 20)];
            lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            [addbaseView addSubview:lineView1];
            
            
            //不计免赔服务
            UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+10 , commissionLabel.frame.origin.y, ScreenWidth  - ScreenWidth / 3 + 10 -CGRectGetMaxX(lineView1.frame), commissionLabel.frame.size.height)];
            
            commission.font = [UIFont systemFontOfSize:10];
            commission.numberOfLines = 2 ;
            [addbaseView addSubview:commission];
            NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addValueArr[i] objectForKey:@"details"]]firstObject] ;
            NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
            NSInteger  price;
            //总费用
            UILabel * premiumCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
            
            premiumCostTotal.textAlignment = 2;
            
            
            [addbaseView addSubview:premiumCostTotal];
            
            
            if ([[_addValueArr[i]objectForKey:@"chargeName"]isEqualToString:@"不计免赔"])
            {
                
                //                if ([[_priceDic objectForKey:@"daySum"]integerValue]<=7)
                //                {
                //                    price = [commissionstr integerValue]* [[_priceDic objectForKey:@"daySum"]integerValue];
                //
                //                    commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天),共%@天",commissionstr,[_priceDic objectForKey:@"daySum"]];
                //                }
                //                else
                //
                //                {
                //                    price = [commissionstr integerValue]* 7;
                //                    commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天),共7天",commissionstr];
                
                //                }
                //
                price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天,每30天一周期),共%@天",commissionstr,[_priceDic objectForKey:@"daySum"]];
            }
            
            else
            {
                
                price = [commissionstr integerValue];
                commission.text = [NSString stringWithFormat:@"均价%@元/次,共1次",commissionstr];
            }
            
            
            NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %ld",price]];
            //
            [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,costPremiumTotalStr.length )];
            //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
            [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
            [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, costPremiumTotalStr.length -1)];
            //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
            premiumCostTotal.attributedText = costPremiumTotalStr;
            
            
            _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
            
            
            //保险费分割线
            UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(commission.frame) , ScreenWidth  , 0.5)];
            lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            [addbaseView addSubview:lineView2];
            
        }
        
    }
    else{
        CGSize newSize = _orderScrollView.contentSize ;
        newSize.height += 40 ;
        _orderScrollView.contentSize = newSize;
    }
    

    //不计免赔服务


    
    //手续费
    UILabel * otherCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(addbaseView.frame), ScreenWidth / 3 - 40 , 40)];
    otherCostLabel.text = @"手续费";
    otherCostLabel.numberOfLines = 2 ;
    otherCostLabel.font = [ UIFont systemFontOfSize:12];
    
    otherCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_priceView addSubview:otherCostLabel];
    
    //
    UIView * lineView7 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(otherCostLabel.frame)+10,otherCostLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView7.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_priceView addSubview:lineView7];
    
    
    
    //手续费
    UILabel * otherCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+10 , otherCostLabel.frame.origin.y, ScreenWidth / 3 - 20, otherCostLabel.frame.size.height)];
    
    [_priceView addSubview:otherCost];
    
    
    NSDictionary *commissionDic = [[NSArray arrayWithArray:[[_priceDic objectForKey:@"poundageAmount"]objectForKey:@"details"]]firstObject] ;
    
    NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
    
    otherCost.font =[UIFont systemFontOfSize:11];
    
    otherCost.text = [NSString stringWithFormat:@"%@元/次,共1次",commissionstr];
    
    
    //手续费用合计
    UILabel * otherCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , otherCostLabel.frame.origin.y, ScreenWidth / 3 - 20, otherCostLabel.frame.size.height)];
    
    otherCostTotal.textAlignment = 2;
    
    
    [_priceView addSubview:otherCostTotal];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",commissionstr]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,commissionstr.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, commissionstr.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    otherCostTotal.attributedText = str;
    
    
    UIView * lineView8 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(otherCostTotal.frame) , ScreenWidth , 0.5)];
    lineView8.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [_priceView addSubview:lineView8];
    
    
    
    
    //创建异地异店还车
    
    UIView * takeStatelineView = [[UIView alloc]init] ;
    
    takeStatelineView.frame = lineView8.frame ;
    [_priceView addSubview:takeStatelineView];
    
    
    UILabel * difCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth / 3 - 40 , 40)];
    
    difCostLabel.numberOfLines = 2 ;
    difCostLabel.font = [ UIFont systemFontOfSize:12];
    
    difCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //
    UIView * diflineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(otherCostLabel.frame)+10,difCostLabel.frame.origin.y + 10 , 0.5 , 20)];
    diflineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    
    
    
    //地异店还车费用
    UILabel * difCost = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+10 , difCostLabel.frame.origin.y, ScreenWidth / 3 - 20, difCostLabel.frame.size.height)];
    
    difCost.font =[UIFont systemFontOfSize:11];
    
    
    
    
    //手续费用合计
    UILabel * difCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , difCostLabel.frame.origin.y, ScreenWidth / 3 - 20, difCostLabel.frame.size.height)];
    
    difCostTotal.textAlignment = 2;
    
    
    NSMutableAttributedString * dicPricestr ;
    
    
    
    
    UIView * diflineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(difCostLabel.frame) , ScreenWidth , 0.5)];
    diflineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    
    if (![[self.priceDic objectForKey:@"doorToDoor"]isKindOfClass:[NSNull class]] && [self.priceDic objectForKey:@"doorToDoor"]  && [NSArray arrayWithArray:[self.priceDic objectForKey:@"doorToDoor"]].count > 0  ) {
        
        NSDictionary  * difprice = [[NSArray arrayWithArray:[self.priceDic objectForKey:@"doorToDoor"]]firstObject];
        
        takeStatelineView.frame = CGRectMake(takeStatelineView.frame.origin.x, takeStatelineView.frame.origin.y, ScreenWidth, 40) ;
        
        CGSize scroller =_orderScrollView.contentSize ;
        
        scroller.height += 40 ;
        
        
        CGRect newFrame = _priceView.frame ;
        newFrame.size.height += 40  ;
        _priceView.frame= newFrame;
        
        
        _orderScrollView.contentSize = scroller ;
        
        //费用名称
        difCostLabel.text = [difprice objectForKey:@"chargeName"];
        [takeStatelineView addSubview:difCostLabel];
        
        [takeStatelineView addSubview:diflineView];
        
        //费用说明
        [takeStatelineView addSubview:difCost];
        NSDictionary *difCostDic = [[NSArray arrayWithArray:[difprice objectForKey:@"details"]]firstObject] ;
        difCost.text =[NSString stringWithFormat:@"%@元/次,共1次",[difCostDic objectForKey:@"price"]];
        
        NSString * price = [NSString stringWithFormat:@"%@",[difCostDic objectForKey:@"price"]];
        
        //费用总计
        [takeStatelineView addSubview:difCostTotal];
        dicPricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",price]];
        [dicPricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,price.length + 2)];
        //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
        [dicPricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
        [dicPricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, price.length + 1)];
        //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
        difCostTotal.attributedText = dicPricestr;
        [takeStatelineView addSubview:diflineView2];
        
    }
    
    
    
    //优惠活动
    
    //    DBShowListModel * model = [[NSArray arrayWithArray:self.model.vendorStorePriceShowList]firstObject] ;
    
    
    //优惠价格
    UILabel * reduce = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 , ScreenWidth / 3 - 40 , 40)];
    reduce.text = @"优惠活动";
    reduce.font = [ UIFont systemFontOfSize:12];
    
    reduce.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    
    //竖线
    UIView * reducelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(reduce.frame)+10,reduce.frame.origin.y + 10 , 0.5 , 20)];
    reducelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    //横线
    UIView * reducelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(reduce.frame), ScreenWidth , 0.5)];
    reducelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    CGRect temporaryReduceFrame =  CGRectMake(0, 0, ScreenWidth , 0.5) ;
    
    //优惠说明
    reduceExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reducelineView.frame)+10 , reduce.frame.origin.y, ScreenWidth / 3 +10, reduce.frame.size.height)];
    reduceExplace.font = [ UIFont systemFontOfSize:11];
    reduceExplace.numberOfLines = 2;
    reduceExplace.adjustsFontSizeToFitWidth = YES ;
    reduceExplace.text = [self.activityDic objectForKey:@"activityDescription"];
    if (![[self.priceDic objectForKey:@"activityShows"] isKindOfClass:[NSNull class]]) {
        if ([NSString stringWithFormat:@"%@",[[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"activityDescription"]]) {
            reduceExplace.text = [NSString stringWithFormat:@"%@",[[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"activityDescription"]];
        }
    }
    //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //优惠价格
    reducePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 10  , reduce.frame.origin.y, ScreenWidth / 3 - 30, reduce.frame.size.height)];
    
    
    reducePrice.textAlignment = 2 ;
    
    NSString * reduceStr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"reduce"]] ;
    
    
    
    NSMutableAttributedString *reducePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",[NSString stringWithFormat:@"%@",reduceStr]]];
    
    [reducePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,reduceStr.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, reduceStr.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    reducePrice.attributedText = reducePricestr;
    reducePrice.adjustsFontSizeToFitWidth = YES ;
    
    
    
    
    //到店取车
    
    //    DBShowListModel * model = [[NSArray arrayWithArray:self.model.vendorStorePriceShowList]firstObject] ;
    
    
    //优惠价格
    UILabel * getCarStore = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 , ScreenWidth / 3 - 40 , 40)];
    
    
    getCarStore.text = @"到店取车";
    getCarStore.font = [ UIFont systemFontOfSize:12];
    
    getCarStore.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    

    
    
    if (![[self.priceDic objectForKey:@"activityShows"] isKindOfClass:[NSNull class]]){

            if ([self.index isEqualToString:@"0"]) {
            totleCostView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(takeStatelineView.frame), ScreenWidth  , 80)];
            [totleCostView addSubview:reduce];
            [totleCostView addSubview:reducelineView];
            [totleCostView addSubview:reducelastlineView];
            [totleCostView addSubview:reduceExplace];
            [totleCostView addSubview:reducePrice];
            activityId = [[[self.priceDic objectForKey:@"activityShows"]firstObject]objectForKey:@"id"];
            getCarStore.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
            
            temporaryReduceFrame.origin.y = CGRectGetMaxY(reduce.frame);
        }
        else {
            
            totleCostView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(takeStatelineView.frame), ScreenWidth  , 80)];
            
        }
        [_priceView addSubview:totleCostView];

        //    [self setSubmit:totleCostView.frame];
    }
    else{
        totleCostView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(takeStatelineView.frame), ScreenWidth  , 80)];
        [self.priceView addSubview:totleCostView];
        
        CGSize scroller =_orderScrollView.contentSize ;
        scroller.height += 40 ;
        _orderScrollView.contentSize = scroller ;
    }
    
    //竖线
    UIView * getCarStorelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(getCarStore.frame)+10,getCarStore.frame.origin.y + 10 , 0.5 , 20)];
    getCarStorelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    //横线
    UIView * getCarStorelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(getCarStore.frame), ScreenWidth , 0.5)];
    getCarStorelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    //优惠说明
    UILabel * getCarStoreExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(getCarStorelineView.frame)+10 , getCarStore.frame.origin.y, ScreenWidth / 3 +20, getCarStore.frame.size.height)];
    getCarStoreExplace.font = [ UIFont systemFontOfSize:11];
    getCarStoreExplace.adjustsFontSizeToFitWidth = YES ;
    
    
    //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    //优惠价格
    
    UILabel * getCarStorePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 10  , getCarStore.frame.origin.y, ScreenWidth / 3 - 30, getCarStore.frame.size.height)];
    
    
    getCarStorePrice.textAlignment = 2 ;
    
    NSString * getCarStoreStr;
    if (![[self.priceDic objectForKey:@"toStoreReduce"]isKindOfClass:[NSNull class]]) {
        getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
        
        getCarStoreStr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"toStoreReduce"]] ;
        
        NSMutableAttributedString *getCarStorePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",[NSString stringWithFormat:@"%@",getCarStoreStr]]];
        [getCarStorePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,getCarStoreStr.length + 2)];
        //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
        [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
        [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, getCarStoreStr.length + 1)];
        //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
        getCarStorePrice.attributedText = getCarStorePricestr;
        getCarStorePrice.adjustsFontSizeToFitWidth = YES ;
        
        
        if (![[self.priceDic objectForKey:@"toStoreReduce"]isKindOfClass:[NSNull class]]) {
            
            getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
            
            [totleCostView addSubview:getCarStore];
            [totleCostView addSubview:getCarStorelineView];
            [totleCostView addSubview:getCarStorelastlineView];
            [totleCostView addSubview:getCarStoreExplace];
            [totleCostView addSubview:getCarStorePrice];
            
            totleCostView.frame =CGRectMake(0, CGRectGetMaxY(takeStatelineView.frame), ScreenWidth  , 120);
            CGSize scroller =_orderScrollView.contentSize ;
            scroller.height += 80 ;
            _orderScrollView.contentSize = scroller ;
            temporaryReduceFrame.origin.y = CGRectGetMaxY(getCarStore.frame);
        }
    }
    else {
        CGSize scroller =_orderScrollView.contentSize ;
        scroller.height += 80 ;
        _orderScrollView.contentSize = scroller ;
    }
    
    
    
    
    
    UILabel * totleCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(temporaryReduceFrame), ScreenWidth / 3 - 40 , 40)];
    totleCostLabel.text = @"订单总额";
    totleCostLabel.numberOfLines = 2 ;
    totleCostLabel.font = [ UIFont systemFontOfSize:12];
    
    totleCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [totleCostView addSubview:totleCostLabel];
    
    
    
    //
    UIView * lineView9 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(totleCostLabel.frame)+10,totleCostLabel.frame.origin.y + 10 , 0.5 , 20)];
    lineView9.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [totleCostView addSubview:lineView9];
    
    
    //费用合计
    totleCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , totleCostLabel.frame.origin.y, ScreenWidth / 3 - 20, otherCostLabel.frame.size.height)];
    
    totleCost.textAlignment = 2;
    
    
    [totleCostView addSubview:totleCost];
    
    
    NSString * totalstr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"totalPrice"]];
    
    NSString * totalPrice;
    totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
    
    
    if (![[self.priceDic objectForKey:@"activityShows"] isKindOfClass:[NSNull class]]){
        
        if ([[NSString stringWithFormat:@"%@",self.activityDic[@"isSdew"]]isEqualToString:@"1"]) {
            if ([self.index isEqualToString:@"0"]) {
                totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue]] ;
            }
            else{
                totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
            }
            
        }
        else{
            totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
        }
    }
    
    
    
    
    if ([totalstr floatValue] + [_addValuePrice floatValue] < 0) {
        totalPrice = @"0" ;
    }
    _totalePrice = totalPrice ;
    
    NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
    
    [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalPrice.length + 2)];
    
    
    
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
    [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length+ 1)];
    
    totleCost.attributedText = totleCostStr;
    
    
    
    
    
    
    //
    UIView * lastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(totleCost.frame) , ScreenWidth , 0.5)];
    lastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    
    [totleCostView addSubview:lastlineView];
    
    
    
    //确认订单
    
    
    
    
    baseView = [[UIView alloc]initWithFrame:CGRectMake(0, _priceView.frame.size.height - 80, ScreenWidth,80)];
    
    
    [_priceView addSubview:baseView];
    
    
    NSString * agreement = @"我已阅读并同意";
    NSString * agreement1 =@"《赶脚短租自驾预定条款》";
    
    NSString * agreestr = @"我已阅读并同意《赶脚短租自驾预定条款》";
    
    CGSize strSize = [DBcommonUtils calculateStringLenth:agreestr withWidth:ScreenWidth withFontSize:11];
    NSLog(@"协议的宽度%f",strSize.width);
    CGSize size = [DBcommonUtils calculateStringLenth:agreement withWidth:ScreenWidth withFontSize:11];
    NSLog(@"协议的宽度%f",size.width);
    
    
    
    UIView * View = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth  - strSize.width )/2 ,10 , strSize.height, strSize.height)];
    View.layer.borderWidth = 0.5 ;
    View.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    View.backgroundColor = [UIColor clearColor];
    [baseView addSubview:View];
    
    
    
    UILabel * agreementLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(View.frame)+5, View.frame.origin.y -0.5, size.width, size.height)];
    agreementLabel.text = agreement;
    agreementLabel.textColor = [DBcommonUtils getColor:@"9e9e9f"] ;
    agreementLabel.font = [UIFont systemFontOfSize:11];
    [baseView addSubview:agreementLabel];
    
    UILabel * agreementLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(agreementLabel.frame), agreementLabel.frame.origin.y , ScreenWidth - CGRectGetMaxX(agreementLabel.frame), size.height)];
    agreementLabel1.text = agreement1;
    agreementLabel1.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    agreementLabel1.font = [UIFont systemFontOfSize:11];
    [baseView addSubview:agreementLabel1];
    
    
    
    //是否阅读条款点击事件
    UIControl * agreementC = [[UIControl alloc]initWithFrame:CGRectMake(View.frame.origin.x - 10, View.frame.origin.y - 10, View.frame.origin.x +20, View.frame.size.width + 20)];
    [agreementC addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:agreementC];
    
    View.tag = 553 ;
    agreementC.tag = 552;
    
    
    //查看条款点击事件
    UIControl * agreementRead = [[UIControl alloc]initWithFrame:CGRectMake(agreementLabel1.frame.origin.x, View.frame.origin.y-5, agreementLabel1.frame.origin.x - 20, View.frame.size.width+10)];
    
    [agreementRead addTarget:self action:@selector(agreementClick) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:agreementRead];
    
    
    
    
    //创建提交按钮
    //显示更多车辆按钮
    showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(50, CGRectGetMaxY(View.frame)+20 , ScreenWidth - 100  , 30 );
    [showCarBt setTitle:@"确认订单" forState:UIControlStateNormal];
    
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    showCarBt.selected = YES ;
    
    //    [showCarBt addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
    [showCarBt addTarget:self action:@selector(sumbitBt:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:showCarBt];
    
    
    NSLog(@"%f",CGRectGetMaxY(frame));
    
    if ([self.index isEqualToString:@"2"]) {
        [self loadPrice];
    }
    
    
}

-(void)changeColor:(UIButton*)button{
    
    button.backgroundColor = [UIColor grayColor];
    
}


#pragma merk 点击事件


//重新计算价格
-(void)configView:(NSNumber*)button
{

    _addValuePrice = nil;
    
    UIButton * activityBt = [self.view viewWithTag:652];
    
    NSInteger index = [button integerValue];
    CGRect temporaryReduceFrame =  CGRectMake(0, 0, ScreenWidth , 0.5) ;
    

    if (!isSame) {
        [totleCostView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIButton * explainBt = [self.view viewWithTag:651];
        if(index == 662)
        {
            //没有选优惠券和活动
            activityId = nil ;
            
            couponId = nil ;
            
            [explainBt setTitle:@"请选择优惠券" forState:UIControlStateNormal];
            
            [activityBt setTitle:@"请选择优惠活动" forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect frame = totleCostView.frame ;
                frame.size.height = 80 ;
                totleCostView.frame = frame ;

                if ([self.index isEqualToString:@"0"]){
                    
                    if(!self.isChoose){
                        CGRect frame = totleCostView.frame ;
                        frame.size.height = 120 ;
                        totleCostView.frame = frame ;
                    }
                }
            } completion:^(BOOL finished) {
                
            }];
        }
        else if (index == 661 && showDic == nil){
            
            //没有选优惠券和活动
            
            activityId = nil ;
            
            couponId = nil ;
            
            [explainBt setTitle:@"请选择优惠券" forState:UIControlStateNormal];
            
            [activityBt setTitle:@"请选择优惠活动" forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = totleCostView.frame ;
                frame.size.height = 40 ;
                totleCostView.frame = frame ;

                if ([self.index isEqualToString:@"0"]){
                    
                    if(!self.isChoose){
                        CGRect frame = totleCostView.frame ;
                        frame.size.height = 80 ;
                        totleCostView.frame = frame ;
                    }
                }
            } completion:^(BOOL finished) {
                
            }];
        }
        else if (index == 660 || index == 661){
          
            [UIView animateWithDuration:0.5 animations:^{
                if ([self.index isEqualToString:@"0"]) {
                    if (_isChoose) {
                        CGRect frame = totleCostView.frame ;
                        frame.size.height = 80 ;
                        totleCostView.frame = frame ;
                    }
                    else{
                        CGRect frame = totleCostView.frame ;
                        frame.size.height = 120 ;
                        totleCostView.frame = frame ;
                    }
                }
            } completion:^(BOOL finished) {
                
            }];
            

            //增值服务费
            UIView * addbaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , 40)];
            if ([self.index isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",self.activityDic[@"isSdew"]]isEqualToString:@"1"]){
                
                if(!self.isChoose){
                    
                    CGRect newFrame = totleCostView.frame ;
                    newFrame.size.height += 40 ;
                    totleCostView.frame= newFrame;
                    
                    baseView.frame = CGRectMake(0,CGRectGetMaxY(totleCostView.frame), ScreenWidth,80);
                                      //不计免赔服务
                    UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth/3 -40 , 40)];
                    commissionLabel.text = [_addvalue objectForKey:@"chargeName"];
                    commissionLabel.font = [ UIFont systemFontOfSize:11];
                    commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
                    [addbaseView addSubview:commissionLabel];
                    
                    //
                    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(commissionLabel.frame)+10 , 10 , 0.5 , 20)];
                    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                    [addbaseView addSubview:lineView1];
                    
                    //不计免赔服务
                    UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame)+10 , commissionLabel.frame.origin.y, ScreenWidth  - ScreenWidth / 3 + 10 -CGRectGetMaxX(lineView1.frame), commissionLabel.frame.size.height)];
                    
                    commission.font = [UIFont systemFontOfSize:10];
                    commission.numberOfLines = 2 ;
                    [addbaseView addSubview:commission];
                    NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
                    NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                    NSInteger  price;
                    //总费用
                    UILabel * premiumCostTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
                    
                    premiumCostTotal.textAlignment = 2;
                    
                    
                    [addbaseView addSubview:premiumCostTotal];
                    

                    price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                    commission.text = [NSString stringWithFormat:@"均价%@元/天(上限7天,每30天一周期),共%@天",commissionstr,[_priceDic objectForKey:@"daySum"]];

                    NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %ld",price]];
                    //
                    [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,costPremiumTotalStr.length )];
                    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
                    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, costPremiumTotalStr.length -1)];
                    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
                    premiumCostTotal.attributedText = costPremiumTotalStr;
                    
                    
                    _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
                    
                    
                    //保险费分割线
                    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(commission.frame) , ScreenWidth  , 0.5)];
                    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                    [addbaseView addSubview:lineView2];
                    
                    [totleCostView addSubview:addbaseView];

                    temporaryReduceFrame =  CGRectMake(0, 40, ScreenWidth , 0.5) ;
                }
            }
            
            
            //优惠价格
            UILabel * reduce = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 , ScreenWidth / 3 - 40 , 40)];

            if ([self.index isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",self.activityDic[@"isSdew"]]isEqualToString:@"1"]){
                
                if(!self.isChoose){
                     reduce.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
                }

            }
            reduce.font = [ UIFont systemFontOfSize:12];
            reduce.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            //竖线
            UIView * reducelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(reduce.frame)+10,reduce.frame.origin.y + 10 , 0.5 , 20)];
            reducelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            
            //横线
            UIView * reducelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(reduce.frame), ScreenWidth , 0.5)];
            reducelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            
            //优惠说明
            reduceExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reducelineView.frame)+10 , reduce.frame.origin.y, ScreenWidth / 3 +40, reduce.frame.size.height)];
            
            reduceExplace.font = [ UIFont systemFontOfSize:11];
            reduceExplace.numberOfLines = 2;
            reduceExplace.adjustsFontSizeToFitWidth = YES ;
            
            //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            [totleCostView addSubview:reduceExplace];

            //手续费用合计
            reducePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , reduce.frame.origin.y, ScreenWidth / 3 - 20, reduce.frame.size.height)];
            
            
            reducePrice.textAlignment = 2 ;
            
            NSString * reduceStr ;
            
            
            temporaryReduceFrame =  CGRectMake(0, CGRectGetMaxY(reduce.frame), ScreenWidth , 0.5) ;
            

            if (index == 661) {
                reduce.text = @"优惠券";
                
                [explainBt setTitle:[showDic objectForKey:@"title"] forState:UIControlStateNormal];
                
                NSLog(@"%@",explainBt.titleLabel.text);
                reduceExplace.text =[NSString stringWithFormat:@"%@",[showDic objectForKey:@"title"]] ;
                
                reduceStr = [NSString stringWithFormat:@"%@",[showDic objectForKey:@"amount"]] ;
                
                //选择优惠券
                couponId  = [showDic objectForKey:@"id"];
                activityId = nil ;
            }
            else if (index == 660)
            {
                
                reduce.text = @"优惠活动";
                
                if (![[self.priceDic objectForKey:@"activityShows"]isKindOfClass:[NSNull class]]) {
                    
                    reduceExplace.text = [NSString stringWithFormat:@"%@",[[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"activityDescription"]];
                    NSLog(@"%@",reduceExplace.text);
                    [activityBt setTitle:[[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"activityDescription"] forState:UIControlStateNormal];
                    reduceStr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"reduce"]] ;
                    
                    activityId = [[[self.priceDic objectForKey:@"activityShows"]firstObject] objectForKey:@"id"];
                    couponId = nil ;
                }
            }
            
            
            NSMutableAttributedString *reducePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ -%@",reduceStr]];
            [reducePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,reduceStr.length + 3)];
            //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
            [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
            [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, reduceStr.length + 2)];
            //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
            reducePrice.attributedText = reducePricestr;
            

            [totleCostView addSubview:reduce];
            [totleCostView addSubview:reducelineView];
            [totleCostView addSubview:reducelastlineView];
            
            [totleCostView addSubview:reducePrice];
                
            temporaryReduceFrame =  CGRectMake(0, CGRectGetMaxY(reduce.frame), ScreenWidth , 0.5) ;

            }
       
        //优惠价格
        UILabel * getCarStore = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(temporaryReduceFrame) , ScreenWidth / 3 - 40 , 40)];
        
        getCarStore.text = @"到店取车";
        getCarStore.font = [ UIFont systemFontOfSize:12];
        
        getCarStore.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        
        if (![[self.priceDic objectForKey:@"toStoreReduce"] isKindOfClass:[NSNull class]])
        {
//            if ((index == 661 && showDic != nil)){
//                getCarStore.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
//            }
//            else if (index == 660 && self.activityDic != nil){
//                getCarStore.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
//            }
            
            //竖线
            UIView * getCarStorelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(getCarStore.frame)+10,getCarStore.frame.origin.y + 10 , 0.5 , 20)];
            getCarStorelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            //横线
            UIView * getCarStorelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(getCarStore.frame), ScreenWidth , 0.5)];
            getCarStorelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            //优惠说明
            UILabel * getCarStoreExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(getCarStorelineView.frame)+10 , getCarStore.frame.origin.y, ScreenWidth / 3 +20, getCarStore.frame.size.height)];
            getCarStoreExplace.font = [ UIFont systemFontOfSize:11];
            getCarStoreExplace.adjustsFontSizeToFitWidth = YES ;
            
            
            //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            //优惠价格
            
            UILabel * getCarStorePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 10  , getCarStore.frame.origin.y, ScreenWidth / 3 - 30, getCarStore.frame.size.height)];
            
            getCarStorePrice.textAlignment = 2 ;
            
            NSString * getCarStoreStr;
            
            getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
            
            getCarStoreStr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"toStoreReduce"]] ;
            
            NSMutableAttributedString *getCarStorePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",[NSString stringWithFormat:@"%@",getCarStoreStr]]];
            
            [getCarStorePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,getCarStoreStr.length + 2)];
            //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
            [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
            [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, getCarStoreStr.length + 1)];
            //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
            getCarStorePrice.attributedText = getCarStorePricestr;
            getCarStorePrice.adjustsFontSizeToFitWidth = YES ;
            
            getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
            
            [totleCostView addSubview:getCarStore];
            [totleCostView addSubview:getCarStorelineView];
            [totleCostView addSubview:getCarStorelastlineView];
            [totleCostView addSubview:getCarStoreExplace];
            [totleCostView addSubview:getCarStorePrice];
            
            temporaryReduceFrame.origin.y = CGRectGetMaxY(getCarStore.frame);
            
        }
        
        
        
        
        [_priceView addSubview:totleCostView];
        
        

        UILabel * totleCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,temporaryReduceFrame.origin.y , ScreenWidth / 3 - 40 , 40)];
        totleCostLabel.text = @"订单总额";
        totleCostLabel.numberOfLines = 2 ;
        totleCostLabel.font = [ UIFont systemFontOfSize:12];
        
        totleCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        
        [totleCostView addSubview:totleCostLabel];
        

        //
        UIView * lineView9 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(totleCostLabel.frame)+10,totleCostLabel.frame.origin.y + 10 , 0.5 , 20)];
        lineView9.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        
        [totleCostView addSubview:lineView9];
        
        
        
        
        //费用合计
        totleCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , totleCostLabel.frame.origin.y, ScreenWidth / 3 - 20, totleCostLabel.frame.size.height)];
        totleCost.textAlignment = 2;
    
        [totleCostView addSubview:totleCost];
        
        
        NSString * totalstr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"totalPrice"]];
        
        NSString * totalPrice;
        totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
        
        
        if (index== 660){
            if ([[NSString stringWithFormat:@"%@",self.activityDic[@"isSdew"]]isEqualToString:@"1"]) {
                totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue]] ;
            }
            else{
                
                NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
                NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                NSInteger  price;
                price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
                
                if (_isChoose) {
                    totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
                }
                else{
                    totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue]] ;
                }
            }
        }
        
        
        if (index== 661){
            totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] - [[NSString stringWithFormat:@"%@",[self getShowDicRental:totalPrice]]floatValue]] ;
            
            NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
            NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
            NSInteger  price;
            
            price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
            _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
            
            
            if (_isChoose) {
                
                totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue] - [[self getShowDicRental:totalstr] floatValue]];
            }
            else{
                totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] - [[self getShowDicRental:totalstr]floatValue]];

            }
        }
        
        if (index== 662){

            NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
            NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
            NSInteger  price;

            price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
            _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];

            
            if (_isChoose) {
                
                totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
            }
            else{
                totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue]];
            }
        }
        
       
        if ([totalPrice floatValue] < 0) {
            totalPrice = @"0" ;
        }
        
        _totalePrice = totalPrice ;
        
        NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
        
        [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalPrice.length + 2)];
        
        
        
        [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
        [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length+ 1)];
        
        totleCost.attributedText = totleCostStr;
        
        //
        UIView * lastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(totleCost.frame) , ScreenWidth , 0.5)];
        lastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        
        [totleCostView addSubview:lastlineView];
        
        //确认订单
        
        showDic = nil ;
    }
    else{
        
        if (showDic)
        {
            {
                //            [self changeActivityView:index];

                [totleCostView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    CGRect frame = totleCostView.frame ;
                    frame.size.height = 80 ;
                    totleCostView.frame = frame ;
                    
                    
                } completion:^(BOOL rnished) {
                    
                }];}
            //          优惠价格
            UILabel * reduce = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 , ScreenWidth / 3 - 40 , 40)];
            
            reduce.font = [ UIFont systemFontOfSize:12];
            
            reduce.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            
            //竖线
            UIView * reducelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(reduce.frame)+10,reduce.frame.origin.y + 10 , 0.5 , 20)];
            reducelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            
            //横线
            UIView * reducelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(reduce.frame), ScreenWidth , 0.5)];
            reducelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            
            //优惠说明
            reduceExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reducelineView.frame)+10 , reduce.frame.origin.y, ScreenWidth / 3 +40, reduce.frame.size.height)];
            
            reduceExplace.font = [ UIFont systemFontOfSize:11];
            reduceExplace.numberOfLines = 2;
            //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            [totleCostView addSubview:reduceExplace];
            
            
            
            //手续费用合计
            reducePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , reduce.frame.origin.y, ScreenWidth / 3 - 20, reduce.frame.size.height)];
            
            
            reducePrice.textAlignment = 2 ;
            
            NSString * reduceStr ;
            
            
            temporaryReduceFrame =  CGRectMake(0, 40, ScreenWidth , 0.5) ;
            
            UIButton * explainBt = [self.view viewWithTag:651];
            
            if (index == 661)
            {
                reduce.text = @"优惠券";
                
                [explainBt setTitle:[showDic objectForKey:@"title"] forState:UIControlStateNormal];
                
                NSLog(@"%@",explainBt.titleLabel.text);
                reduceExplace.text =[NSString stringWithFormat:@"%@",[showDic objectForKey:@"title"]] ;
                
                reduceStr = [NSString stringWithFormat:@"%@",[showDic objectForKey:@"amount"]] ;
                
                //选择优惠券
                couponId  = [showDic objectForKey:@"id"];
                activityId = nil ;
   
            }
            else{
                
            }
            
            
            NSMutableAttributedString *reducePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ -%@",reduceStr]];
            
            [reducePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,reduceStr.length + 3)];
            //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
            [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
            [reducePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, reduceStr.length + 2)];
            //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
            reducePrice.attributedText = reducePricestr;
            
            [totleCostView addSubview:reduce];
            [totleCostView addSubview:reducelineView];
            [totleCostView addSubview:reducelastlineView];

            [totleCostView addSubview:reducePrice];

            //优惠价格
            UILabel * getCarStore = [[UILabel alloc]initWithFrame:CGRectMake(20, 0 , ScreenWidth / 3 - 40 , 40)];
            
            getCarStore.text = @"到店取车";
            getCarStore.font = [ UIFont systemFontOfSize:12];
            
            getCarStore.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            if (![[self.priceDic objectForKey:@"toStoreReduce"] isKindOfClass:[NSNull class]])
            {
                if ((index == 661 && showDic != nil)){
                    getCarStore.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
                }
                else if (index == 660 && self.activityDic != nil){
                    getCarStore.frame = CGRectMake(20, 40 , ScreenWidth / 3 - 40 , 40);
                }
                
                //竖线
                UIView * getCarStorelineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(getCarStore.frame)+10,getCarStore.frame.origin.y + 10 , 0.5 , 20)];
                getCarStorelineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                
                //横线
                UIView * getCarStorelastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(getCarStore.frame), ScreenWidth , 0.5)];
                getCarStorelastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                
                //优惠说明
                UILabel * getCarStoreExplace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(getCarStorelineView.frame)+10 , getCarStore.frame.origin.y, ScreenWidth / 3 +20, getCarStore.frame.size.height)];
                getCarStoreExplace.font = [ UIFont systemFontOfSize:11];
                getCarStoreExplace.adjustsFontSizeToFitWidth = YES ;
                
                
                //    reduceExplace.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
                
                //优惠价格
                
                UILabel * getCarStorePrice= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 + 10  , getCarStore.frame.origin.y, ScreenWidth / 3 - 30, getCarStore.frame.size.height)];
                
                getCarStorePrice.textAlignment = 2 ;
                
                NSString * getCarStoreStr;
                
                getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
                
                getCarStoreStr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"toStoreReduce"]] ;
                
                NSMutableAttributedString *getCarStorePricestr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥-%@",[NSString stringWithFormat:@"%@",getCarStoreStr]]];
                
                [getCarStorePricestr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,getCarStoreStr.length + 2)];
                //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
                [getCarStorePricestr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, getCarStoreStr.length + 1)];
                //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
                getCarStorePrice.attributedText = getCarStorePricestr;
                getCarStorePrice.adjustsFontSizeToFitWidth = YES ;
                
                getCarStoreExplace.text = [NSString stringWithFormat:@"优惠%@",[self.priceDic objectForKey:@"toStoreReduce"]];
                
                [totleCostView addSubview:getCarStore];
                [totleCostView addSubview:getCarStorelineView];
                [totleCostView addSubview:getCarStorelastlineView];
                [totleCostView addSubview:getCarStoreExplace];
                [totleCostView addSubview:getCarStorePrice];
                
                temporaryReduceFrame.origin.y = CGRectGetMaxY(getCarStore.frame);
                
            }

            [_priceView addSubview:totleCostView];
            
            UILabel * totleCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,temporaryReduceFrame.origin.y , ScreenWidth / 3 - 40 , 40)];
            totleCostLabel.text = @"订单总额";
            totleCostLabel.numberOfLines = 2 ;
            totleCostLabel.font = [ UIFont systemFontOfSize:12];
            
            totleCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
            
            [totleCostView addSubview:totleCostLabel];
            
            
            
            //
            UIView * lineView9 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(totleCostLabel.frame)+10,totleCostLabel.frame.origin.y + 10 , 0.5 , 20)];
            lineView9.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            [totleCostView addSubview:lineView9];
            
            
            //费用合计
            totleCost = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , totleCostLabel.frame.origin.y, ScreenWidth / 3 - 20, totleCostLabel.frame.size.height)];
            totleCost.textAlignment = 2;
            
            [totleCostView addSubview:totleCost];
            
            
            NSString * totalstr = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"totalPrice"]];
            
            NSString * totalPrice;
            totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
            
            
            if (index== 660){
                if ([[NSString stringWithFormat:@"%@",self.activityDic[@"isSdew"]]isEqualToString:@"1"]) {
                    totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue]] ;
                }
                else{
                    
                    NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
                    NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                    NSInteger  price;
                    price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                    _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
                    
                    if (_isChoose) {
                        totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
                    }
                    else{
                        totalPrice = [NSString stringWithFormat:@"%g",[totalstr floatValue]] ;
                    }
                }
            }
            
            
            if (index== 661){
                
                
                totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] - [[NSString stringWithFormat:@"%@",[self getShowDicRental:totalPrice]]floatValue]] ;
                
                NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
                NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                NSInteger  price;
                
                price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
                
                if (_isChoose) {
                    totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue] - [[self getShowDicRental:totalstr]floatValue]];
                }else{
                   totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] - [[self getShowDicRental:totalstr]floatValue]];
                }
            }
            
            if (index== 662){
                
                NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addvalue objectForKey:@"details"]]firstObject] ;
                NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                NSInteger  price;
                
                price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                _addValuePrice = [NSString stringWithFormat:@"%ld",[_addValuePrice integerValue] + price];
                
                
                if (_isChoose) {
                    
                    totalPrice =[NSString stringWithFormat:@"%g",[totalstr floatValue] + [_addValuePrice floatValue]];
                }
            }
            
            
            if ([totalPrice floatValue] < 0) {
                totalPrice = @"0" ;
            }

            _totalePrice = totalPrice ;
            
            NSMutableAttributedString *totleCostStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalPrice]];
            
            [totleCostStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalPrice.length + 2)];
            
            
            
            [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( 0 , 1)];
            [totleCostStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange( 1 , totalPrice.length+ 1)];
            
            totleCost.attributedText = totleCostStr;
            
            //
            UIView * lastlineView = [[UIView alloc]initWithFrame:CGRectMake( 0 ,CGRectGetMaxY(totleCost.frame) , ScreenWidth , 0.5)];
            lastlineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
            
            [totleCostView addSubview:lastlineView];            //确认订单
            
            showDic = nil ;
            //    [self setSubmit:totleCostView.frame];
        }
        
    }
}

//判断优惠券金额
-(NSString*)getShowDicRental:(NSString*)totalPrice{
    NSString * price;
    if (![showDic[@"genre"]isKindOfClass:[NSNull class]]) {
        if ([showDic[@"genre"]isEqualToString:@"subRental"]) {
            if ([[showDic objectForKey:@"amount"]floatValue] > [[self.priceDic objectForKey:@"totalAmount"]integerValue]) {
                price = [self.priceDic objectForKey:@"totalAmount"];
            }
            else{
                price = [showDic objectForKey:@"amount"];
            }
        }
        else if ([showDic[@"genre"]isEqualToString:@"subTotal"]){
            if (totalPrice == nil) {
                return nil;
            }
            if ([[showDic objectForKey:@"amount"]floatValue] > [totalPrice integerValue]) {
                price = totalPrice;
            }
            else{
                price = [showDic objectForKey:@"amount"];
            }
        }
    }
    else{
        price = [showDic objectForKey:@"amount"];
    }
    return price;
}

-(void)changeActivityView:(NSInteger)index{
    
    
    
    [_avtivityBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    _avtivityBackView.frame = CGRectMake(0, _avtivityBackView.frame.origin.y, ScreenWidth, 100);
    
    
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [_avtivityBackView addSubview:mustCost];
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"选择优惠";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];
    
    
    //优惠券
    UILabel * copuLabel = [[UILabel alloc]init];
    
    copuLabel.tag = 600 ;
    
    copuLabel.frame = CGRectMake(20,CGRectGetMaxY(mustCost.frame)+ 7.5, 15, 15);
    
    
    
    copuLabel.backgroundColor = [UIColor whiteColor];
    copuLabel.layer.borderWidth = 1;
    copuLabel.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    [_avtivityBackView addSubview:copuLabel];
    
    
    
    //优惠券
    UILabel * carCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,CGRectGetMaxY(mustCost.frame), 80 , 30)];
    carCostLabel.text = @"使用优惠券";
    carCostLabel.numberOfLines = 2 ;
    carCostLabel.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_avtivityBackView addSubview:carCostLabel];
    
    
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( 0 , 29.5 , ScreenWidth , 0.5)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [carCostLabel addSubview:lineView3];
    
    
    UIButton * couponBt = [UIButton buttonWithType:UIButtonTypeCustom];
    couponBt.frame = CGRectMake(120, carCostLabel.frame.origin.y, ScreenWidth - 120,carCostLabel.frame.size.height );
    [couponBt setTitle:@"请选择优惠券" forState:UIControlStateNormal] ;
    couponBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [couponBt setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
    //    couponBt.hidden = YES;
    //    [couponBt addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    couponBt.tag = 651 ;
    
    [_avtivityBackView addSubview:couponBt];
    
    //    UIControl * couponC = [[UIControl alloc]initWithFrame:CGRectMake(carCostLabel.frame.origin.x, carCostLabel.frame.origin.y, ScreenWidth - 50,carCostLabel.frame.size.height )];
    //    [backView addSubview:couponC];
    //
    //    couponC.tag = 651 ;
    //
    //    [couponC addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIControl * copuC = [[UIControl alloc]initWithFrame:CGRectMake(0,carCostLabel.frame.origin.y, ScreenWidth, 30)];
    
    [copuC addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_avtivityBackView addSubview:copuC];
    copuC.tag = 661 ;
    
    
    //不适用优惠券
    UILabel * coupuLabel2 = [[UILabel alloc]init];
    coupuLabel2.tag = 601 ;
    
    coupuLabel2.frame = CGRectMake(20, CGRectGetMaxY(carCostLabel.frame) + 7.5, 15, 15);
    coupuLabel2.backgroundColor = [UIColor whiteColor];
    coupuLabel2.layer.borderWidth = 1;
    coupuLabel2.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
    [_avtivityBackView addSubview:coupuLabel2];
    
    
    UIControl * coupuLabel2C = [[UIControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carCostLabel.frame), ScreenWidth, 30)];
    
    [coupuLabel2C addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_avtivityBackView addSubview:coupuLabel2C];
    
    coupuLabel2C.tag = 662 ;
    
    
    //优惠券
    UILabel * carCostLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(carCostLabel.frame), ScreenWidth / 3 , 30)];
    carCostLabel2.text = @"不使用优惠券";
    
    carCostLabel2.font = [ UIFont systemFontOfSize:12];
    
    carCostLabel2.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [_avtivityBackView addSubview:carCostLabel2];
    
    
    
    if (index == 661 )
    {
        copuLabel.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        coupuLabel2.backgroundColor = [UIColor whiteColor];
        
        [couponBt setTitle:[showDic objectForKey:@"title"] forState:UIControlStateNormal];
        lastBt = copuC ;
        
        copuC.selected = YES ;
        coupuLabel2C.selected = NO ;
    }
    else if (index == 662)
    {
        coupuLabel2.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        copuLabel.backgroundColor = [UIColor whiteColor];
        lastBt = coupuLabel2C;
        copuC.selected = NO ;
        coupuLabel2C.selected = YES ;
    }
    
}
#pragma mark ---优惠活动描述点击创建弹窗


-(void)saleCarClick:(UIControl*)button{
    
    //制空 ,选择活动在赋值
    //     [self changeActivityView];
    [self.tipView removeFromSuperview];
    
    UILabel * activityLabel = [self.view viewWithTag:599];
    UILabel * couponLabel = [self.view viewWithTag:600];
    UILabel * couponLabel2 = [self.view viewWithTag:601];

    UIControl * activityC = [self.view viewWithTag:660];
    UIControl * couponC = [self.view viewWithTag:661];
    UIControl * couponC2 = [self.view viewWithTag:662];
    
    UIButton * coupon = [self.view viewWithTag:651];
    coupon.hidden = NO ;
    UIButton * activity = [self.view viewWithTag:652];
    
    //优惠券
    if (button.tag == 661) {
        self.index = @"1";
        if (button != lastBt){
            couponLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] ;
            activityLabel.backgroundColor = [UIColor whiteColor];
            couponLabel2.backgroundColor = [UIColor whiteColor];
            lastBt = button ;
            activityC.selected = NO ;
            couponC2.selected = NO ;
            button.selected = YES ;
            isSame = NO ;
            [self loadStorePrice:661];
        }
        else{
            isSame = YES ;
            //            添加弹窗
            if (couponArray.count > 0)
            {
                showArray  = couponArray ;
                [self addView];
            }
            else{
                [self tipShow:@"没有可用的优惠券"];
            }
        }
        //              //添加弹窗
        //        if (couponArray.count > 0)
        //        {
        //            showArray  = couponArray ;
        //            [self addView];
        //
        //        }
        //        else
        //        {
        //            [self loadStorePrice:661];
        //        }
    }
    else{
        coupon.hidden = YES;
    }
    //优惠活动
    if (button.tag == 660) {
        self.index = @"0";
        if (button != lastBt){
            activity.hidden = NO ;
            couponLabel.backgroundColor =[UIColor whiteColor];
            activityLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] ;
            couponLabel2.backgroundColor = [UIColor whiteColor];
            lastBt = button ;
            button.selected = YES ;
            couponC2.selected = NO ;
            couponC.selected = NO ;
            isSame = NO ;
        }
        else{
            isSame = YES ;
        }
        
        // [self loadUserInfo];
        if (self.activityDic) {
            [self loadStorePrice:660];
       
        }
        
        //
        //
        //        DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
        //
        //
        //        NSArray   * activityArray =model.activityShows;
        //
        //        if (activityArray.count > 0 )
        //        {
        //            showArray = activityArray ;
        //            //添加弹窗
        //            [self addView];
        //        }
        //        else
        //        {
        //            NSLog(@"没有数据");
        //        }
        
    }
    else {
        activity.hidden = YES ;
    }
    
    if (button.tag == 662){

        self.index = @"2";
        if (button != lastBt)
        {
            couponLabel.backgroundColor =[UIColor whiteColor];
            activityLabel.backgroundColor =[UIColor whiteColor];
            
            
            couponLabel2.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] ;
            
            lastBt = button ;
            
            
            button.selected = YES ;
            //            activityC.selected = NO ;
            couponC.selected = NO ;
            
            isSame = NO ;
        }
        else{
            isSame = YES ;
        }
        
        [self loadStorePrice:662];
        
    }
    if ([self.delegate respondsToSelector:@selector(activitChange:)]) {
        [self.delegate activitChange:self.index];
    }
}

//优惠活动需要重新加载价格
-(void)loadNewPrice
{
    
    
    
}


//添加弹窗
-(void)addView
{
    saleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , ScreenHeight)];
    
    saleView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:saleView];
    
    
    //灰色背景
    
    UIView * grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    grayBackView.backgroundColor = [UIColor grayColor];
    grayBackView.alpha = 0.5 ;
    [saleView addSubview:grayBackView];
    
    
    // 白色背景
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(30, 150, ScreenWidth - 60, 250)];
    baseView.layer.cornerRadius = 5 ;
    baseView.layer.masksToBounds = YES ;
    baseView.backgroundColor = [UIColor whiteColor];
    [saleView addSubview:baseView];
    
    
    //活动背景
    UIView * remainBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, baseView.frame.size.width, 30)];
    remainBack.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [baseView addSubview:remainBack];
    
    
    //热门活动
    UILabel * remainLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.5 * remainBack.frame.size.width - 15, remainBack.frame.size.height)];
    remainLable.text =@"选择优惠券" ;
    remainLable.font = [UIFont systemFontOfSize:12];
    [remainBack addSubview:remainLable];
    
    
    
    saleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, baseView.frame.size.width, 190)style:UITableViewStylePlain];
    [baseView addSubview:saleTableView];
    
    saleTableView.showsVerticalScrollIndicator = NO ;
    saleTableView.showsHorizontalScrollIndicator = NO ;
    saleTableView.dataSource = self ;
    saleTableView.delegate = self ;
    saleTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    
    //确定按钮
    UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBt.frame = CGRectMake(0 , 220 , baseView.frame.size.width, 30);
    submitBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
    [submitBt setTitle:@"确定" forState:UIControlStateNormal];
    submitBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBt addTarget:self action:@selector(submitBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:submitBt];
    
    
}



//弹窗移除
-(void)submitBtClick:(UIButton*)button
{
    
    //    UIControl * activityC = [self.view viewWithTag:660];
    
    UIControl * couponC = [self.view viewWithTag:661];
    
    // //优惠活动
    //    if (activityC.selected == YES)
    //    {
    //
    //        if (showDic == nil)
    //        {
    //
    //            [self loadStorePrice:662];
    //        }
    //        else
    //        {
    //            [self loadStorePrice:660];
    //        }
    //
    //    }
    
    //优惠券
    if (couponC.selected == YES)
    {
        
        [self configView:@661];
        
    }
    
    [saleView removeFromSuperview];
    saleView  = nil ;
    
}


-(void)loadOtherActivityPrice
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *activitybtId  = [showDic objectForKey:@"id"];
    
    
    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
    
    
    
    NSString *  url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=%@&modelId=%@&storeId=%@&userId=%@",Host,activitybtId,_model.vehicleModelShow.id,model.id,[user objectForKey:@"userId"]];
    
    NSMutableDictionary * pardic = [NSMutableDictionary dictionary];
    
    pardic[@"endDate"]= [ user objectForKey:@"returnTime"];
    pardic[@"startDate"]= [ user objectForKey:@"takeTime"];
    pardic[@"takeCityId"] =[ user objectForKey:@"takeCityId"];
    pardic[@"returnCityId"] =[ user objectForKey:@"returnCityId"];
    pardic[@"returnStoreId"] =[[user objectForKey:@"returnStore"]objectForKey:@"id"];
    
    
    
    NSLog(@"%@",[ user objectForKey:@"returnTime"]);
    NSLog(@"%@",[ user objectForKey:@"takeTime"]);
    
    
    [self addProgress];
    
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {
        
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _priceDic = [responseObject objectForKey:@"message"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
    }];
}


#pragma mark 预定条款点击
-(void)agreementClick
{
    UIView * baseView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.tag = 554;
    [self.view addSubview:baseView];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-70)];
    [baseView addSubview:webView];
    
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index2" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBt.frame = CGRectMake(ScreenWidth / 2 - 80  , ScreenHeight - 40, 160  , 30 );
    [submitBt setTitle:@"确定" forState:UIControlStateNormal];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    submitBt.layer.cornerRadius = 5;
    submitBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [submitBt addTarget:self action:@selector(removeWebView) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:submitBt];
  

    
    
}

-(void)removeWebView
{
    UIView * web = [self.view viewWithTag:554];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat alpha = web.alpha ;
        alpha = 0 ;
        web.alpha = alpha;
        
    } completion:^(BOOL finished) {
        
        [web removeFromSuperview];
        
    }];
    
    
}
#pragma mark ---门店地图点击事件
-(void)mapClick:(UIControl*)control
{
    
    UIView * agreement = [self.view viewWithTag:553];
    
    if (control.tag == 550)
    {
        
    }
    else if (control.tag == 552)
    {
        
        if ([agreement.backgroundColor isEqual:[UIColor clearColor]])
        {
            
            agreement.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        }
        else
        {
            agreement.backgroundColor = [UIColor clearColor];
        }
        
    }
}


#pragma mark  提交订单

#pragma mark  ---提交订单按钮点击
-(void)sumbitBt:(UIButton*)button
{
    //    button.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    
    
    
    if ( button.selected == NO) {
        
        return ;
    }
    
    
    [self.tipView removeFromSuperview];
    
    UIView * agreement = [self.view viewWithTag:553];
    
    
    if ([agreement.backgroundColor isEqual:[UIColor clearColor]])
        
    {
        [self tipShow:@"请先阅读短租自驾条款"];
    }
    else if ([userInfoDic objectForKey:@"credentialNumber"]==nil || [[userInfoDic objectForKey:@"credentialNumber"]isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"credentialNumber"]isEqualToString:@""]  || [userInfoDic objectForKey:@"realName"]==nil || [[userInfoDic objectForKey:@"realName"]isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"realName"]isEqualToString:@""])
    {
        
        [self sumbitUserInfo:button];
    }
    
    else
    {
        [self sumbitOrder:button];
        
    }
    
}

#pragma mark  ---提交身份信息
-(void)sumbitUserInfo:(UIButton*)button
{
    NSString * url =[NSString stringWithFormat:@"%@/api/me",Host];
    //    NSString * url = @"http://www.rental.hpecar.com/api/me";
    
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![pred evaluateWithObject: nameFiled.field.text])
    {
        [self tipShow:@"请输入有效中文名"];
        
        return;
    }
    
    else if (![self validateIdentityCard])
    {
        [self tipShow:@"请输入有效证件号"];
        
        return ;
    }
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    
    [dic setValue:[NSString stringWithFormat:@"%@",cardNumberFiled.field.text] forKey:@"credentialNumber"];
    
    [dic setValue:[NSString stringWithFormat:@"%@",nameFiled.field.text] forKey:@"realName"];
    
    DBNetworkTool *net = [[DBNetworkTool alloc]init];
    
    [net changePwdPUT:url parameters:dic];
    
    net.changePwBlock = ^(NSDictionary *dic)
    {
        
        if ([[dic objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            nameFiled.field.enabled = NO;
            cardNumberFiled.field.enabled = NO;
            
            
            [userInfoDic setValue:[NSString stringWithFormat:@"%@",cardNumberFiled.field.text] forKey:@"credentialNumber"];
            
            [userInfoDic setValue:[NSString stringWithFormat:@"%@",nameFiled.field.text] forKey:@"realName"];
            
            
            [self sumbitOrder:button];
            
        }
        else
        {
            [UIView animateWithDuration:2 animations:^{
                
                [self tipShow:@"数据错误"];
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
    };
    
}

//判断证件是否有效
//身份证号
-(BOOL)validateIdentityCard
{
    
    
    //    BOOL flag;
    //    if(nameFiled.field.text.length != 18){
    //        flag =NO;
    //        return flag;
    //    }
    //    (^\d{15}$)|(^\d{17}([0-9]|X)$)
    NSString * regex1=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSString * regex2=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
    
    
    
    NSPredicate *regextestmobile1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *regextestmobile2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    if (cardNumberFiled.field.text.length == 15) {
        
        return [regextestmobile1 evaluateWithObject:cardNumberFiled.field.text];
        
    }
    else if (cardNumberFiled.field.text.length == 18){
        return [regextestmobile2 evaluateWithObject:cardNumberFiled.field.text];
    }
    else{
        return NO ;
    }
    
    
}

#pragma mark  ---提交订单信息
-(void)sumbitOrder:(UIButton*)button
{
    [self.tipView removeFromSuperview];
    
    
    
    
    __weak typeof(self) weak_self = self ;
    [DBNetworkTool judgeIsBlacGET:nil parameters:nil success:^(id responseObject) {
        DBLog(@"11111111%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {
            
            if ([responseObject objectForKey:@"message"]) {
                
                [weak_self tipShow:@"服务繁忙"];
            }
            
        }
        else{
            
            [weak_self judgeIsblack:(UIButton*)button];
        }
        
        
    } failure:^(NSError *error) {
        
        [weak_self tipShow:@"数据加载失败"];
        
    }];
}



-(void)judgeIsblack:(UIButton*)button{
    
    
    button.selected =NO ;
    
    [self.tipView removeFromSuperview];
    
    NSLog(@"订单提交");
    
    NSString * url;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:@"takeState"]isEqualToString:@"1"])
    {
        url = [NSString stringWithFormat:@"%@/api/user/%@/order",Host,[user objectForKey:@"userId"]];
        
    }
    
    else
    {
        url = [NSString stringWithFormat:@"%@/api/door/user/order",Host];
        //        url = [NSString stringWithFormat:@"%@/api/user/%@/doortodoororder",Host,[user objectForKey:@"userId"]];
    }
    
    
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    NSLog(@"%@",self.priceDic);
    
    NSLog(@"以下是订单参数*************************************************");
    
    parDic = [DBOrderData createOrderInfoWithPriceDic:self.priceDic CarDic:self.model Price:_totalePrice PayWay:self.payWay WithAddValueArr:_addValueArr];
    
    
    //优惠券
    if (couponId)
    {
        parDic[@"couponNumber"] = couponId ;
    }
    else if (activityId)
    {
        parDic[@"activityId"] = activityId;
        
        parDic[@"reduce"] = [self.priceDic objectForKey:@"reduce"];
    }
    else{
        parDic[@"couponNumber"] = @"" ;
        parDic[@"activityId"] = @"0";
    }
    
    NSLog(@"%@",parDic);
    NSLog(@"以上是订单参数*************************************************");
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    __weak typeof(self)weak_self = self ;
    [DBNetworkTool addOrderPost:url parameters:parDic success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            DBOrderPayViewController * order = [[DBOrderPayViewController alloc]init];
            order.payWay = weak_self.payWay ;
            order.priceDic = weak_self.priceDic ;
            order.model = weak_self.model ;
            order.totalCost = weak_self.totalePrice;
            
            order.orderNumber =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]];
            
            [UIView animateWithDuration:2 animations:^{
                
                [weak_self tipShow:@"下单成功"];
                
            } completion:^(BOOL finished) {
                
                [weak_self.navigationController pushViewController:order animated:YES];
                
            }];
            
        }
        else
        {
            [weak_self tipShow:[responseObject objectForKey:@"message"]];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        button.selected = YES ;
        
        
    } failure:^(NSError *error)
     
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         button.selected = YES ;
         NSLog(@"%@",error);
         [weak_self tipShow:@"数据加载失败"];
         [self removeProgress];
         
     }];
    
    
}


#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return showArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (showArray == couponArray)
    {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"couponCell"];
        }
        
        //    cell.textLabel.text = [couponArray[indexPath.row]objectForKey:@"activityDescription"] ;
        
        
        cell.textLabel.text = [showArray[indexPath.section]objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        
        
        cell.detailTextLabel.text =[NSString stringWithFormat:@"￥ -%@",[showArray[indexPath.section]objectForKey:@"amount"]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] ;
        
        return cell ;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    
    //    cell.textLabel.text = [couponArray[indexPath.row]objectForKey:@"activityDescription"] ;
    
    cell.textLabel.text = [showArray[indexPath.section]objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    
    return cell ;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    actBt = lastBt ;
    
    showDic = showArray[indexPath.section];
    
    
}


- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
}

-(void)backBt
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    [[BaiduMobStat defaultStat]pageviewStartWithName:@"短租自驾费用明细"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"短租自驾费用明细"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
