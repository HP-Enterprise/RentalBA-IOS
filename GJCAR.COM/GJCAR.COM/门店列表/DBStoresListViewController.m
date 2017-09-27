
//
//  DBStoresListViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 2017/7/18.
//  Copyright © 2017年 DuanBo. All rights reserved.
//

#import "DBStoresListViewController.h"
#import "DBStoreTableViewCell.h"
#import "DBServiceTableViewCell.h"
@interface DBStoresListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong)UIView  * tipView;
//门店tableView
@property (nonatomic,strong)UITableView * storeTableView ;
@property (nonatomic,strong)UIView * moveView ;
//门店数据
@property (nonatomic,strong)NSArray * storeArray ;



@property (nonatomic,strong)UITableView * serviceTableView ;

@end

@implementation DBStoresListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self setUI];
    [self loadStoreData];
}
#pragma mark --创建导航栏
-(void)setNavigation{
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1] ;
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"选择门店" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setUI{
    
    
    
    CGFloat store_w = ScreenWidth * 2 / 5 ;
    CGFloat service_w = ScreenWidth * 3 / 5 ;
    
    _storeTableView= [[UITableView alloc]initWithFrame:CGRectMake( 0 , 64 , store_w, ScreenHeight - 64) style:UITableViewStylePlain];
    _storeTableView.showsVerticalScrollIndicator = NO ;
    _storeTableView.showsHorizontalScrollIndicator = NO ;
    _storeTableView.delegate = self ;
    _storeTableView.dataSource = self ;
    _storeTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _storeTableView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1] ;
    _storeTableView.layer.borderWidth = 0.5 ;
    _storeTableView.layer.borderColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1].CGColor ;

    [self.view addSubview:_storeTableView];
    _storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;

    
    
    _moveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, store_w + 1, 40)];
    _moveView.backgroundColor = [UIColor clearColor] ;
    [_storeTableView addSubview:_moveView];

    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, store_w, 0.5)];
    topView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    [_moveView addSubview:topView];
    
    UIView * bottomView  =[[UIView alloc]initWithFrame:CGRectMake(0, 39.5, store_w, 0.5)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1] ;
    [_moveView addSubview:bottomView];
    
    UIView * leftView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 40)];
    leftView.backgroundColor = [UIColor redColor];
    [_moveView addSubview:leftView];
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(store_w - 1, 0, 1, 40)];
    rightView.backgroundColor = [UIColor whiteColor];
    [_moveView addSubview:rightView];
    
    
    _serviceTableView= [[UITableView alloc]initWithFrame:CGRectMake( store_w , 64 , service_w, ScreenHeight - 64) style:UITableViewStylePlain];
    _serviceTableView.showsVerticalScrollIndicator = NO ;
    _serviceTableView.showsHorizontalScrollIndicator = NO ;
    _serviceTableView.delegate = self ;
    _serviceTableView.dataSource = self ;
    _serviceTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_serviceTableView];
    _serviceTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    

}

//cell高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _storeTableView) {
        return 40 ;
    }
    return 40 ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==_storeTableView) {
        return _storeArray.count ;
    }
    return 10;
}

//商圈门店赋值
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _storeTableView ) {
        DBStoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
        if (cell == nil) {
            cell = [[DBStoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeCell"];
        }
        [cell configWith:_storeArray[indexPath.row]];
        
        if (indexPath.row == 0) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        return cell ;
    }
   
    DBServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    if (cell == nil) {
        cell = [[DBServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serviceCell"];
    }
    return cell ;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    


    
}

#pragma mark -- 处理数据

-(void)loadStoreData
{
    _storeArray = [NSArray array];
    NSString * url = [NSString stringWithFormat:@"%@/api/china/province/city/%@/store?available=1",Host,self.cityId];
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"]){
            _storeArray = [responseObject objectForKey:@"message"];
        }
        
        [_storeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    } failure:^(NSError *error) {
        
        [self tipShow:@"加载数据失败"];
        NSLog(@"%@",error);
        
    }];
    
}
//门店点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _storeTableView) {
        
        CGRect cellRect = [_storeTableView rectForRowAtIndexPath:indexPath];
        _moveView.frame = CGRectMake(cellRect.origin.x, cellRect.origin.y  , cellRect.size.width + 0.5, cellRect.size.height);
    }
}
- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
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
