//
//  DBScoreViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/5.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBScoreViewController.h"

#import "DBScoreTableViewCell.h"

//积分兑换
#import "DBSwapViewController.h"
@interface DBScoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView ;
@property (nonatomic,strong)NSString * remain ;
@property (nonatomic,strong)NSArray * accumulateArray;


@end

@implementation DBScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavigation];
    
    //创建Tableview
    [self setTableView];
    
    
  
    
    
}

-(void)loadData
{
    
    
    _accumulateArray = [NSArray array];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me/accumulate/remain",Host];
    

//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

        
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
       

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _remain = [[responseObject objectForKey:@"message"]objectForKey:@"remain"];
            
        }
        else
        {
//            [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
   
    
    NSString * url1 = [NSString stringWithFormat:@"%@/api/me/accumulate/detail?pageSize=100",Host];

    __weak typeof(self)weak_self = self ;
    [DBNetworkTool getUserInfoGET:url1 parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            weak_self.accumulateArray = [responseObject objectForKey:@"message"] ;
            
            
            
            if (weak_self.accumulateArray.count > 0 )
            {
                [weak_self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }

        else
        {
//            [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];

    

}


#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"我的积分" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton * swapBt = [UIButton buttonWithType:UIButtonTypeCustom];
    swapBt.frame = CGRectMake(nav.frame.size.width - 40 , 32 , 30 , 20);
    
    [swapBt setTitle:@"兑换" forState:UIControlStateNormal];
    swapBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [swapBt addTarget:self action:@selector(swapClick) forControlEvents:UIControlEventTouchUpInside];
    [swapBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

//    NSString * url =[NSString stringWithFormat:@"%@/api/appManage/latest?appType=1",Host];
//    
//    
//    [DBNetworkTool Get:url parameters:nil success:^(id responseObject)
//     {
//         
//         
//         if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
//         {
//             
//             
//             
//         }
//         
//         
//     } failure:^(NSError *error) {
//         
//     }];
//    
    [nav addSubview:swapBt];


    
}

-(void)setTableView
{
    
    _tableView = [[ UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.showsHorizontalScrollIndicator = NO ;
    _tableView.showsVerticalScrollIndicator = NO ;
    _tableView.dataSource =self ;
    _tableView.delegate = self ;
    
    
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _accumulateArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenWidth/4 +  50  ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80 ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    
    //圆形背景
    UIView * circleView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth * 3 / 8 , 20, ScreenWidth / 4 , ScreenWidth / 4)];
    circleView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
    circleView.layer.cornerRadius = ScreenWidth / 8 ;
    
    [headView addSubview:circleView ];
    
    
    UILabel * scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, circleView.frame.size.width, circleView.frame.size.width/4)];
    
    scoreLabel.text = @"积分" ;
    scoreLabel.textAlignment = 1 ;
    scoreLabel.font = [UIFont systemFontOfSize:14];
    scoreLabel.textColor = [UIColor whiteColor];
    [circleView addSubview:scoreLabel];
    
    
    
    UILabel * score = [[UILabel alloc]initWithFrame:CGRectMake(0, circleView.frame.size.width/2 , circleView.frame.size.width, circleView.frame.size.width/4)];
    score.adjustsFontSizeToFitWidth = YES;
    if (_remain == nil)
    {
        score.text = @"0";
    }
    else
    {
        score.text =[NSString stringWithFormat:@"%@",_remain] ;
    }
    
    score.textAlignment = 1 ;
    score.font = [UIFont systemFontOfSize:20];
    score.textColor = [UIColor whiteColor];
    [circleView addSubview:score];
    
    //详情
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(circleView.frame) + 20, ScreenWidth/2 - 30, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] ;
    [headView addSubview:lineView] ;
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 30, CGRectGetMaxY(circleView.frame) + 20, ScreenWidth/2 - 30, 0.5)];
    
    lineView1.backgroundColor = [UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] ;
    [headView addSubview:lineView1] ;

    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 30, lineView.frame.origin.y - 5, 60, 10)];
    detailLabel.text = @"积分详情" ;
    detailLabel.font = [UIFont systemFontOfSize:10];
    detailLabel.textAlignment = 1;
    detailLabel.textColor =  [UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] ;
    [headView addSubview:detailLabel];
    

    return headView ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DBScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"scoreCell"];
    if (cell == nil)
    {
        cell = [[DBScoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scoreCell"];
    }
    
    
    if (_accumulateArray.count > 0 )
    {
        

        if ([_accumulateArray[indexPath.row][@"remark"]isKindOfClass:[NSNull class]]) {
            cell.titleLael.text =@"积分兑换";
        }
        else{
           cell.titleLael.text =[NSString stringWithFormat:@"%@",[_accumulateArray[indexPath.row]objectForKey:@"remark"]];
        }

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSDate * takeDate =[NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",[_accumulateArray[indexPath.row]objectForKey:@"changeTime"]] doubleValue]/1000];
        
        NSString * takeTimeStr =[formatter stringFromDate:takeDate];

        cell.timelabel.text = takeTimeStr;
        
        
        cell.scoreLabel.text = [NSString stringWithFormat:@"%@",[_accumulateArray[indexPath.row]objectForKey:@"amount"]];
        
    }
    
    cell.selectionStyle = 0 ;
    
    return cell;
}

#pragma mark --点击事件

-(void)swapClick
{
    DBSwapViewController * swap = [[DBSwapViewController alloc]init];
    [self.navigationController pushViewController:swap animated:YES];
}


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:YES];
    
    //加载数据
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"我的积分页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"我的积分页面"];
}


-(void)dealloc
{
    NSLog(@"%@ free",self);
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
