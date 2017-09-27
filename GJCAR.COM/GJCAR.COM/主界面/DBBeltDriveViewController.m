//
//  DBBeltDriveViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBBeltDriveViewController.h"

#import "DBBeltDriveTableViewCell.h"


#import "DBServerDriveOderViewController.h"

@interface DBBeltDriveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView ;
    NSArray * _dataArray ;
}

@end

@implementation DBBeltDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavgationView];
    
    [self setTableView];
    
    
}

#pragma mark 界面创建

#pragma mark ----创建导航栏
//创建导航栏
-(void)setNavgationView
{
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"车辆列表" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    [nav.leftButton addTarget:self action:@selector(backBt) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];
    
    
}
#pragma mark ----创建tableview
-(void)setTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    
}


#pragma mark 设置tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
//    return _dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBBeltDriveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"beltDrive"];
    if (cell == nil)
    {
        cell = [[DBBeltDriveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"beltDrive"];
    }
    
    cell.reserve.tag = indexPath.row ;
    [cell.reserve addTarget:self action:@selector(reserveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark 点击事件

-(void)reserveClick:(UIButton * )button
{
    
    DBServerDriveOderViewController * order = [[DBServerDriveOderViewController alloc]init];
    [self.navigationController pushViewController:order animated:YES];
    NSLog(@"%ld",button.tag);
    
}

#pragma mark -----导航栏返回按钮
-(void)backBt
{
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
