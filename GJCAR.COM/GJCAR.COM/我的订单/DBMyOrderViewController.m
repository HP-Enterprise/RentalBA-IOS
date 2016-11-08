//
//  DBMyOrderViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/23.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBMyOrderViewController.h"

#import "DBMyOrderTableViewCell.h"

#import "DBOderInfoViewController.h"


#import "DBFreeRideOrderViewController.h"


#import "DBOrderModel.h"
@interface DBMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

//订单列表
@property (nonatomic,strong)UITableView * orderTableView ;

//订单数据
@property (nonatomic,strong)NSMutableArray * orderArray;

@property (nonatomic,strong)DBProgressAnimation * progress ;

@property (nonatomic,strong)UIView * tipView ;

@end

@implementation DBMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   //创建导航栏
    [self setNavgationView];
    
    //创建列表
    [self setTableView];
    
    
//    //加载数据
//    [self loadOrderData];
    
    
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
-(void)loadOrderData
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    _orderArray = [NSMutableArray array];
    
    NSString * url ;
    switch (self.orderIndex)
    {
            //自驾
        case 0:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/order",Host,[user objectForKey:@"userId"]];
            
        }
            //门到门
            break;
        case 1:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/doortodoororder",Host,[user objectForKey:@"userId"]];
            
        }
            break;
        case 2:
        {
            
            [self tipShow:@"没有订单"];
            return;
//            url = [NSString stringWithFormat:@"%@/api/user/%@/doortodoororder",Host,[user objectForKey:@"userId"]];
            
        }
            break;
            //顺风车
        case 3:
        {
            url = [NSString stringWithFormat:@"%@/api/user/%@/freeRideOrder",Host,[user objectForKey:@"userId"]];
            
        }
            break;
            
        default:
            break;
    }
    
    
    [self addProgress];
    
    __weak typeof(self)weak_self = self ;
    [DBNetworkTool  checkOrderGET:url parameters:nil success:^(id responseObject) {
        

        [self removeProgress];
        
        
        NSArray * dataArray = [NSArray array];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            dataArray = [responseObject objectForKey:@"message"];
        }
        
        if (dataArray.count > 0 )
        {
            
            for (NSDictionary * dic in dataArray)
            {
                
                NSLog(@"%@",dic);
                

                
                DBOrderModel * model  = [[DBOrderModel alloc]initWithDictionary:dic error:nil];

                NSLog(@"%@",model.carGroupstr);
                

                [weak_self.orderArray addObject:model];
       
            }

//            [weak_self.orderTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [weak_self tipShow:@"没有相关信息"];
            weak_self.orderArray  = [NSMutableArray array];
        }
        [weak_self.orderTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    } failure:^(NSError *error) {
        
        [weak_self tipShow:@"没有相关信息"];
        
        [self removeProgress];
        [weak_self.orderTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

    }];
    
    
}



#pragma mark 界面创建

#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * title ;
    
    switch (self.orderIndex)
    {
        case 0:
            title = @"自驾订单" ;
            break;
        case 1:
            title = @"门到门订单" ;
            break;

        case 2:
            title = @"带驾订单" ;
            break;

        case 3:
            title = @"顺风车订单" ;
            break;

        default:
            break;
    }

    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:title withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    [self.view addSubview:nav];
    
}


#pragma mark ---创建导航栏
-(void)setTableView
{
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , 64 , ScreenWidth , ScreenHeight - 64)];
    _orderTableView.showsVerticalScrollIndicator  = NO ;
    _orderTableView.showsHorizontalScrollIndicator = NO ;
    _orderTableView.delegate = self ;
    _orderTableView.dataSource  = self ;
    _orderTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_orderTableView];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _orderArray.count ;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 302 ;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderIndex == 0 || self.orderIndex == 3)
    {
        DBMyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        
        if (cell == nil)
        {
            cell = [[DBMyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
        };
        
        if (self.orderArray.count > 0 ) {
            
              [cell cellConfigWithModel:_orderArray[indexPath.row]];
        }
      
        
        cell.selectionStyle  = 0 ;
        
        return cell ;

    }
    
    DBMyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"doortodoorCell"];
    
    if (cell == nil)
    {
        cell = [[DBMyOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doortodoorCell"];
    };
    
    
    [cell cellConfigWithModel:_orderArray[indexPath.row]];
    
    cell.selectionStyle  = 0 ;
    
    return cell ;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBOderInfoViewController * orderInfo = [[DBOderInfoViewController alloc]init];
    
    DBFreeRideOrderViewController * freeRideOrder = [[DBFreeRideOrderViewController alloc]init];

    if (_orderArray.count > 0 )
    {
        orderInfo.orderIndex = self.orderIndex ;
        orderInfo.model = _orderArray[indexPath.row] ;
      
        if (self.orderIndex == 3)
        {

            freeRideOrder.orderIndex = self.orderIndex ;
            freeRideOrder.model = _orderArray[indexPath.row] ;
            
            [self.navigationController pushViewController:freeRideOrder animated:YES];
            
        }
        else
        {
            [self.navigationController pushViewController:orderInfo animated:YES];
            
        }
    }
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)backBt
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}

- (void)tipShow:(NSString *)str
{
    
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    
    [super viewWillAppear:YES];
    
    //加载数据
    [self loadOrderData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"订单列表"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"订单列表"];
}
-(void)dealloc
{
    NSLog(@"%@ free",self);
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
