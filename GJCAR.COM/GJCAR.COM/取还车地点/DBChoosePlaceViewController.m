//
//  DBChoosePlaceViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/17.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBChoosePlaceViewController.h"

//地图头文件
#import "DBMapViewController.h"

#import "DBPlaceTableViewCell.h"
//手动输入搜索页面
#import "DBPlaceSearchViewController.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface DBChoosePlaceViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    
}
//地图
@property (nonatomic,strong)DBMapViewController * MapViewC ;

//地点列表tableview
@property (nonatomic,strong)UITableView * placeTableView ;


@property ( nonatomic,strong)NSMutableArray * placeDataArray;

//搜索范围经纬度
@property (nonatomic,strong)NSArray * serveScopeArray;


//错误提示
@property (nonatomic,strong)UIView * tipView;
@property (nonatomic,strong)DBProgressAnimation * progress ;

@end

@implementation DBChoosePlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建导航栏
    [self setNavigation];
    
    
    //创建搜索栏
    [self setSearchView];
    
    //初始化地图
    [self setMapView];
    
    
    //初始化tableView
    [self setTableView];
    
    

}

#pragma mark 加载范围经纬度
-(void)loadSearchPoints
{
//    http://www.feeling.hpecar.com/api/serviceCity/view?cityId=13
    
    
    [self addProgress];
    
    _serveScopeArray = [NSArray array];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/serviceCity/view?cityId=%@",Host,[_takeCityInfoDic objectForKey:@"id"]];
    
    
    __weak typeof(self)weak_self = self;

    [DBNetworkTool Get:url parameters:nil success:^(id responseObject) {
        
        [self removeProgress];
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
            
        {

           weak_self.serveScopeArray  = [[responseObject objectForKey:@"message"]objectForKey:@"serveScope"];
          

            
        [self setSearchScope:weak_self.serveScopeArray];
            
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
#pragma mark 创建界面

#pragma mark ---创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"送车地址" withLeftBtImage:@"back" withRightImage:nil withRightTitle:@"确定" withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    

    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [nav.rightButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---创建搜索栏
-(void)setSearchView
{
    //灰色背景
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    baseView.backgroundColor = [UIColor colorWithRed:0.35 green:0.34 blue:0.35 alpha:1] ;
    [self.view addSubview:baseView];
 
    //搜索栏
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth - 20 , 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 3 ;
    
    [baseView addSubview:searchView];
    
    
    UIControl * searchC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, searchView.frame.size.width, searchView.frame.size.height)];
    
    [searchView addSubview:searchC];
    
    
    [searchC addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    
    
    //搜索汉字
    UILabel * searchLaber = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, searchView.frame.size.width-20, 30)];
    searchLaber.text = @"请输入地址" ;
    searchLaber.textAlignment = 1 ;
    searchLaber.textColor = [UIColor grayColor];
    searchLaber.font = [UIFont systemFontOfSize:14];
    
    
    [searchView addSubview:searchLaber];
    

}

#pragma mark ---初始化地图
-(void)setMapView
{
    

    _MapViewC = [[DBMapViewController alloc]initMapViewNotLoactionWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenHeight - 104) /2 )];
    
    _MapViewC.index = @"place";

    
    _MapViewC.view.frame = CGRectMake(0, 104, ScreenWidth, (ScreenHeight - 104) /2 );
    //    _MapViewC.mapView.frame = _MapViewC.view.frame ;
    
    [self addChildViewController:_MapViewC];
    [self.view addSubview:_MapViewC.view];

    
    if (self.coor.latitude != 0  )
    {
        [_MapViewC searchCitylatitude:[self.takeCityInfoDic objectForKey:@"latitude"]  withlongitude:[self.takeCityInfoDic objectForKey:@"longitude"]];

    }
    else{
        [_MapViewC searchCitylatitude:[self.takeCityInfoDic objectForKey:@"latitude"]  withlongitude:[self.takeCityInfoDic objectForKey:@"longitude"]];

    }
    
    
    __weak typeof(self)weak_self = self;
    _MapViewC.placeBlock = ^(NSArray * placeInfo,NSString * city)
    {
        
        [weak_self.tipView removeFromSuperview];
        
        weak_self.placeDataArray = [NSMutableArray array];
        
    
        [weak_self.tipView removeFromSuperview];
        
        
        if (placeInfo.count > 0 )
        {
            for (int i  = 0 ; i < placeInfo.count; i ++)
            {
                
                BMKPoiInfo  * poi = [placeInfo objectAtIndex:i];
                
                CLLocationCoordinate2D coor = poi.pt;
                
                //            NSLog(@"城市内检索        %@ %.6f %.6f",poi.name,coor.latitude,coor.longitude);
                
                
                NSLog(@"%@---%@",[NSString stringWithFormat:@"%@市",[weak_self.takeCityInfoDic objectForKey:@"cityName"]],city);
                
                
                if (weak_self.serveScopeArray.count >= 3)
                {
                    if ([weak_self isInCity:coor])
                    {
                        //创建储存信息的字典
                        NSMutableDictionary * placeInfoDic =[NSMutableDictionary dictionary];
                        
                        placeInfoDic[@"name"] = poi.name ;
                        
                        placeInfoDic[@"address"] = poi.address ;
                        
                        placeInfoDic[@"latitude"] =[NSString stringWithFormat:@"%f",coor.latitude] ;
                        
                        placeInfoDic[@"longitude"] =[NSString stringWithFormat:@"%f",coor.longitude] ;
                        
                        [weak_self.placeDataArray addObject:placeInfoDic];
                        
                    }
                    
                    else
                    {
                        [weak_self tipShow:@"您的定位点,已经超出取送车服务范围"];
                        weak_self.placeDataArray = [NSMutableArray array];
                        [weak_self.placeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        
                        return ;
                        
                    }
                    
                    
                }
                
                else{
                    [weak_self tipShow:@"您的定位点,已经超出取送车服务范围"];
                    return ;
                }
                
            }

        }
        else{
            [weak_self tipShow:@"您的定位点,已经超出取送车服务范围"];
            return ;

        }
        
        

//        [weak_self setSearchScope];

        
        [weak_self.placeTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        
        
    };
    
    
    
    _MapViewC.progressBlock = ^(NSString * progress)
    {
        if ([progress isEqualToString:@"start"])
        {
            
            
            
            [weak_self addProgress];
        }
        else if([progress isEqualToString:@"stop"])
        {
            
            [weak_self removeProgress];
        }
        
    };
    
    //加载搜索范围经纬度
//    [self loadSearchPoints];
    

}





//判断断续地点是否在范围内
-(BOOL)isInCity:(CLLocationCoordinate2D)coor;
{
    
    CLLocationCoordinate2D coords[30] = {0};
    
    if (_serveScopeArray.count >= 3)
    {
        for (int i = 0 ; i < _serveScopeArray.count; i ++)
        {
            
            coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
            coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
            
        }

    }
    
    
    CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
    BOOL isIn =  BMKPolygonContainsCoordinate(CLLocationCoordinate2DMake(coor.latitude, coor.longitude), coords,_serveScopeArray.count );
    
    
    
    
    return isIn;
    

}



//-(void)setSearchScope
//{
//    CLLocationCoordinate2D coords[3] = {0};
//    coords[0].latitude = 39;
//    coords[0].longitude = 116;
//    coords[1].latitude = 38;
//    coords[1].longitude = 115;
//    coords[2].latitude = 38;
//    coords[2].longitude = 117;
//    BMKPolygon* polygon = [BMKPolygon polygonWithCoordinates:coords count:3];
//    
//    [_MapViewC.mapView addOverlay:polygon];
//}

-(void)setSearchScope:(NSArray *)array
{
    
    CLLocationCoordinate2D coords[30] = {0};
    
    if (array.count >= 3)
    {
        for (int i = 0 ; i < _serveScopeArray.count; i ++)
        {
            coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
            coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
            
        }

    }
    
     BMKPolygon * polygon = [BMKPolygon polygonWithCoordinates:coords count:_serveScopeArray.count];
    [_MapViewC.mapView addOverlay:polygon];
 
}


#pragma mark ---搜索点击创建搜索栏

-(void)searchView
{
    DBPlaceSearchViewController * search = [[DBPlaceSearchViewController alloc]init];
    
    search.takeCityInfoDic = self.takeCityInfoDic ;
    
    
    
    [self.tipView removeFromSuperview];
    __weak typeof(self)weak_self = self ;
    
    search.placeBlock = ^ (NSDictionary * placeDic)
    {
       
        weak_self.placeChooseBlock(placeDic,weak_self.index);
        
        [weak_self.navigationController popViewControllerAnimated:YES];

    } ;
    
    
    if (weak_self.serveScopeArray.count>= 3)
    {
        search.serveScopeArray = weak_self.serveScopeArray ;
        
        [self.navigationController pushViewController:search animated:YES];

    }
    else{
        [weak_self tipShow:@"您的定位点,已经超出取送车服务范围"];
    }
    
    
}


#pragma mark ---初始化tableView
-(void)setTableView
{
    _placeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_MapViewC.view.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(_MapViewC.view.frame))];
    _placeTableView.delegate = self ;
    _placeTableView.dataSource = self ;
    
    _placeTableView.showsVerticalScrollIndicator = NO;
    _placeTableView.showsHorizontalScrollIndicator = NO;
    _placeTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_placeTableView];
    
}


#pragma mark ---UItableViewDelegate



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _placeDataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 35 ;
    return _placeTableView.frame.size.height/5 ;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBPlaceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    if (cell == nil )
    {
        cell = [[DBPlaceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeCell"];
    }
    
    
    cell.title.text  = [_placeDataArray[indexPath.row]objectForKey:@"name"] ;
    cell.subTitle.text = [_placeDataArray[indexPath.row]objectForKey:@"address"] ;
    
    
    cell.subTitle.textColor = [UIColor blackColor];
    cell.title.textColor = [UIColor blackColor];
    
    if (indexPath.row == 0)
    {
        NSLog(@"%@", cell.title.text);

        cell.title.textColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
        cell.subTitle.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    }
    
    
    
    cell.selectionStyle = 0 ;
    return cell ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    self.placeChooseBlock(_placeDataArray[indexPath.row],self.index);
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)submit
{
    
    [self.tipView removeFromSuperview];
    if (_placeDataArray.count > 0)
    {
        self.placeChooseBlock(_placeDataArray[0],self.index);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self tipShow:@"请选择有效地点"];
    }
    
    
}

-(void)back
{

    [self.navigationController popViewControllerAnimated:YES];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
//    [self addChildViewController:_MapViewC];
//    [self.view addSubview:_MapViewC.view];
//    
//    
    
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"取还车地点选择页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"取还车地点选择页面"];
}


- (void)tipShow:(NSString *)str
{

    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];

}

-(void)dealloc
{
    
    NSLog(@"DBChoosePlaceViewController  free");
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
