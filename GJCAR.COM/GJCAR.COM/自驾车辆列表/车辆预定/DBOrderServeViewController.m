 //
//  DBOrderServeViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/15.
//  Copyright © 2016年 DuanBo. All rights reserved.
//



#import "DBOrderServeViewController.h"


#import "DBOrderSubmitViewController.h"

#import "DBShowListModel.h"


#import "DBCarListViewController.H"

@interface DBOrderServeViewController ()

{
    //在线支付
    UIButton * payOnline ;
    
    //门店支付
    UIButton * payStore ;

    //支付方式
    NSString * payWay;
    
    
}

@property (nonatomic,strong)NSDictionary * priceDic ;

//加载的增值服务
@property (nonatomic,strong)NSArray * addValueArr;

@property (nonatomic,strong)DBProgressAnimation * progress ;
//选择的增值服务
@property (nonatomic,strong)NSMutableArray * chooseAddValueArr;
@property (nonatomic,strong)UIView * tipView ;
@end

@implementation DBOrderServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavgationView];
    
//    
//    //创建必须服务
//    [self setMustCost];
 
    //加载价格数据
    [self loadPrice];
 
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

#pragma mark 加载数据
-(void)loadPrice
{
    
    _priceDic = [NSDictionary dictionary];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    

    if ([[user objectForKey:@"takeState"]isEqualToString:@"1"])
    {
        [self loadStorePrice];
        
    }
    else
    {
        [self loadDoortodoorPrice];
    }

}

//门店取车价格加载
-(void)loadStorePrice
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    

    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
    
    
    NSString * url ;
    
//    activityId ;
    
    if (self.activityDic && self.activityDic.count > 0)
    {

        _activityId  = [self.activityDic objectForKey:@"id"];
        url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=%@&modelId=%@&storeId=%@&userId=%@",Host,_activityId,_model.vehicleModelShow.id,model.id,[user objectForKey:@"userId"]];

    }
    else{
        
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
    
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _priceDic = [responseObject objectForKey:@"message"];

            //加载增值服务
            [self loadAddValue];
        
        }
        
        else
        {
            [self removeProgress];
            
        }
        NSLog(@"%@",responseObject);
        
        
        
    } failure:^(NSError *error) {
        
        [self tipShow:@"数据加载失败"];
        [self removeProgress];
    }];
}

//门到门价格加载
-(void)loadDoortodoorPrice
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    /*
     ttp://121.40.157.200:41234/api/searchAmountDetail?activityId=0&endDate=1467597600000&isDoorToDoor=1&latitude=30.598055&longitude=114.305794&modelId=21&startDate=1467424800000&storeId=5&userId=21
     */
    
    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];

    NSString * url = [NSString stringWithFormat:@"%@/api/searchAmountDetail?activityId=&modelId=%@&storeId=%@",Host,_model.vehicleModelShow.id,model.id];
    
    
    
    NSLog(@"%@-----%@",_model.vehicleModelShow.id,model.id);

    NSMutableDictionary * pardic = [NSMutableDictionary dictionary];
    
    NSDictionary * takePlace = [user objectForKey:@"takePlace"];
    
    pardic[@"endDate"]= [ user objectForKey:@"returnTime"];
    pardic[@"startDate"]= [ user objectForKey:@"takeTime"];
    
    pardic[@"isDoorToDoor"]= @"1";
    pardic[@"latitude"]= [ takePlace objectForKey:@"latitude"];
    pardic[@"longitude"]= [ takePlace objectForKey:@"longitude"];

    NSLog(@"%@",url);
    
    NSLog(@"%@",[ user objectForKey:@"returnTime"]);
    NSLog(@"%@",[ user objectForKey:@"takeTime"]);
    
    
    [self addProgress];
    
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {
        

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {
            _priceDic = [responseObject objectForKey:@"message"];
            [self loadAddValue];
            
        }
        
        else
        {
            [self removeProgress];
        }
        NSLog(@"%@",responseObject);
        
        
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        
        NSLog(@"%@",error);
        
        
    }];
}


//加载增值服务
-(void)loadAddValue
{
    
    _addValueArr = [NSArray array];
    
    _chooseAddValueArr = [NSMutableArray array];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    DBShowListModel * model =[[NSArray arrayWithArray:_model.vendorStorePriceShowList]firstObject];
    
    
    
    
    
    
    
    NSString * url ;
    //门到门
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        
        url = [NSString stringWithFormat:@"%@/api/charge/service/added-value?modelId=&s=0,2&storeId=%@",Host,model.id];
    }
    else
    {
        
//        NSString * takeid =[user objectForKey:@"takeCityId"];
//        NSString * returnid =[user objectForKey:@"returnCityId"];
//        
        url = [NSString stringWithFormat:@"%@/api/charge/service/added-value?modelId=&s=0,2&storeId=%@",Host,model.id];
        
//        if ([[user objectForKey:@"takeCityId"]isEqualToString:[user objectForKey:@"returnCityId"]])
//        {
//            
//            
//            
//            
//            if (![[NSString stringWithFormat:@"%@",[[user objectForKey:@"takeStore"]objectForKey:@"id"]]isEqualToString:[NSString stringWithFormat:@"%@",[[user objectForKey:@"returnStore"]objectForKey:@"id"]]])
//            {
//                url = [NSString stringWithFormat:@"%@/api/charge/service/added-value?modelId=&storeId=%@",Host,model.id];
//
//            }
//            else
//            {
//                url = [NSString stringWithFormat:@"%@/api/charge/service/added-value?modelId=&s=0,2&storeId=%@",Host,model.id];
//            }
//            
//        }
//        else
//        {
//            
//            
//            url = [NSString stringWithFormat:@"%@/api/charge/service/added-value?modelId=&s=0,2&storeId=%@",Host,model.id];
//        }
        
    }

    NSMutableDictionary * pardic = [NSMutableDictionary dictionary];
    
    NSString * takeTime = [ user objectForKey:@"returnCarDate"];
    NSString * returnTime = [ user objectForKey:@"takeCarDate"];
    pardic[@"endTime"]= [NSString stringWithFormat:@"%@%@%@",[takeTime substringWithRange:NSMakeRange(0, 4)],[takeTime substringWithRange:NSMakeRange(5, 2)],[takeTime substringWithRange:NSMakeRange(8, 2)]];
    pardic[@"startTime"]=[NSString stringWithFormat:@"%@%@%@",[returnTime substringWithRange:NSMakeRange(0, 4)],[returnTime substringWithRange:NSMakeRange(5, 2)],[returnTime substringWithRange:NSMakeRange(8, 2)]];
    NSLog(@"%@",url);
    
    NSLog(@"%@",[ user objectForKey:@"returnCarDate"]);
    NSLog(@"%@",[ user objectForKey:@"takeCarDate"]);
    
    
    
    
    
    
    [DBNetworkTool Get:url parameters:pardic success:^(id responseObject) {
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]){
            
            if (![[responseObject objectForKey:@"message"]isKindOfClass:[NSNull class]])   {
                _addValueArr = [responseObject objectForKey:@"message"];
                //添加异地还车
                [self addDifferentStoreServer:_addValueArr];
            }

            
        }
        

        [self performSelectorOnMainThread:@selector(setMustCost) withObject:nil waitUntilDone:YES];
       
        
//        NSLog(@"%@",responseObject);
        
    
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        
    }];
}


//异店还车服务
-(void)addDifferentStoreServer:(NSArray * )array;
{
    NSUserDefaults * user= [NSUserDefaults standardUserDefaults];
    
    for (NSDictionary * dic in array)
    {
        if ([[user objectForKey:@"takeCityId"]isEqualToString:[user objectForKey:@"returnCityId"]])
        {
            
            if (![[NSString stringWithFormat:@"%@",[[user objectForKey:@"takeStore"]objectForKey:@"id"]]isEqualToString:[NSString stringWithFormat:@"%@",[[user objectForKey:@"returnStore"]objectForKey:@"id"]]])
            {
                if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"chargeName"]]isEqualToString:@"异店还车"])
                {
                    
                    [_chooseAddValueArr addObject:dic];
                }
            }
            
        }
    }


}

#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"选择服务" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    
    
    [self.view addSubview:nav];
    
    
}


#pragma mark ---创建必选服务
-(void)setMustCost
{
    //必选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [self.view addSubview:mustCost];
    
    
    //必选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"必选服务";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];

    
    
    
    
    [mustCost addSubview:mustCostLabel];
    
    
    //手续费
    
    UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(mustCost.frame), ScreenWidth/3 - mustCostLabel.frame.origin.x, 40)];
    commissionLabel.text = @"手续费";
    commissionLabel.font = [ UIFont systemFontOfSize:14];
    
    commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [self.view addSubview:commissionLabel];
    
    
    //
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( commissionLabel.frame.size.width - 0.5 , 10 , 0.5 , 20)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [commissionLabel addSubview:lineView1];
    
    
    //手续费单价
    
    UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commissionLabel.frame)+20 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
   
    [self.view addSubview:commission];
    
    NSDictionary *commissionDic = [[NSArray arrayWithArray:[[_priceDic objectForKey:@"poundageAmount"]objectForKey:@"details"]]firstObject] ;
    
    NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];

    
    

    NSMutableAttributedString *commissionStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",commissionstr]];
//    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, commissionstr.length + 1)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    commission.attributedText = commissionStr;
    
    
    //手续费总价
    
    UILabel * commissionTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
    
    commissionTotal.textAlignment = 2 ;
    
    [self.view addSubview:commissionTotal];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",commissionstr]];
    //

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,commissionstr.length + 2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, commissionstr.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    commissionTotal.attributedText = str;

    //保险费分割线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(commissionTotal.frame) , ScreenWidth - 40 , 0.5)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView2];
    
    
    
//**************************保险费
    
    //基本保险费
    
    UILabel * costPremiumLabel = [[UILabel alloc]initWithFrame:CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(commissionTotal.frame), ScreenWidth/3 - mustCostLabel.frame.origin.x, 40)];
    costPremiumLabel.text = @"基本保险费";
    costPremiumLabel.font = [ UIFont systemFontOfSize:14];
    
    costPremiumLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    
    [self.view addSubview:costPremiumLabel];
    
    
    //
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( costPremiumLabel.frame.size.width - 0.5 , 10 , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [costPremiumLabel addSubview:lineView3];
    
    
    //保险费单价
    
    UILabel * costPremium = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(costPremiumLabel.frame)+20 , costPremiumLabel.frame.origin.y, ScreenWidth / 3 - 20, costPremiumLabel.frame.size.height)];
    
    [self.view addSubview:costPremium];
    
    NSString * basicInsuranceAmount =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"basicInsuranceAmount"]];
    NSString * daySum =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"daySum"]];
    
    
    NSMutableAttributedString *costPremiumStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@X%@",basicInsuranceAmount,daySum]];
    
    NSLog(@"%@",costPremiumStr);
    
    
    
    
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [costPremiumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,basicInsuranceAmount.length + daySum.length + 2)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    costPremium.attributedText = costPremiumStr;
    
    
    //保险费总价
    
    UILabel * costPremiumTotal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth * 2 / 3 , costPremiumLabel.frame.origin.y, ScreenWidth / 3 - 20, costPremiumLabel.frame.size.height)];
    
    costPremiumTotal.textAlignment = 2 ;
    
    [self.view addSubview:costPremiumTotal];
    
    NSString *  totalBasicInsuranceAmount =[NSString stringWithFormat:@"%@",[_priceDic objectForKey:@"totalBasicInsuranceAmount"]];
    
    NSMutableAttributedString *costPremiumTotalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",totalBasicInsuranceAmount]];
    //
    
    [costPremiumTotalStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] range:NSMakeRange(0,totalBasicInsuranceAmount.length+2)];
    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
    [costPremiumTotalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, totalBasicInsuranceAmount.length + 1)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
    costPremiumTotal.attributedText = costPremiumTotalStr;

    
    
    //说明
    
    UILabel * explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(costPremiumTotal.frame), ScreenWidth-20, 20)];
    
    explainLabel.text = @"必选部分,客户只需承担1500元以内的车辆损失费";
    
    explainLabel.font = [UIFont systemFontOfSize:12];
    explainLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    
    
    
//    [self.view addSubview:explainLabel];
    
    
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(costPremiumLabel.frame) , ScreenWidth , 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [self.view addSubview:lineView4];

    
    

    NSLog(@"%f",lineView4.frame.origin.y);

    if (_addValueArr.count > 0)
    {
        //创建可选服务
        [self setChooseCostWithNumber:_addValueArr.count];
    }
    else
    {
        //创建支付方式选择页面
        [self choosePayWayWith:lineView4.frame];
    }

}


#pragma mark ---创建可选服务
-(void)setChooseCostWithNumber:(NSInteger)Number
{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 185, ScreenWidth, 80)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    
    
    
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
    [baseView addSubview:mustCost];
    
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"可选服务";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];


    
    
    
    for (int i = 0 ; i < Number ; i ++){
        if ([[NSString stringWithFormat:@"%@",[_addValueArr[i]objectForKey:@"chargeName"]]isEqualToString:@"不计免赔"])
        {
            
            
            if (![[NSString stringWithFormat:@"%@",[[self.activityDic objectForKey:@"activityTypeShow"]objectForKey:@"hostType"]]isEqualToString:@"8"]) {
                //不计免赔服务
                
                UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(mustCost.frame) , ScreenWidth/3 - mustCostLabel.frame.origin.x, 40)];
                commissionLabel.text = [_addValueArr[i]objectForKey:@"chargeName"];
                commissionLabel.font = [ UIFont systemFontOfSize:14];
                
                commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
                
                [baseView addSubview:commissionLabel];
                
                
                //
                UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( commissionLabel.frame.size.width - 0.5 , 10 , 0.5 , 20)];
                lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                [commissionLabel addSubview:lineView1];
                
                
                //不计免赔服务
                
                UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commissionLabel.frame)+20 , commissionLabel.frame.origin.y, ScreenWidth / 2 , commissionLabel.frame.size.height)];
                
                [baseView addSubview:commission];
                
                
                NSDictionary *commissionDic = [[NSArray arrayWithArray:[_addValueArr[i] objectForKey:@"details"]]firstObject] ;
                
                NSString * commissionstr =[NSString stringWithFormat:@"%@",[commissionDic objectForKey:@"price"]];
                
                NSMutableAttributedString *commissionStr;
                
                
                NSInteger  price;
                
                
                
                //            if ([[_priceDic objectForKey:@"daySum"]integerValue]<=7){
                //
                //
                //                price = [commissionstr integerValue]* [[_priceDic objectForKey:@"daySum"]integerValue];
                //                commissionStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %@X%@=%ld(上限7天)",commissionstr,[_priceDic objectForKey:@"daySum"],price]];
                //            }
                //            else{
                //
                //                price = [commissionstr integerValue]* 7;
                //                commissionStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"均价50元/天(上限7天,每30天一周期)，共65天",commissionstr,@"7",price]];
                //            }
                
                
                
                price = [DBcommonUtils calculateRegardless:[[_priceDic objectForKey:@"daySum"]integerValue]] * [commissionstr integerValue];
                commissionStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥ %ld",price]];
                
                //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
                //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
                //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
                [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
                [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(1, commissionStr.length-1)];
                //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
                commission.attributedText = commissionStr;
                
                //选择开关
                
                //    UISwitch * commissionSwitch = [UISwitch
                //]
                //
                //发票开关
                UISwitch * commissionSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 ,CGRectGetMaxY(mustCost.frame) +4.5 , 51, 15)];
                
                commissionSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
                commissionSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
                
                [baseView addSubview:commissionSwitch];
                //            [commissionSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
                [commissionSwitch addTarget:self action:@selector(switchs:) forControlEvents:UIControlEventValueChanged];
                
                [commissionSwitch setSelected:NO];
                commissionSwitch.tag = 500;
                
                
                //保险费分割线
                UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(commission.frame) , ScreenWidth - 40 , 0.5)];
                lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
                [baseView addSubview:lineView2];
            }
            else{
                baseView.frame = CGRectMake(0, 185, ScreenWidth, 40);
            }
        }
        
    }
    
    
    
    
//    //不计免赔服务
//    
//    UILabel * commissionLabel = [[UILabel alloc]initWithFrame:CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(mustCost.frame), ScreenWidth/3 - mustCostLabel.frame.origin.x, 40)];
//    commissionLabel.text = @"不计免赔服务";
//    commissionLabel.font = [ UIFont systemFontOfSize:14];
//    
//    commissionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
//    
//    [baseView addSubview:commissionLabel];
//    
//    
//    //
//    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( commissionLabel.frame.size.width - 0.5 , 10 , 0.5 , 20)];
//    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [commissionLabel addSubview:lineView1];
//    
//    
//    //不计免赔服务
//    
//    UILabel * commission = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commissionLabel.frame)+20 , commissionLabel.frame.origin.y, ScreenWidth / 3 - 20, commissionLabel.frame.size.height)];
//    
//    [baseView addSubview:commission];
//    
//    
//    NSMutableAttributedString *commissionStr = [[NSMutableAttributedString alloc] initWithString:@"￥ 50X2=100"];
//    //
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
//    [commissionStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, 9)];
//    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
//    commission.attributedText = commissionStr;
//
//    //选择开关
//    
////    UISwitch * commissionSwitch = [UISwitch 
////]
////
//    //发票开关
//    UISwitch * commissionSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 ,CGRectGetMaxY(mustCost.frame) +4.5, 51, 15)];
//    
//    commissionSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
//    commissionSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
//    
//    [baseView addSubview:commissionSwitch];
//    [commissionSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
//    [commissionSwitch setSelected:NO];
//    commissionSwitch.tag = 500;
//    
//    
//    
//    
//    //保险费分割线
//    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( 20 , CGRectGetMaxY(commission.frame) , ScreenWidth - 40 , 0.5)];
//    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [baseView addSubview:lineView2];
//
//    
//    
//    
//    
//    
//    
//    
//    //异店还车服务
//    
//    UILabel * returnStoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(commissionLabel.frame), ScreenWidth/3 - mustCostLabel.frame.origin.x, 40)];
//    returnStoreLabel.text = @"异店还车服务";
//    returnStoreLabel.font = [ UIFont systemFontOfSize:14];
//    
//    returnStoreLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
//    
//    [baseView addSubview:returnStoreLabel];
//
//    
//    //
//    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( returnStoreLabel.frame.size.width - 0.5 , 10 , 0.5 , 20)];
//    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [returnStoreLabel addSubview:lineView3];
//    
//    
//    //异地还车
//    
//    UILabel * returnStore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnStoreLabel.frame)+20 , returnStoreLabel.frame.origin.y, ScreenWidth / 3 - 20, returnStoreLabel.frame.size.height)];
//    
//    [baseView addSubview:returnStore];
//    
//    
//    NSMutableAttributedString *returnStoreStr = [[NSMutableAttributedString alloc] initWithString:@"￥ 50X2=100"];
//    //
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    //    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [returnStoreStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, 1)];
//    [returnStoreStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, 9)];
//    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(19, 6)];
//    returnStore.attributedText = returnStoreStr;
//    
//    //选择开关
//    
//    //    UISwitch * commissionSwitch = [UISwitch
//    //]
//    //
//    //发票开关
//    UISwitch * returnStoreSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 ,returnStoreLabel.frame.origin.y +4.5, 51, 15)];
//    
//    returnStoreSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
//    returnStoreSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
//    
//    [baseView addSubview:returnStoreSwitch];
//    [returnStoreSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
//    [returnStoreSwitch setSelected:NO];
//    returnStoreSwitch.tag = 501;
//    
//    
//    
////    //说明
////    
////    UILabel * explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView2.frame)+10, ScreenWidth-20, 20)];
////    
////    explainLabel.text = @"必选部分,客户只需承担1500元以内的车辆损失费";
////    
////    explainLabel.font = [UIFont systemFontOfSize:12];
////    explainLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
////    
////    
////    
////    [self.view addSubview:explainLabel];
//    
//    
//    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(returnStoreLabel.frame) - 0.5 , ScreenWidth , 0.5)];
//    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [baseView addSubview:lineView5];

    
    

    //创建支付方式选择页面
    [self choosePayWayWith:baseView.frame];
    
    
    
}

#pragma mark ---创建支付方式
-(void)choosePayWayWith:(CGRect)frame
{
    //可选服务 背景
    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 110)];
    mustCost.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    
    [self.view addSubview:mustCost];
    
    
    UIView * ToplineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 0 , ScreenWidth , 0.5)];
    ToplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:ToplineView];

    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , mustCost.frame.size.height-0.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [mustCost addSubview:lineView];
    
  
    
    UILabel * messageLebal = [[UILabel alloc]initWithFrame:CGRectMake(5,  mustCost.frame.size.height-30, ScreenWidth, 19.5)];
    messageLebal.backgroundColor = [UIColor clearColor];
    messageLebal.font = [UIFont systemFontOfSize:12];
    messageLebal.textAlignment = 1;
    messageLebal.text = @"提示 : 在线支付订单请2小时内付款,逾期订单将自动取消";
    
    messageLebal.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] ;
    
    
    //可选服务 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth, 20)];
    mustCostLabel.text = @"支付方式";
    mustCostLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [mustCost addSubview:mustCostLabel];

    
    //在线支付
    payOnline = [UIButton buttonWithType:UIButtonTypeCustom];
    
    payOnline.frame = CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(mustCostLabel.frame)+5, ScreenWidth / 4, 30);
    
    
    [payOnline setTitle:@"在线支付" forState:UIControlStateNormal];
        payOnline.titleLabel.font = [UIFont systemFontOfSize:14];
    [payOnline addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
    payOnline.layer.borderWidth = 1 ;
    payOnline.layer.cornerRadius = 2 ;

    
    
    
    
    //在线支付
    payStore = [UIButton buttonWithType:UIButtonTypeCustom];
    
    payStore.frame = CGRectMake(CGRectGetMaxX(payOnline.frame)+10 , CGRectGetMaxY(mustCostLabel.frame)+5, ScreenWidth / 4, 30);
    
    [payStore addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
    [payStore setTitle:@"门店支付" forState:UIControlStateNormal];
       payStore.titleLabel.font = [UIFont systemFontOfSize:14];

    payStore.layer.borderWidth = 1 ;
    payStore.layer.cornerRadius = 2 ;

   

    
    NSString * paymen  = [NSString stringWithFormat:@"%@",[self.priceDic objectForKey:@"payment"]];
    

    if ([paymen isEqualToString:@"1"]) {
        [mustCost addSubview:payOnline];
        
        payOnline.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
        [payOnline setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
        payStore.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        [payStore setTitleColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];
        
        payWay = @"3" ;
        [mustCost addSubview:messageLebal];
    }
    else if ([paymen isEqualToString:@"2"]){
        payStore.frame =CGRectMake(mustCostLabel.frame.origin.x, CGRectGetMaxY(mustCostLabel.frame)+5, ScreenWidth / 4, 30);

        payStore.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
        [payStore setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
        payOnline.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        [payOnline setTitleColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];
        
        payWay = @"0" ;

        
        [mustCost addSubview:payStore];
       
    }
    else if ([paymen isEqualToString:@"3"]){
        
        [mustCost addSubview:payOnline];
        [mustCost addSubview:payStore];

        payStore.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
        [payStore setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
        payOnline.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        [payOnline setTitleColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];
        
        payWay = @"0" ;

        [mustCost addSubview:messageLebal];
    }
    
    

    //创建发票页面
    [self setInvoiceViewWith:mustCost.frame];
}


#pragma mark ---创建发票页面
-(void)setInvoiceViewWith:(CGRect)frame
{
    
    
//    UIView * back = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 20)];
//    [self.view addSubview:back];
//    
//    back.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
//    
//    
    
    
//    //可选服务 背景
//    UIView * mustCost = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 40)];
//    mustCost.backgroundColor = [UIColor whiteColor];
//    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 39.5 , ScreenWidth , 0.5)];
//    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [mustCost addSubview:lineView];
//    
//    UIView * ToplineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 0 , ScreenWidth , 0.5)];
//    ToplineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [mustCost addSubview:ToplineView];
//    
//    
//    
//    
//    
//    
//    [self.view addSubview:mustCost];
//    
//    
//    //开具发票 标题
//    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth, 20)];
//    mustCostLabel.text = @"开具发票";
//    mustCostLabel.font = [UIFont systemFontOfSize:14];
//    mustCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] ;
//    
//    [mustCost addSubview:mustCostLabel];
//
//    //
//    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( ScreenWidth/3 - mustCostLabel.frame.origin.x , 10 , 0.5 , 20)];
//    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
//    [mustCost addSubview:lineView1];
//    
//    
//    
//    //发票开关
//    UISwitch * invoiceSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 , 4.5, 51, 15)];
//    
//    invoiceSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
//    invoiceSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1]; 
//    [mustCost addSubview:invoiceSwitch];
////    [invoiceSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
//    [invoiceSwitch setSelected:NO];
//    invoiceSwitch.tag = 511;
//    
//    
//    
//    
//    
//    
    
    
    
    //显示更多车辆按钮
    UIButton * showCarBt = [UIButton buttonWithType:UIButtonTypeCustom];
    showCarBt.frame = CGRectMake(50, CGRectGetMaxY(frame)+40 , ScreenWidth - 100  , 30 );
    [showCarBt setTitle:@"下一步" forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showCarBt setBackgroundImage:[UIImage imageNamed:@"showCarBt"] forState:UIControlStateNormal];
    [showCarBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showCarBt.titleLabel.font = [UIFont systemFontOfSize:12 ];
    showCarBt.layer.cornerRadius = 5 ;
    showCarBt.backgroundColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [showCarBt addTarget:self action:@selector(nextBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showCarBt];

    
    
}


//payStore.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;

#pragma makr ---支付方式选择

-(void)choosePayWay:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"在线支付"])
    {
        payOnline.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
        [payOnline setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
         payStore.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        [payStore setTitleColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];

        payWay = @"3" ;
        
    }
    else if ([button.titleLabel.text isEqualToString:@"门店支付"])
    {
        payStore.layer.borderColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1].CGColor;
        [payStore setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
        payOnline.layer.borderColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
        [payOnline setTitleColor:[UIColor colorWithRed:0.74 green:0.74 blue:0.74 alpha:1] forState:UIControlStateNormal];
        
        payWay = @"0" ;

    }
}


-(void)nextBt
{
    
    
    NSLog(@"%@",payWay);
    
    
    
    DBOrderSubmitViewController * orderSubmit = [[DBOrderSubmitViewController alloc]init];
    
    orderSubmit.payWay = payWay ;
    orderSubmit.priceDic = self.priceDic ;
    orderSubmit.model = self.model ;
    orderSubmit.activityDic = self.activityDic ;
    orderSubmit.addValueArr = _chooseAddValueArr ;
    
    [self.navigationController pushViewController:orderSubmit animated:YES];
    
    
    
}
-(void)switchIsOn:(UISwitch*)switchs{
    
    if (switchs.isOn == YES)
    {
        [_chooseAddValueArr addObject:_addValueArr[switchs.tag - 500]];
    }
    else if (switchs.isOn == NO)
    {
        [_chooseAddValueArr removeObject:_addValueArr[switchs.tag - 500]];

    }

}
-(void)switchs:(UISwitch*)switchs{
    
    if (switchs.isOn == YES)
    {
        [_chooseAddValueArr addObject:_addValueArr[switchs.tag - 500]];
    }
    else if (switchs.isOn == NO)
    {
        [_chooseAddValueArr removeObject:_addValueArr[switchs.tag - 500]];
        
    }
}



- (void)tipShow:(NSString *)str{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
}
-(void)backBt
{

    for (UIViewController * control in self.navigationController.viewControllers)
    {
        if ([control isKindOfClass:[DBCarListViewController class]])
        {
            [self.navigationController popToViewController:control animated:YES];
            return ;
        }
        
    }

    [self.navigationController popViewControllerAnimated:YES];
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
