//
//  DBSixthViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSixthViewController.h"
#import "DBActiveTableViewCell.h"

//活动详情
#import "DBActiveDetailViewController.h"

@interface DBSixthViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong)UITableView * tableView ;

@property (nonatomic,strong)NSArray *dataArray ;
@end

@implementation DBSixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUI];
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];


}


-(void)loadData
{

    NSString * url = [NSString stringWithFormat:@"%@/api/actDisplay/list?aPosition=0&aType=2",Host];
    
    
    __weak typeof(self)weak_self = self ;
    [DBNetworkTool  Get:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            weak_self.dataArray = [responseObject objectForKey:@"message"];
            
            if (weak_self.dataArray.count > 0)
            {
                
                [weak_self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
        else
        {
            //   [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
        
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 创建界面

-(void)setUI
{
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 90)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate =self ;
    _tableView.dataSource= self ;
    _tableView.separatorStyle = 0 ;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DBActiveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"activeCell"];
    
    if (cell == nil ) {
        cell = [[DBActiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activeCell"];
    }

    [cell conFigWithModel:self.dataArray[indexPath.row]];
    cell.selectionStyle = 0 ;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UIApplication *application = [UIApplication sharedApplication];
//    
//
//    [application openURL:[NSURL URLWithString:[_dataArray[indexPath.row]objectForKey:@"link"]]];
//    
    DBActiveDetailViewController * detail = [[DBActiveDetailViewController alloc]init];
    detail.url = [self.dataArray[indexPath.row]objectForKey:@"phoneLink"];
    
    if (![[self.dataArray[indexPath.row]objectForKey:@"phoneLink"]isKindOfClass:[NSNull class]] && ![[self.dataArray[indexPath.row]objectForKey:@"phoneLink"]isEqualToString:@""]) {
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

-(NSArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];

        [self loadData];
    }
    return _dataArray ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"优惠活动首页"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"优惠活动首页"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
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
