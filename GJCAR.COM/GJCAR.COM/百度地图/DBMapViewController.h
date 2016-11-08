//
//  DBMapViewController.h
//  GJCAR.COM
//
//  Created by 段博 on 16/5/25.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//


//反编码Block
typedef void (^PlaceBlock) (NSArray * placeArray,NSString * city);

//反编码Block 城市
typedef void (^CityBlock) (NSDictionary * city);


//建议查询
typedef void (^SearchSuggBlock)(NSArray * cityArray,NSArray * nameArray,NSArray * AddArray ,NSArray * array,NSInteger index);

//加载回调
typedef void (^ProgressBlock)(NSString * progress);


@interface DBMapViewController : UIViewController



//判断哪个页面调用
@property (nonatomic,strong) NSString * index;

//地图
@property (nonatomic,strong)BMKMapView * mapView;
//定位按钮
@property (nonatomic,strong) UIButton * Button;


@property (nonatomic,strong)PlaceBlock placeBlock ;
@property (nonatomic,strong)CityBlock cityBlock ;
//建议查询
@property (nonatomic,strong)SearchSuggBlock searchSuggBlock;

@property (nonatomic,strong)ProgressBlock progressBlock ;


-(instancetype)initMapViewWithFrame:(CGRect)frame;
-(instancetype)initMapViewNotLoactionWithFrame:(CGRect)frame;

//手动输入查询取车地址
-(void)searchInCity:(NSString *)city withWord:(NSString*)word;

//反编码到当前城市
-(void)searchCitylatitude:(NSString * )latitude withlongitude:(NSString*)longitude;
//定位到当前城市
-(void)loactionCitylatitude:(NSString * )latitude withlongitude:(NSString*)longitude;
-(void)searchCity;

//设置地图中心

//门店坐标

-(void)setStoreAnnotationWith:(NSDictionary*)dic;
-(void)setMapViewCenter:(NSString*)latitude and:(NSString*)longitude;
//创建搜索范围
//-(void)setSearchScope;
@end
