//
//  DBCityStoreViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCityStoreViewController.h"

//商圈门店选择页面
#import "DBStoreListTableViewCell.h"

#import "DBCarListViewController.h"

@interface DBCityStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

//搜索框
@property (nonatomic,strong)DBTextField * searchFiled;
@property (nonatomic,strong)UIView  * tipView;

//门店tableView
@property (nonatomic,strong)UITableView * storeTableView;
//门店数据
@property (nonatomic,strong)NSArray * storeArray ;


@end

@implementation DBCityStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigation];
    
    
    //创建搜索页面
    [self setSearchView];
    
    //加载门店数据
    [self loadStoreData];
    
}


#pragma mark 加载数据
#pragma mark ---家在门店数据
-(void)loadStoreData
{
    

    _storeArray = [NSArray array];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/china/province/city/%@/store?available=1",Host,self.cityId];
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
       
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"])
        {
            _storeArray = [responseObject objectForKey:@"message"];
        }
        
        [_storeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
     
        
    } failure:^(NSError *error) {
        
        [self tipShow:@"加载数据失败"];
        NSLog(@"%@",error);
        
    }];

}

#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"选择门店" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --创建搜索页面
-(void)setSearchView
{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    [self.view addSubview:baseView];
    baseView.backgroundColor = [UIColor colorWithRed:0.35 green:0.34 blue:0.35 alpha:1] ;
    
//    _searchFiled = [[DBTextField alloc]initWithFrame:CGRectMake(60, 5, ScreenWidth-120, 30) withLeftImage:nil withButtonImage:nil withButtonHighImage:nil];
//    
//    _searchFiled.field.frame = CGRectMake(15, 2 , _searchFiled.frame.size.width-15, 30);
//    
//    [baseView addSubview:_searchFiled];
//    
//    _searchFiled.layer.cornerRadius = 3;
//    _searchFiled.backgroundColor = [UIColor whiteColor];
//    _searchFiled.field.placeholder = @"输入地址搜索周边门店";
//    [_searchFiled.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
//    [_searchFiled.field setValue:[UIFont systemFontOfSize:14 ] forKeyPath:@"_placeholderLabel.font"];
//    
//    _searchFiled.field.keyboardType = UIKeyboardTypeNamePhonePad;
//    _searchFiled.field.clearButtonMode = 0;
//    
//
    
    //创建门店tableview
    [self createStoreTableView:baseView.frame];
    
}


#pragma mark --创建门店tableview
-(void)createStoreTableView:(CGRect)frame
{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 30)];
    
    [self.view addSubview:baseView];
    
    baseView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1] ;
    
    
    

    //定位图片
    UIImageView * locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 10, 12)];
    locationImage.image = [UIImage imageNamed:@"mapCenter"];
    [baseView addSubview:locationImage];
    
    
    UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame)+5, 0, ScreenWidth - CGRectGetMaxX(locationImage.frame), 30)];
    locationLabel.text = self.cityName;
    locationLabel.font = [UIFont systemFontOfSize:12];
    locationLabel.textColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1] ;
    [baseView addSubview:locationLabel];

    
    
    
    _storeTableView= [[UITableView alloc]initWithFrame:CGRectMake( 0 , CGRectGetMaxY(baseView.frame), ScreenWidth, ScreenHeight -150) style:UITableViewStylePlain];
    
    _storeTableView.showsVerticalScrollIndicator = NO ;
    _storeTableView.showsHorizontalScrollIndicator = NO ;
    _storeTableView.delegate = self ;
    _storeTableView.dataSource = self ;
    _storeTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_storeTableView];
    _storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
}

//cell高度设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50 ;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

//    return 10;
    return _storeArray.count;
}


//商圈门店赋值
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    DBStoreListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    
    if (cell == nil)
    {
        cell = [[DBStoreListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"storeCell"];
    }

    
    
    
    cell.storeName.text = [_storeArray[indexPath.row]objectForKey:@"storeName"];
    cell.storeAddr.text = [_storeArray[indexPath.row]objectForKey:@"detailAddress"];
    
    cell.selectionStyle = 0 ;
    return cell ;

}


//门店点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tipView removeFromSuperview];
    
    
    
    if ([[_storeArray[indexPath.row] objectForKey:@"latitude"]isKindOfClass:[NSNull class]]|| [_storeArray[indexPath.row] objectForKey:@"latitude"] ==nil)
    {
        
        [self tipShow:@"数据错误"];
        
    }
    else
    {
        
        
        
        self.storeChooseBlock(_storeArray[indexPath.row],self.index);
        
        
        [self.navigationController popViewControllerAnimated:YES];

    }
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"门店选择页面"];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"门店选择页面"];
}

- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
