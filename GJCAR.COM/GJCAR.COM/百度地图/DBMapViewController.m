//
//  DBMapViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/5/25.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBMapViewController.h"

// 百度地图类库
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//#import <BaiduMapAPI_Base/BMKTypes.h>

//#import "BMKReverseGeoCodeOption"
#import "BMKAnnotationView.h"
#import "BMKAnnotation.h"
#import "BMKPointAnnotation.h"
#import "BMKPinAnnotationView.h"
#import "BMKLocationService.h"
#import "BMKSearchBase.h"
//

#import "BMKGeocodeSearch.h"

#import "BMKGeocodeSearchOption.h"

@interface DBMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate,CLLocationManagerDelegate>

{
    BMKReverseGeoCodeOption * _reverseGeoCodeOption ;
    
    
    
    BMKUserLocation *_userLocation;
    CLLocationManager * _locationManger;
    int curPage;
    int count;
    
    //搜索的城市
    NSString * searchCity;
    
}

//定位
@property (nonatomic,strong)BMKLocationService*locationService;

//搜索
@property (nonatomic,strong)BMKPoiSearch* poisearch;

@property (nonatomic,strong)BMKSuggestionSearch * suggesSeearch;
@property (nonatomic,strong)BMKSuggestionSearchOption * option;

//反向编码
@property (nonatomic,strong)BMKGeoCodeSearch * searcher;
@property (nonatomic,strong)BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
//显示反编码结果
@property (nonatomic,strong)UILabel* place;


@property (nonatomic,strong)UIImageView * centerView;

@end

@implementation DBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_mapView viewWillAppear];
    
    
    
//    [self setMapView];
    
    


    
    
}

#pragma mark - ***** 创建界面 *****



//主页面地图设置 从写init
-(instancetype)initMapViewWithFrame:(CGRect)frame{
    
    
    
    
    if (self = [super init])
    {
        self.mapView = [[BMKMapView alloc] initWithFrame:frame];
        [self.view addSubview:self.mapView];
    }
    
    [self checkLoaction];
    
    [self setLocationService];
    
    /* 设定代理 */
    self.mapView.delegate = self;
//    [self.view addSubview:self.mapView];
    
    
    [self.mapView setMapType:BMKMapTypeStandard];   // 地图类型
    //    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;  // 跟随模式
    //    self.mapView.zoomLevel = 10;    // 缩放比例
    [_mapView setZoomLevel:14];
    
    
    //创建定位按钮
    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(10, frame.size.height * 0.6, 40, 40);
    
    [self.mapView addSubview:_Button];
    
    //    [_mapView setCompassPosition:CGPointMake(180,200)];
    
    [_Button setImage:[UIImage imageNamed:@"localtion_btn@2x"] forState:UIControlStateNormal];
    [_Button addTarget:self action:@selector(locationButton) forControlEvents:UIControlEventTouchUpInside];


    return self;
}



-(instancetype)initMapViewNotLoactionWithFrame:(CGRect)frame {
    
    
    if (self = [super init])
    {
        self.mapView = [[BMKMapView alloc] initWithFrame:frame];
        [self.view addSubview:self.mapView];
    }

    /* 设定代理 */
    self.mapView.delegate = self;
    //    [self.view addSubview:self.mapView];
    
    [self.mapView setMapType:BMKMapTypeStandard];   // 地图类型
    //    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;  // 跟随模式
    //    self.mapView.zoomLevel = 10;    // 缩放比例
    [_mapView setZoomLevel:12];
    
    
    //创建定位按钮
    _Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Button.frame = CGRectMake(10, frame.size.height * 0.6, 40, 40);
    
    [self.mapView addSubview:_Button];
    
    //    [_mapView setCompassPosition:CGPointMake(180,200)];
    
//    [_Button setImage:[UIImage imageNamed:@"localtion_btn@2x"] forState:UIControlStateNormal];
//    [_Button addTarget:self action:@selector(locationButton) forControlEvents:UIControlEventTouchUpInside];
//    
//    
    _centerView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width / 2 - 6 , frame.size.height / 2 - 8, 12, 17)];
    [_mapView addSubview:_centerView];
    _centerView.image =[UIImage imageNamed:@"mapCenter"];
    

    
    return self;
}



//设置地图中心
-(void)setMapViewCenter:(NSString*)latitude and:(NSString*)longitude
{
    CLLocationCoordinate2D  coor = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    
    [_mapView setCenterCoordinate:coor animated:YES];
    
}


-(void)setStoreAnnotationWith:(NSDictionary*)dic
{


    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    
    NSLog(@"清除前地图标注的个数%ld",_mapView.annotations.count);
    
    
    [_mapView removeAnnotations:array];
    

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
   
    
    CLLocationCoordinate2D coor;
    
    coor.latitude = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"latitude"]] doubleValue];
    coor.longitude =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"longitude"]] doubleValue];
    annotation.coordinate = coor;    
    
    annotation.title = [dic objectForKey:@"storeName"];


    [_mapView setCenterCoordinate:coor animated:YES];
    

    [_mapView addAnnotation:annotation];
    
}

-(void)setplaceAnnotationWith:(NSDictionary*)dic
{
    
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    
    
    NSLog(@"清除前地图标注的个数%ld",_mapView.annotations.count);
    
    
    [_mapView removeAnnotations:array];
    
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    
    
    CLLocationCoordinate2D coor;
    
    coor.latitude = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"latitude"]] doubleValue];
    coor.longitude =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"longitude"]] doubleValue];
    annotation.coordinate = coor;
    
    
    [_mapView setCenterCoordinate:coor animated:YES];
    
    
    [_mapView addAnnotation:annotation];
    
}

#pragma mark - ***** 定位功能 *****


-(void)searchCitylatitude:(NSString * )latitude withlongitude:(NSString*)longitude
{
    CLLocationCoordinate2D coor;
    
    coor.latitude = [latitude doubleValue];
    coor.longitude =[longitude doubleValue];
    
    [_mapView setCenterCoordinate:coor animated:YES];
    

    //反编码
    [self searchCity];
}

#pragma mark ------定位当前城市
-(void)loactionCitylatitude:(NSString * )latitude withlongitude:(NSString*)longitude
{
    CLLocationCoordinate2D coor;
    
    coor.latitude = [latitude doubleValue];
    coor.longitude =[longitude doubleValue];
    
    
    
    [_mapView setCenterCoordinate:coor animated:YES];

}
#pragma mark - ----检查是否开启定位
-(void)checkLoaction
{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            _locationManger = [[CLLocationManager alloc] init];
            _locationManger.delegate = self;
            [_locationManger startUpdatingLocation];
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
    }
}

#pragma mark - ----设置定位相关代理
- (void)setLocationService {
    

    self.locationService = [[BMKLocationService alloc] init];
        /* 设定代理 */
        // 开启定位
    self.locationService.delegate = self;

    
    
    //跟随定位状态
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    _mapView.showsUserLocation = YES;
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    //    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    //    displayParam.locationViewImgName= @"icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    self.locationService.allowsBackgroundLocationUpdates = NO;
    self.locationService.pausesLocationUpdatesAutomatically = YES;
    
    [self.locationService startUserLocationService];
}


//大头针显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}



#pragma mark - ----开始定位
-(void)locationButton
{
    
//    [_mapView setZoomLevel:14];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;//显示定位图层
        [self.locationService startUserLocationService];
        
    });
    
}


#pragma mark - ----停止定位

-(void)stoplocation
{
    
    [self.locationService stopUserLocationService];


}


#pragma mark - ***** 反向编码定位城市 *****

-(void)searchCity
{
    
    
    
    
    if (_searcher == nil)
    {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];

    }

    
//
    _reverseGeoCodeOption.reverseGeoPoint = self.mapView.centerCoordinate;
  
    
    //反向编码代理
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    _reverseGeoCodeOption.reverseGeoPoint = self.mapView.centerCoordinate;
    //_userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:_reverseGeoCodeOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}


//获得定位城市
-(void)searchCity:(CLLocationCoordinate2D)pt
{
    //反向编码代理
    
    if (_searcher == nil)
    {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
        
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];

    }
    _reverseGeoCodeSearchOption.reverseGeoPoint =pt;
    //_userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:_reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}



//检索功能

-(void)searchInCity:(NSString *)city withWord:(NSString*)word
{
    if (_suggesSeearch == nil)
    {
        _suggesSeearch =[[BMKSuggestionSearch alloc]init];
        _option = [[BMKSuggestionSearchOption alloc]init];
        _suggesSeearch.delegate = self;
    }
    
    searchCity = city ;
    
    //初始化检索对象
    //发起检索
    
    //    option.pageIndex = curPage;
    //    option.pageCapacity = 10;
    
    _option.cityname = city;
    _option.keyword = word;
    
    BOOL flag = [_suggesSeearch suggestionSearch:_option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
    
}



#pragma mark - ***** 代理方法 *****



#pragma mark - ----定位代理
//定位代理
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    _userLocation = userLocation;
    
    //发送反编码
//    [self searchCity:userLocation.location.coordinate];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [_mapView updateLocationData:userLocation];
    
//    [self stoplocation];
    
    if ([self.index isEqualToString:@"main"])
    {

        [self searchCity:userLocation.location.coordinate];
        
    }
    else if ([self.index isEqualToString:@"place"])
    {
        [self searchCity];
    }

}



#pragma mark ---接收反向地理编码结果

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {

        
        NSLog(@"反向编码结果%@",[NSString stringWithFormat:@"%@",result.addressDetail.city]);
        
        
        
        NSDictionary * location = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%f",result.location.latitude],[NSString stringWithFormat:@"%f",result.location.longitude]] forKeys:@[@"latitude",@"longitude"]];
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjects:@[result.addressDetail.city,result.addressDetail.streetName,result.address,location] forKeys:@[@"city",@"streetName",@"address",@"location"]];
        //
        if ([self.index isEqualToString:@"main"])
        {
            
          
            if ([NSString stringWithFormat:@"%@",result.addressDetail.city]!=nil)
            {
                self.cityBlock(dic);
                
                [self stoplocation];
                
            }

        }
        
        else if ([self.index isEqualToString:@"place"])
        {
            
            self.progressBlock(@"stop");


            self.placeBlock(result.poiList,result.addressDetail.city);
            
            [self stoplocation];

            
//            if (result.poiList.count>0)
//            {
//                self.placeBlock(result.poiList,result.addressDetail.city);
//                
//                                [self stoplocation];
//            }
        }

    }
    
    else {
        
        NSLog(@"未找到结果");
    }
    
}


- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        for (NSString * name in result.cityList)
        {
            NSLog(@"搜索到的城市 %@   选择的城市%@",name,searchCity);
            
            
            if ([name isEqualToString:searchCity])
                
            {
                for (int i = 0; i < result.keyList.count; i ++)
                {
                    NSValue * a = result.ptList[i];
                    CLLocationCoordinate2D coor;
                    [a getValue:&coor];
                    
                    NSLog(@"name  %@   latitude %@   longitude%@",result.keyList[i],[NSString stringWithFormat:@"%f",coor.latitude],[NSString stringWithFormat:@"%f",coor.longitude]);
                    
                }
                
                
                self.searchSuggBlock(result.cityList,result.keyList,result.districtList,result.ptList,1);
                
            }
            
        }
        
        //        NSLog(@"&&&&&&&&&&&&&&&&&&%@",result.districtList[0]);
    }
    else {
        
        self.searchSuggBlock(@[],@[],@[],@[],0);
        NSLog(@"抱歉，未找到结果");
        
    }
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
//    [_mapView addOverlay:polygon];
//}



- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor colorWithRed:0.47 green:0.52 blue:0.98 alpha:1] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor colorWithRed:0.69 green:0.83 blue:1 alpha:1] colorWithAlphaComponent:0.4];
        polygonView.lineWidth = 2.0;
        
        return polygonView;
    }
    return nil;
}


#pragma mark ---移动地图加载完成调用

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([self.index isEqualToString:@"main"])
    {
        
    }
    else if ([self.index isEqualToString:@"place"])

    {

        self.progressBlock(@"start");
        
        [self searchCity];

    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationManger.delegate = self ;
    _locationService.delegate = self ;
    _searcher.delegate = self ;
    _suggesSeearch.delegate = self ;
    
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES] ;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationManger.delegate = nil ;
    _locationService.delegate = nil ;
    _searcher.delegate = nil ;
    _suggesSeearch.delegate = nil ; 
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
