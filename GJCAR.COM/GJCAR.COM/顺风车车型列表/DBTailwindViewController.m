//
//  DBTailwindViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/24.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBTailwindViewController.h"

#import "DBTaiilwindTableViewCell.h"

#import "DBFreeRideViewController.h"
//登录
#import "DBSignInViewController.h"
#import "DBFreeRideModel.h"
@interface DBTailwindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * carTableView;

@property (nonatomic,strong)NSMutableArray * modelArray ;

@property (nonatomic,strong)DBProgressAnimation * progress ;

//错误提示
@property (nonatomic,strong)UIView * tipView ;
@end

@implementation DBTailwindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏
    [self setNavgationView];
    
    //设置tableView
    [self setCarTableView];
    
    //加载数据
    [self loadData];
    
    
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

-(void)loadData
{
    _modelArray = [NSMutableArray array];

    NSString * url = [NSString stringWithFormat:@"%@/api/freeRide?currentPage=1&getCarCityId=%@&returnCarCityId=%@&pageSize=5&status=1",Host,self.takeCityId,self.returnCityId];

       [self addProgress];
    
    
//http://www.feeling.hpecar.com/api/freeRide?currentPage=1&getCarCityId=1&pageSize=5&returnCarCityId=3&status=1

    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            NSArray * array = [responseObject objectForKey:@"message"];

            
            for (NSDictionary * dic in array)
            {
                

                
                DBFreeRideModel * model = [[DBFreeRideModel alloc]initWithDictionary:dic error:nil];
                
                NSLog(@"%@",model);
                
                
                
                if (model != nil)
                {
                    [_modelArray addObject:model];

                }
                
                
            }
            
        }
        
        
        if (_modelArray.count > 0)
        {
            
            
            [_carTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else
        {
            [self tipShow:@"没有相关数据"];
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
        NSLog(@"%@",error);
        
        [self removeProgress];
        
    }];

    
}


#pragma mark 创建界面
#pragma mark ---创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"顺风车" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 63.5 , ScreenWidth , 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [nav addSubview:lineView];
    
    [self.view addSubview:nav];
 
}

#pragma mark ---创建tableview
-(void)setCarTableView
{
    _carTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    _carTableView.showsVerticalScrollIndicator = NO  ;
    _carTableView.showsHorizontalScrollIndicator = NO;
    _carTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _carTableView.delegate = self;
    _carTableView.dataSource = self;
    
    _carTableView.separatorStyle = NO;
    [self.view addSubview:_carTableView];
    
}


#pragma mark ---tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 10 ;
    return _modelArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBTaiilwindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tailCell"];
    
    if (cell == nil) {
        cell = [[DBTaiilwindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"railCell"];
    }
    
    [cell conFigWithModel:_modelArray[indexPath.row]];

    cell.selectionStyle = 0 ;
    return cell ;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self checkSignIn])
    {
        DBSignInViewController * sign = [[DBSignInViewController alloc]init];
        //        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:sign];
        //        sign.navigationController.navigationBarHidden = YES ;
        
        sign.indexControl = 1;
        
        sign.FreeRideModel = _modelArray[indexPath.row];
        
        
        [self.navigationController pushViewController:sign animated:YES];
    }
    //已经登录
    else
    {
        DBFreeRideViewController * order = [[DBFreeRideViewController alloc ]init];
        
        order.model = _modelArray[indexPath.row];
        
        
        [self.navigationController pushViewController:order animated:YES];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
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
