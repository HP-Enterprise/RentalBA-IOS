//
//  DBCarListViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/26.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCarListViewController.h"



#import "DBCarListTableViewCell.h"

//订单服务选择
#import "DBOrderServeViewController.h"

//日历控件
#import "DBCollectionViewCell.h"
//日历 头尾  头文件
#import "HeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"


#import "DBSignInViewController.h"
#import "DBOrderServeViewController.h"


#import "DBCarModel.h"
@interface DBCarListViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    //已经展开的价格日历
    NSMutableArray * showPriceArray;
    
    //单个月的价格日历
    NSArray * priceArray ;
    
    
    //记录上次点击的按钮
    UIButton *  indexBt;
    
    //记录上一次点击的月份

    NSString *  lastMonth ;
    
    //记录上一次车型
    DBCarModel * lastModel ;
    
    //价格日历天数
    NSMutableArray * priceDaysArray ;
    
    //活动页面
    UIView * saleView ;
    
    //选择的活动
    NSDictionary * chooseDic ;

    //选择第几个活动
    NSInteger ActivityIndex ;
    
    //选择第几个车型
    NSInteger ActivityCar ;
    
    UILabel * lastlabel ;
    UILabel * lastname ;
    
    NSMutableDictionary * activityDics;
}


//日历控件
@property (nonatomic,strong)UICollectionView * collcetionView;

//创建车辆列表
@property (nonatomic,strong)UITableView * carListTableView;

//日历控件天数
@property (nonatomic,strong)NSMutableArray * daysArray;

//车辆信息数组
@property (nonatomic,strong)NSMutableArray * carsArray;

//记录展开的列表
@property (nonatomic,strong)NSMutableArray * lastArray;

//记录选择多个活动数组
@property (nonatomic,strong)NSMutableArray * activityArray;

//展开页面价格信息
@property (nonatomic,strong)UIView * priceView ;

@property (nonatomic,strong)NSMutableArray * dataArray ;

//优惠活动数据
@property (nonatomic,strong)NSArray * saleArray;

//错误提示
@property (nonatomic,strong)UIView * tipView;

@property (nonatomic,strong)DBProgressAnimation * progress ;

@end

@implementation DBCarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    //创建导航栏
    [self setNavgationView];

    //创建日历模块
//    [self creatCollectionView];
    
    //创建车辆列表
    [self setCarList];
    
    
    //监测网络状态
    [self checkNet];
    
    [self setData];
    
    
    [self loadDate];
    
    

}


-(void)setData
{
    showPriceArray = [NSMutableArray array];
    
    chooseDic = [NSDictionary dictionary];
    chooseDic = nil ;
    
    activityDics = [NSMutableDictionary dictionary];
    
    _activityArray = [NSMutableArray array];
}


//网络监测
-(void)checkNet
{
    DBNetManager * manager = [DBNetManager sharedManager];
    NSLog(@"网络状态为%d",manager.netStatu);
    if (manager.netStatu == 0 )
    {
        [self tipShow:@"请检查网络设置"];
    }
    

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


#pragma mark 加载价格日历
-(void)loadPrice:(UIButton * )button

{

    NSInteger index = button.tag -300 ;
    
    priceArray = [NSArray array];
   
    indexBt = button;

    NSUserDefaults  * user = [NSUserDefaults standardUserDefaults];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/rentalPack/prices",Host];

    DBCarModel * model =  _carsArray[index];
    
    lastModel = model ;
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    NSString * startDate = [[user objectForKey:@"takeCarDate"] stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:@"01"];
    
    NSInteger month = [[startDate substringWithRange:NSMakeRange(5, 2)]integerValue]+1;
    
    NSString * endDate = [startDate stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld",month]];
     lastMonth = startDate ;
    
    parDic[@"startDate"] = startDate ;

    parDic[@"endDate"] = endDate;
    
    parDic[@"modelId"] = model.vehicleModelShow.id ;
    
    parDic[@"storeId"] =[self.takeStoreInfoDic objectForKey:@"id"];
    
    [self addProgress];
    [DBNetworkTool Get:url parameters:parDic success:^(id responseObject) {
        
        [self removeProgress];
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"])
        {

            priceArray = [NSArray arrayWithArray:[responseObject objectForKey:@"message"]] ;
          
            [self loadPriceClick:button];
            
            [user setObject:parDic forKey:@"carSection"];
            
        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        
    }];
    
}




#pragma mark 加载数据
//加载数据
-(void)loadDate
{
    
    [self addProgress];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    _dataArray = [NSMutableArray array];
    _lastArray = [NSMutableArray array];
    _carsArray = [NSMutableArray array];

    NSString * url = [NSString stringWithFormat:@"%@/api/searchVehicleRentalPack?orderType=priceLow&pageSize=100&brandId=&carGroup=&currentPage=1&userId=%@",Host,[user objectForKey:@"userId"]];
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];


//    parDic[@"startDate"] =[user objectForKey:@"takeTime"];
//    parDic[@"endDate"] = [user objectForKey:@"returnTime"];
//    parDic[@"takeCarCityId"] = [self.takeCityInfoDic objectForKey:@"id"];

    parDic[@"startDate"] =[user objectForKey:@"takeTime"];
    parDic[@"endDate"] = [user objectForKey:@"returnTime"];
    parDic[@"applicationSide"] = @"5";
    parDic[@"takeCarCityId"] = [self.takeCityInfoDic objectForKey:@"id"];

    //门到门选车
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        parDic[@"latitude"] = [self.takePlaceInfoDic objectForKey:@"latitude"];
        parDic[@"longitude"] = [self.takePlaceInfoDic objectForKey:@"longitude"];
        parDic[@"takeCarStoreId"] = @"-1";
    }
    //门店选车
    else
    {
        parDic[@"latitude"] =[self.takeStoreInfoDic objectForKey:@"latitude"];
        parDic[@"longitude"] =[self.takeStoreInfoDic objectForKey:@"longitude"];
//        parDic[@"takeCarStoreId"] =@"7";
        
        parDic[@"takeCarStoreId"] =[self.takeStoreInfoDic objectForKey:@"id"];
        
        parDic[@"returnCarCityId"] =[self.returnCityInfoDic objectForKey:@"id"];
        parDic[@"returnCarStoreId"] =[self.returnStoreInfoDic objectForKey:@"id"];
        
        NSLog(@"%@",parDic[@"takeCarStoreId"]);
        
    }
    
    NSLog(@"%@",self.takeCityInfoDic);
    NSLog(@"%@",[self.takeCityInfoDic objectForKey:@"id"]);
    NSLog(@"%@",parDic[@"latitude"]);
    NSLog(@"%@",parDic[@"longitude"]);

//    __weak typeof(self)weak_self = self;

    [DBNetworkTool Get:url parameters:parDic success:^(id responseObject) {
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
           if ([responseObject objectForKey:@"message"] == nil || [[responseObject objectForKey:@"message"]isKindOfClass:[NSNull class]] || [[responseObject objectForKey:@"message"]isKindOfClass:[NSArray class]])
            {
                
                [self tipShow:@"没有相关数据"];
                
                return ;
            }
        
            NSArray * array = [NSArray arrayWithArray:[[responseObject objectForKey:@"message"]objectForKey:@"content"]];
            
            if (array.count> 0)
            {
                for (NSDictionary * dic in array)
                {
              
                    DBCarModel * model = [[DBCarModel alloc]initWithDictionary:dic error:nil];

                    [_carsArray addObject:model];
                    
                    [showPriceArray addObject:@[]];
                    [_dataArray addObject:@[]];
                    
                    DBShowListModel * activityModel = [model.vendorStorePriceShowList firstObject] ;
                    
                    if (!activityModel.activityShows) {
                        [_activityArray addObject:@"-1"];
                    }
                    else{
                        [_activityArray addObject:@"0"];

                    }
                    

                }
            }
        }
        
        
        if (_carsArray.count > 0)
        {

            [_carListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self tipShow:@"没有相关数据"];
        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        
        NSLog(@"%@",error);
    
    }];

}


#pragma mark 界面创建

#pragma mark --创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"车辆列表" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];
    
    
}

#pragma mark --初始化车辆列表

-(void)setCarList
{
    _carListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    
    _carListTableView.showsVerticalScrollIndicator = NO ;
    _carListTableView.showsHorizontalScrollIndicator = NO ;
    _carListTableView.delegate = self ;
    _carListTableView.dataSource = self ;
    _carListTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
//    
//    
//    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//    [_carListTableView  selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    
//    
    [self.view addSubview:_carListTableView];
    
}


#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _carListTableView)
    {
        return [NSArray arrayWithArray:_dataArray[section]].count;

    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _carListTableView)
    {
         return ScreenWidth * 8 / 7 - 20 ;
        
    }
    return 30;

   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _carListTableView)
    {
       return _dataArray.count ;
        
    }
    
    return _saleArray.count;;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _carListTableView)
    {
        return 111;
        
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    UILabel * label = [self.view viewWithTag:(999 + ActivityIndex)];
    UILabel * Namelabel = [self.view viewWithTag:(1999 + ActivityIndex)];
    UIImageView *imagev = [self.view viewWithTag:(2999 + ActivityIndex)];
    
    if (tableView != _carListTableView)
    {

        chooseDic = _saleArray[indexPath.section];

    
        label.text  = [[chooseDic objectForKey:@"activityTypeShow"]objectForKey:@"hostTypeDascribe"];
        Namelabel.text  =[NSString stringWithFormat:@"%@",[chooseDic objectForKey:@"name"]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[chooseDic objectForKey:@"name"]]);
        
        
        CGSize size = [DBcommonUtils calculateStringLenth:Namelabel.text withWidth:ScreenWidth withFontSize:10];
        imagev.frame = CGRectMake( size.width + 4, 6, 7 , 4 );


        if (ActivityIndex != -1){
            [_activityArray replaceObjectAtIndex:ActivityIndex-1 withObject:[NSString stringWithFormat:@"%ld",indexPath.section]];
        }

        
    }
    

}

#pragma mark ---创建列表头部视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (tableView == _carListTableView)
    {
        DBCarModel * carModel = _carsArray[section];
        DBShowListModel * model = [[NSArray arrayWithArray:carModel.vendorStorePriceShowList]firstObject] ;

        NSLog(@"%ld",section);
        
        
        //创建背景
        UIView * baseView = [[UIView alloc]init];
        baseView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *backView  =[[UIView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth, 10)];
        
        backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1] ;
        [baseView addSubview:backView ];
        
        
        //分割线
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(backView.frame) , ScreenWidth , 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [baseView addSubview:lineView];
        
        UIImageView * carImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+20, 80, 50)];
        
        NSString* encodedString;
        
        encodedString = [[NSString stringWithFormat:@"%@%@",Host,[carModel.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
//        if ([[carModel.vehicleModelShow.picture substringWithRange:NSMakeRange(0, 2)]isEqualToString:@".."]) {
//            encodedString = [[NSString stringWithFormat:@"%@%@",Host,[carModel.vehicleModelShow.picture stringByReplacingOccurrencesOfString:@".." withString:@""]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        }
//        else{
//            encodedString = [NSString stringWithFormat:@"%@%@",Host,carModel.vehicleModelShow.picture];
//
//        }
//        NSLog(@"%@",encodedString);
        
        
        [carImage sd_setImageWithURL:[NSURL URLWithString:
                                      encodedString] placeholderImage:[UIImage imageNamed:@"img-05.jpg"]];
        
        [baseView addSubview:carImage];
        
        
        //创建车辆基本信息
        UILabel * carName = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(backView.frame)+10, ScreenWidth/2, 15)];
        //    carName.text = @"中华 H330";
        carName.text =carModel.vehicleModelShow.model;
        carName.font = [UIFont systemFontOfSize:11];
        [baseView addSubview:carName];
        
        
        NSString * carGroup ;
        if (carModel.vehicleModelShow.carGroup == nil)
        {
            carGroup = @"";
        }
        else{
            switch ([carModel.vehicleModelShow.carGroup integerValue])
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
            
        }
        
        
        
        NSString * carTurnk;
        

        if ([carModel.vehicleModelShow.carTrunk integerValue] == 1 )
        {
            carTurnk = @"3厢";
        }
        else if ([carModel.vehicleModelShow.carTrunk integerValue] == 2)
        {
            carTurnk = @"2厢";
        }
        else{
            carTurnk = @"" ;
        }
        
        
        
        NSString * seat ;
        
        if (carModel.vehicleModelShow.seats == nil)
        {
            seat = @"";
            
        }
        else{
            seat =[NSString stringWithFormat:@"%@座",carModel.vehicleModelShow.seats] ;
        }
        
        
        
        //创建车辆基本信息
        UILabel * carInfo = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carName.frame), 100, 15)];
        carInfo.text = [NSString stringWithFormat:@"%@ | %@ | %@",carGroup,carTurnk,seat];
        carInfo.font = [UIFont systemFontOfSize:10];
        [baseView addSubview:carInfo];
        
        
        //next
        UIImageView * nextImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -  40 , carInfo.frame.origin.y , 6 , 11 )];
        
        [baseView addSubview:nextImage];
        
        nextImage.image = [UIImage imageNamed:@"next"];
        
        
        
       
        
        //优惠活动
        
        UIImageView * saleCarView  = [[UIImageView alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carInfo.frame)+5, 35, 16)];
        saleCarView.image = [UIImage imageNamed:@"saleImage"];
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(carInfo.frame)+5, 35, 16)];

        label.tag = 1000 + section ;
        
        
        
        label.textAlignment = 1 ;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        
        //    //特价车型
        UILabel * saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(saleCarView.frame)+5, saleCarView.frame.origin.y ,ScreenWidth - CGRectGetMaxY(saleCarView.frame), 16)];
        saleLabel.textColor = [UIColor blackColor];
        saleLabel.font = [UIFont systemFontOfSize:10];
        saleLabel.tag = 2000 + section;
        
        //点击事件
        UIControl * saleCar = [[UIControl alloc]initWithFrame:CGRectMake(saleCarView.frame.origin.x, saleCarView.frame.origin.y, saleCarView.frame.size.width+saleLabel.frame.size.width, saleCarView.frame.size.height)];
        [saleCar addTarget:self action:@selector(saleCarClick:) forControlEvents:UIControlEventTouchUpInside];
        saleCar.tag = 500 + section ;
        
        
        
        

        
        
        if ([_activityArray[section] isEqualToString:@"0"]) {
            label.text = [[model.activityShow objectForKey:@"activityTypeShow"]objectForKey:@"hostTypeDascribe"];
             saleLabel.text = [model.activityShow objectForKey:@"name"];
        }
        else if ([_activityArray[section] isEqualToString:@"-1"]){
            
        }
        else{
            
            NSDictionary * dic =  model.activityShows[[_activityArray[section]integerValue]];
            
            NSLog(@"id   %@",[[dic objectForKey:@"activityTypeShow"]objectForKey:@"hostTypeDascribe"]);
            NSString * kind = [[dic objectForKey:@"activityTypeShow"]objectForKey:@"hostTypeDascribe"] ;
            
            NSString * dasdribe = [dic objectForKey:@"name"];
            
            label.text = kind ;
            saleLabel.text = dasdribe ;
        }
        
       CGSize size = [DBcommonUtils calculateStringLenth:saleLabel.text withWidth:ScreenWidth withFontSize:10];
        
        //后边下拉图标
        UIImageView * returnMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake( size.width + 4, 6, 7 , 4 )];
        returnMoreImage.image = [UIImage imageNamed:@"more-image"];
        returnMoreImage.tag = 3000 + section;
        
        if (![model.activityShow isKindOfClass:[NSNull class]] && model.activityShow != nil)
        {

            [baseView addSubview:saleCarView];
            
            [baseView addSubview:label];
           
            
            [baseView addSubview:saleLabel];
            
            [baseView addSubview:saleCar];
            
            if (model.activityShows.count > 1) {
                [saleLabel addSubview:returnMoreImage];
            }
            
        }

        
        
        //分割线
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( carName.frame.origin.x , CGRectGetMaxY(carInfo.frame)+25 , ScreenWidth - carName.frame.origin.x, 0.5)];
        lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [baseView addSubview:lineView1];
        

        //车辆价格
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(carName.frame.origin.x, CGRectGetMaxY(lineView1.frame), ScreenWidth - carName.frame.origin.x -20, 30)];

        NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@/日均",model.avgAmount]];
        //
        [price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(2,model.avgAmount.length)];
        //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
        //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 5+model.avgAmount.length)];
        [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(2, model.avgAmount.length)];
        //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
        priceLabel.attributedText = price;
        
        [baseView addSubview:priceLabel];
        
        
        

        //分割线
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(priceLabel.frame)+5 , ScreenWidth , 0.5)];
        lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [baseView addSubview:lineView2];
        
        NSLog(@"%f",CGRectGetMaxY(lineView2.frame));
        
 
        
        //创建日历按钮
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(ScreenWidth - 70, CGRectGetMaxY(lineView1.frame),50, 30);
        [button setTitle:@"每日租金" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.selected = NO ;
        
        button.tag = 300 + section ;
        
        
        [button addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [baseView addSubview:button];
        
        
        
        for (int i = 0 ; i < _lastArray.count ; i ++)
        {
            NSString * str = _lastArray[i];
            if ([str integerValue] == section)
            {
                NSLog(@"复用后不相等");
                
                NSLog(@"复用后数字%ld",[str integerValue]);
                //            [temBtn setImage:[UIImage imageNamed:@"tableBt-1"] forState:UIControlStateNormal];
                
                button.selected = YES ;
                //            listLabel.text = @"收起列表";
                break;
            }
            
            else
            {
                NSLog(@"复用后相等");
                //            [temBtn setImage:[UIImage imageNamed:@"tableBt"] forState:UIControlStateNormal];
                
                button.selected = NO ;
                //            listLabel.text = @"查看全部";
            }
            
        }
        
        
        //创建选择车辆点击事件
        UIControl * chooseCar = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(carInfo.frame))];
        [chooseCar addTarget:self action:@selector(chooseCar:) forControlEvents:UIControlEventTouchUpInside];
        chooseCar.tag = 400 + section;
        
        
        [baseView addSubview:chooseCar];
        
        
        return baseView;
        
    }

    return nil;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView== _carListTableView)
    {
        DBCarListTableViewCell * cell =[[DBCarListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carCell"];
        
        
        
        //     DBCarListTableViewCell * cell [tableView dequeueReusableCellWithIdentifier:@"carCell"];
        //    if (cell==nil)
        //    {
        //
        //        cell = [[DBCarListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carCell"];
        //    }
        
        cell.selectionStyle = 0 ;
        
        
        
        [cell config:showPriceArray[indexPath.section] withPriceDaysArray:priceDaysArray];
        
        return cell ;
    }
    

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCell"];
    }
    
    cell.textLabel.text = [_saleArray[indexPath.section]objectForKey:@"name"] ;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    
  
//    cell.selectionStyle = 0 ;
    return cell ;
}




#pragma mark 点击事件


#pragma mark ---活动按钮点击

-(void)saleCarClick:(UIControl*)button
{
    
    
    [self loadSaleArray:button];
    
    
    
    if (_saleArray.count > 0)
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
        remainLable.text =@"热门活动" ;
        remainLable.font = [UIFont systemFontOfSize:12];
        [remainBack addSubview:remainLable];
        

        UITableView * saleTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, baseView.frame.size.width, 190)style:UITableViewStylePlain];
        [baseView addSubview:saleTableView];
        
        saleTableView.showsVerticalScrollIndicator = NO ;
        saleTableView.showsHorizontalScrollIndicator = NO ;
        saleTableView.dataSource = self ;
        saleTableView.delegate = self ;
        saleTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        
        UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBt.frame = CGRectMake(0 , 220 , baseView.frame.size.width, 30);
        submitBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        
        [submitBt setTitle:@"确定" forState:UIControlStateNormal];
        submitBt.titleLabel.font = [UIFont systemFontOfSize:12];
        [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBt addTarget:self action:@selector(submitBtClick) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:submitBt];
   
    }
    
    
    chooseDic = nil;
    ActivityIndex = button.tag - 499 ;


    
}

-(void)loadSaleArray:(UIControl*)button
{
    _saleArray = [NSArray array];
    
    DBCarModel * carModel = _carsArray[button.tag - 500];

    DBShowListModel * model = [[NSArray arrayWithArray:carModel.vendorStorePriceShowList]firstObject] ;
    
    if (model.activityShows!= nil)
    {
        _saleArray  = model.activityShows ;

    }
    else
    {
        [self.tipView removeFromSuperview];
        [self tipShow:@"没有更多活动"];
    }

    
    
}

-(void)submitBtClick

{
    
    ActivityIndex = -1 ;
    [saleView removeFromSuperview];
}

#pragma mark ---日历按钮点击

-(void)calendarClick:(UIButton * )button
{
    
    //储存车辆信息加载价格列表
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    DBCarModel * model =  _carsArray[button.tag - 300];
    
    lastModel = model ;
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    
    parDic[@"modelId"] = model.vehicleModelShow.id ;
    
    parDic[@"storeId"] =[self.takeStoreInfoDic objectForKey:@"id"];

    [user setObject:[NSString stringWithFormat:@"%ld",button.tag - 300] forKey:@"carSection"];

 
    
    
    //************************** 上面是储存的车辆信息
    
    
    
    NSArray * array = @[];
    NSInteger section = button.tag - 300 ;
    
    
    
    
    NSString * click = [NSString stringWithFormat:@"%ld",button.tag -300];

    //没有展示日历
    if (button.selected == NO)
    {

        [self loadPrice:button];
    }
    
    else
    {
        if (  [NSArray arrayWithArray:_dataArray[section]] != nil )
            
        {

            [_dataArray replaceObjectAtIndex:section withObject:array];
         
            [showPriceArray replaceObjectAtIndex:button.tag - 300 withObject:array];

            NSIndexPath *temIndexPath = [NSIndexPath indexPathForRow:0 inSection:section ];
            
            [_carListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:temIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            button.selected = NO ;
            
            [_lastArray removeObject:click];
            
            NSLog(@"%ld收起了",button.tag - 300);
 
        }

    }

}


-(void)loadPriceClick:(UIButton * )button
{

    NSInteger section = button.tag - 300 ;

    NSString * click = [NSString stringWithFormat:@"%ld",button.tag -300];
    
    
    
    NSLog(@"%ld",button.tag - 300);
    
    //判断列表是否展开
    if (button.selected == NO)
    {
        
        
        [_dataArray replaceObjectAtIndex:section withObject:@[@"1"]];

        [showPriceArray replaceObjectAtIndex:button.tag-300 withObject:priceArray];

        
        NSIndexPath *temIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        
        
        [_carListTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:temIndexPath] withRowAnimation:UITableViewRowAnimationFade];

        button.selected = YES ;
        
        
        [_lastArray addObject:click];
 
        NSLog(@"%ld展开了",button.tag - 300);

    }

    
    NSLog(@"%@",_dataArray);

}

#pragma mark ---车辆列表点击选择
-(void)chooseCar:(UIControl*)control
{
    
    
    DBCarModel * carModel = _carsArray[control.tag - 400];
    
    
    DBShowListModel * listmodel = [[NSArray arrayWithArray:carModel.vendorStorePriceShowList]firstObject] ;

    
    //没有选择活动则用默认最优活动
    
    
    NSLog(@"%ld---%ld",ActivityIndex  ,control.tag - 399);
    
    
    

    if ([_activityArray[control.tag - 400]isEqualToString:@"-1"] ) {

        
        chooseDic = nil;
        
        

    }
    else if ([_activityArray[control.tag - 400]isEqualToString:@"0"]){
        
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:listmodel.activityShow];

        chooseDic = [NSDictionary dictionary];
        chooseDic = dic ;
        
    }
    else{
        
        chooseDic = listmodel.activityShows[[_activityArray[control.tag - 400]integerValue]];
    }
    
    if (![self checkSignIn])
    {
        DBSignInViewController * sign = [[DBSignInViewController alloc]init];
        //        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:sign];
        //        sign.navigationController.navigationBarHidden = YES ;
        
        
        sign.indexControl = 0;
        sign.activityDic = chooseDic ;
        sign.model = _carsArray[control.tag - 400] ;

        [self.navigationController pushViewController:sign animated:YES];
    }
    //已经登录
    else
    {
        
        
        //跳转价格服务详情
        DBOrderServeViewController * orderServe = [[DBOrderServeViewController alloc]init];
        
//        orderinfo.indexControl = 0;
        orderServe.model = _carsArray[control.tag - 400] ;

        orderServe.activityDic = chooseDic ;

        
        
        if (!chooseDic) {
            
            
        }
        [self.navigationController pushViewController:orderServe animated:YES];
    }

    
//    DBOrderServeViewController * orderServe = [[DBOrderServeViewController alloc]init];
//    
//    
//        [self.navigationController pushViewController:orderServe animated:YES];

    
}


//判断是否登录
-(BOOL)checkSignIn
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"token"]isEqualToString:@"0"]||[user objectForKey:@"token"]==nil)
    {
        return NO;
    }
    
    NSLog(@"%@",[user objectForKey:@"token"]);
    return YES;
    
}

-(void)backBt
{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];

}


-(void)reloadPrice:(NSNotification*)noti
{
    
    NSLog(@"刷新了");
    
    [self.tipView removeFromSuperview];
    
    
    NSString * url = [NSString stringWithFormat:@"%@/api/rentalPack/prices",Host];
    
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    

    NSInteger month;
    
    
    NSString * startDate;
    
    NSString * endDate;
    
    if ([[noti object]isEqualToString:@"last"])
    {
        if ([[lastMonth substringWithRange:NSMakeRange(5, 2)]integerValue] > 1)
        {
            month = [[lastMonth substringWithRange:NSMakeRange(5, 2)]integerValue]-1;

        }
        else
        {
            [self tipShow:@"没有数据"];
            return ;
        }
        
        startDate = [lastMonth stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld",month]];
        
        endDate = lastMonth ;
        
    }
    else
        
    {
        if ([[lastMonth substringWithRange:NSMakeRange(5, 2)]integerValue] < 12)
        {
   
            month = [[lastMonth substringWithRange:NSMakeRange(5, 2)]integerValue]+1;
            

        }
        else
        {
            [self tipShow:@"没有数据"];
            return ;
        }

        startDate = [lastMonth stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld",month]];
        
        endDate = [lastMonth stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld",month+1]];;
    }

    parDic[@"startDate"] = startDate ;
    
    
    parDic[@"endDate"] = endDate;
    
    
    parDic[@"modelId"] = lastModel.vehicleModelShow.id ;
    
    parDic[@"storeId"] =[self.takeStoreInfoDic objectForKey:@"id"];
    
    
    
    [DBNetworkTool Get:url parameters:parDic success:^(id responseObject) {
        
        
        
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"])
        {

           priceArray = [NSArray arrayWithArray:[responseObject objectForKey:@"message"]] ;
            
            [showPriceArray[indexBt.tag-300]replaceObjectAtIndex:indexBt.tag-300 withObject:priceArray];
            
            priceDaysArray = [NSMutableArray array];
            
            NSInteger days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",startDate]];
            
            NSInteger week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",startDate]];
            
            
            NSLog(@"星期 ----%ld",week);
            
            for (int i  = 0; i < 42 ; i ++)
            {
                if ( i - week < 0)
                {
                    [priceDaysArray addObject:@"_"];
                }
                
                else if ( i - week < days)
                {
                    [priceDaysArray addObject:[NSString stringWithFormat:@"%ld",i-week+1]];
                }
                else if ( i >= days)
                    
                {
                    [priceDaysArray addObject:@"_"];
                    
                    
                }
                
                
                NSLog(@"%ld",i - week + 1);
                
                NSLog(@"今天是%@号",priceDaysArray[i]);
                
            }
            
            
            lastMonth = endDate ;

        }
        
    } failure:^(NSError *error) {

    }];

    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //初始化数据

    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    NSString * str;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPrice:) name:@"reloadPrice" object:str];

    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
     NSString * str;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadPrice" object:str];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"短租自驾车辆列表"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"短租自驾车辆列表"];
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
