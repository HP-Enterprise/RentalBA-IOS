//
//  DBCityListViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/8.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCityListViewController.h"

#import "DBHotCityTableViewCell.h"

#import "DBCityStoreViewController.h"

@interface DBCityListViewController ()<UITableViewDelegate,UITableViewDataSource>


{
    //最多展示3个
    NSArray * historyCity ;
}
//搜索框
@property (nonatomic,strong)DBTextField * searchFiled;

//城市列表
@property (nonatomic,strong)UITableView * cityTableView;
//数据
@property (nonatomic,strong)NSArray * dataArray ;

//城市标签
@property (nonatomic,strong)NSMutableArray * indexArray;

//全部城市数据
@property (nonatomic,strong)NSArray * citysArray;
//热门城市
@property (nonatomic,strong)NSArray * hotCitysArray;



@property (nonatomic,strong)DBProgressAnimation * progress ;

@property(nonatomic,strong)UIView * tipView ;
@end

@implementation DBCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavigation];
    
    
    //创建搜索页面
    [self setSearchView];
    

    //加载城市数据
    [self loadCityData];
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

#pragma mark ---加载所有城市数据
-(void)loadCityData
{
    _dataArray = [NSArray array];
    _hotCitysArray = [NSArray array];
    
    _indexArray = [NSMutableArray array];
    
   
    NSString  * url ;

    
    switch (_indexKind)
    {
            //加载自驾城市列表
        case 0:
            url =[NSString stringWithFormat:@"%@/api/china/cityHasStore?isHot=",Host];

            break;
        case 1:
            url =[NSString stringWithFormat:@"%@/api/china/cityHasStore?isHot=",Host];
            
            break;
            
            //加载顺风车城市列表
        case 2:
        {
            if ([self.index isEqualToString:@"return"])
            {
                
                url =[NSString stringWithFormat:@"%@/api/freeRide/returnCarCity?getCarCityId=%@",Host,_cityId];

            }
            else
            {
                url =[NSString stringWithFormat:@"%@/api/freeRide/getTakeCarCity",Host];

            }
        }
            break;
        case 3:
            url =[NSString stringWithFormat:@"%@/api/china/city",Host];
            
            break;
            
        default:
            break;
    }
    
    
    //加载顺风车城市
    
    
    __weak typeof(self)weak_self = self;
    
    [self addProgress];
    
    
    
    
    [DBNetworkTool getAllCitysGET:url parameters:nil success:^(id responseObject) {

        [weak_self removeProgress];
        
        

        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {

            if (![[responseObject objectForKey:@"message"] isKindOfClass:[NSNull class]])
            {
                weak_self.dataArray = [responseObject objectForKey:@"message"];

                if (weak_self.dataArray.count > 0 )
                {
                    [weak_self loadHotCity];
                }
                else if (weak_self.dataArray.count == 0)
                {
                    [self tipShow:@"没有相关数据"];
                    NSLog(@"没有数据");
                }
   
            }
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
        [self tipShow:@"加载数据失败"];        
        [weak_self removeProgress];
        

    }];
    
    
    
}

-(void)loadHotCity{
    
    NSString *  url =[NSString stringWithFormat:@"%@/api/china/cityHasStore?isHot=1",Host];

    __weak typeof(self)weak_self = self;

    [DBNetworkTool getAllCitysGET:url parameters:nil success:^(id responseObject) {
        
        [weak_self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {
            
            if (![[responseObject objectForKey:@"message"] isKindOfClass:[NSNull class]])
            {
                weak_self.hotCitysArray = [responseObject objectForKey:@"message"];
                
            }
            else{
                weak_self.hotCitysArray = _dataArray ;
                    
            }
                
            //处理数据
            [weak_self compareDataWithArray:[NSMutableArray arrayWithArray:weak_self.dataArray]];
            
            [weak_self.cityTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }

        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
        [self tipShow:@"加载数据失败"];
        [weak_self removeProgress];
        
        
    }];
    
    

}
#pragma mark ---处理城市数据
//排序 去重
-(void)compareDataWithArray:(NSMutableArray *)array;

{
    
    
    NSMutableArray * nameArray = [NSMutableArray arrayWithArray:array];
    //    nameArray = _dataArray ;
    //
    NSString * str1;
    NSString * str2;
    for (int i = 0 ; i < nameArray.count - 1; i ++)
    {
        for (int j = i+ 1; j < nameArray.count;  j ++)
        {
             str1 = [nameArray[i]objectForKey:@"belong"];
             str2 =[nameArray[j]objectForKey:@"belong"];
            
            if (str1 > str2)
            {
                [nameArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                
            }
            else if (str1 == str2)
            {
                [nameArray removeObject:nameArray[i]];
                
                
                [self compareDataWithArray:nameArray];
                
                return ;
            }
            
        }
    }
    
    
    
    
    [self createNewData:nameArray];
    
}


//创建新数组  按字母排序 处理重复
-(void)createNewData:(NSMutableArray*)nameArray
{
    
    
    NSMutableArray * newDataArray= [NSMutableArray array];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    
    
    int count ;
    
    if ([user objectForKey:@"historyCity"])count = 1 ;
    else{
        count = 0 ;
    }

    for (int i = 0;  i < nameArray.count + 1 + count ; i ++)
    {
        NSMutableArray * subArray = [NSMutableArray array];
        
        [newDataArray addObject:subArray];
        
        if (count == 0)
        {
  
            if ( i == 0) [_indexArray addObject:@"热门"];
            else{
                
                [_indexArray addObject:[nameArray[i-1]objectForKey:@"belong"]];
                
            }
        }
        else{
            
           
            if ( i == 0) [_indexArray addObject:@"历史"];
            else if (i == 1) [_indexArray addObject:@"热门"];
            else [_indexArray addObject:[nameArray[i-2]objectForKey:@"belong"]];

        }

        
        for (int j = 0 ; j < _dataArray.count ; j ++)
        {
            //如果数据里边找到和索引相同的字符就找到新数组
          
            if (count == 0)
            {
                
                if ( i == 0)
                {
                    for (NSDictionary * dic in _hotCitysArray) {
                        [newDataArray[i] addObject:dic];

                    }

                    break ;

                }
                else{

                    if ([[_dataArray[j]objectForKey:@"belong"]isEqualToString:_indexArray[i]])
                    {
                        [newDataArray[i]addObject:_dataArray[j]];
                    }
                }
            }
            else{
                

                if ( i == 0) [newDataArray[i] addObject:[user objectForKey:@"historyCity"]];
                else if (i == 1) [newDataArray[i] addObject:_hotCitysArray];
                else
                {
                    if ([[_dataArray[j]objectForKey:@"belong"]isEqualToString:_indexArray[i]])
                    {
                        [newDataArray[i]addObject:_dataArray[j]];
                    }
                }
     
            }

    
        }

        
    }

    

    
    
    
    _dataArray = newDataArray ;
    
    
    
    
    
}







#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"选择城市" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    

    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark --创建搜索页面
-(void)setSearchView
{
//    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
//    [self.view addSubview:baseView];
//    baseView.backgroundColor = [UIColor colorWithRed:0.35 green:0.34 blue:0.35 alpha:1] ;
//
//    
//    
//    _searchFiled = [[DBTextField alloc]initWithFrame:CGRectMake(60, 5, ScreenWidth-120, 30) withLeftImage:nil withButtonImage:nil withButtonHighImage:nil];
//    
//    _searchFiled.field.frame = CGRectMake(15, 2 , _searchFiled.frame.size.width-15, 30);
//    
//  
//    [baseView addSubview:_searchFiled];
//
//    _searchFiled.layer.cornerRadius = 3;
//    _searchFiled.backgroundColor = [UIColor whiteColor];
//    _searchFiled.field.placeholder = @"请输入城市";
//    [_searchFiled.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
//    [_searchFiled.field setValue:[UIFont systemFontOfSize:14 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
//    
//    _searchFiled.field.keyboardType = UIKeyboardTypeNamePhonePad;
//    _searchFiled.field.clearButtonMode = 0;
//    
////    _searchFiled.field.secureTextEntry = NO;
//
    CGRect frame = CGRectMake(0, 0, ScreenWidth, 64);

    [self setHotCityWithframe:frame];

}


#pragma mark --创建热门 定位 页面
-(void)setHotCityWithframe:(CGRect)frame
{
    
    //当前定位城市
    UIView * location = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, 20)];
    location.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1] ;
    [self.view addSubview:location];
    
    //定位图片
    UIImageView * locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 4, 10, 12)];
    locationImage.image = [UIImage imageNamed:@"mapCenter"];
    [location addSubview:locationImage];
    
    
    UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationImage.frame)+5, 0, ScreenWidth - CGRectGetMaxX(locationImage.frame), 20)];
    locationLabel.text = @"当前定位城市";
    locationLabel.font = [UIFont systemFontOfSize:10];
    locationLabel.textColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1] ;
    [location addSubview:locationLabel];
    
    
    
    UIView * upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    upLineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] ;
    [location addSubview:upLineView];

    
    UIView * downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, ScreenWidth, 0.5)];
    downLineView.backgroundColor =[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] ;
    [location addSubview:downLineView];
    
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    //手机定位城市
    UILabel * locationCity = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(location.frame), ScreenWidth-20, 30)];
    
    
    if ([user objectForKey:@"locationCity"]!= nil)
    {
        locationCity.text = [user objectForKey:@"locationCity"];

    }
    else
    {
        locationCity.text = @"定位失败" ;
    }
    //    locationCity.textColor =
    locationCity.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:locationCity];
    

    [self setTableView:locationCity.frame];
    
//    //热门城市
//    UIView * hotCity = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(locationCity.frame), ScreenWidth, 20)];
//    hotCity.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1] ;
//    [self.view addSubview:hotCity];
//    
//    UILabel * hotCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth - CGRectGetMaxX(locationImage.frame), 20)];
//    hotCityLabel.text = @"热门城市";
//    hotCityLabel.font = [UIFont systemFontOfSize:10];
//    hotCityLabel.textColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1] ;
//    [hotCity addSubview:hotCityLabel];
//    
//    
//    UIView * upLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    upLineView1.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] ;
//    [hotCity addSubview:upLineView1];
//    
//    
//    UIView * downLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, ScreenWidth, 0.5)];
//    downLineView1.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]  ;
//    [hotCity addSubview:downLineView1];
//
//    
//    
//    //创建城市
//    for (int i = 0 ; i < 5; i ++)
//    {
//        for (int j = 0 ; j < 3 ; j ++)
//        {
//            UIButton * button = [ UIButton buttonWithType:UIButtonTypeCustom];
//            
//            button.frame = CGRectMake(10 + j *( 30 +(ScreenWidth - 80 )/3), CGRectGetMaxY(hotCity.frame)+ 15 + i * 45, (ScreenWidth - 80 )/3, 30);
//            [button setTitle:@"城市" forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            
//            button.layer.borderWidth = 0.5 ;
//            button.layer.borderColor= [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor ;
//            
//            button.layer.cornerRadius = 3;
//            
//            button.tag = 200 + i * 3 + j ;
//            [button addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:button];
//            
//
//            
//            if (i * 3 + j == 14)
//            {
//                CGRect frame = button.frame ;
//                
//                [self setTableView:frame];
//                
//                
//            }
//        }
//    }
    
}


#pragma mark --创建城市列表tableview 页面
-(void)setTableView:(CGRect)frame
{
    _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(frame) - 15 )];
  
    
    [self.view addSubview:_cityTableView];
    
    _cityTableView.dataSource = self ;
    _cityTableView.delegate = self ;
    _cityTableView.showsVerticalScrollIndicator = NO ;
    _cityTableView.showsHorizontalScrollIndicator = NO ;
    _cityTableView.tableFooterView = [[ UITableView alloc]initWithFrame:CGRectZero];
    _cityTableView.sectionIndexColor =  [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1] ;

}





#pragma mark --tableViewDelegate
//右边索引 字节数(如果不实现 就不显示右侧索引)
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return _indexArray;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    

    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];

    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    NSInteger count ;
    
    if ([user objectForKey:@"historyCity"]) count = 1 ;
    else{
        count = 0 ;
    }
    

    if (count == 0)
    {
        if (section == 0)
        {
            [self createHotCity:headView withTitle:@"热门城市"];
            return headView;
        }

        else if(section != 0)
        {
            
            //标题背景
            UIView *biaotiView = [[UIView alloc]init];
            biaotiView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
            biaotiView.frame=CGRectMake(0, 0, ScreenWidth, 20);
            [headView addSubview:biaotiView];
            
            //标题文字
            UILabel *lblBiaoti = [[UILabel alloc]init];
            
            lblBiaoti.textAlignment = NSTextAlignmentLeft;
            lblBiaoti.font = [UIFont systemFontOfSize:14];
            lblBiaoti.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.35 alpha:1] ;
            lblBiaoti.frame = CGRectMake(15,0, ScreenWidth-15, 20);
            lblBiaoti.text = _indexArray[section];
            [headView addSubview:lblBiaoti];
            
        }


    }
    
    else{
        
        if (section == 0) {
            [self createHotCity:headView withTitle:@"历史"];
            
            return headView;
        }
        
        else if (section == 1)
        {
            [self createHotCity:headView withTitle:@"热门城市"];
            
            return headView;
            
        }
        else if(section >1)
        {
            
            //标题背景
            UIView *biaotiView = [[UIView alloc]init];
            biaotiView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
            biaotiView.frame=CGRectMake(0, 0, ScreenWidth, 20);
            [headView addSubview:biaotiView];
            
            //标题文字
            UILabel *lblBiaoti = [[UILabel alloc]init];
            
            lblBiaoti.textAlignment = NSTextAlignmentLeft;
            lblBiaoti.font = [UIFont systemFontOfSize:12];
            lblBiaoti.textColor = [DBcommonUtils getColor:@"1b8cce"];
            lblBiaoti.frame = CGRectMake(15,0, ScreenWidth-15, 20);
            lblBiaoti.text = _indexArray[section];
            [headView addSubview:lblBiaoti];
            
        }

        
    }
    

     return headView;
}




//标签数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArray.count;
}


// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 20;
}


//点击右侧索引表项时调用
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    NSString *key = [_indexArray objectAtIndex:index];
    NSLog(@"sectionForSectionIndexTitle key=%@",key);
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    return index;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];

    NSInteger count ;

    if ([user objectForKey:@"historyCity"]) {

        if (indexPath.section == 0)
        {
            return 50 ;
        }
        else if (indexPath.section ==1)
        {
            if ([NSArray arrayWithArray:_dataArray[indexPath.section]].count%3 == 0)
            {
                count =  [NSArray arrayWithArray:_dataArray[indexPath.section]].count/3;
            }
            else{
                count = [NSArray arrayWithArray:_dataArray[indexPath.section]].count/3 + 1 ;
            }

            return 30 + 30 * count + 15 * (count - 1);
         }

    }
    else{

        if (indexPath.section == 0)
        {

            if ([NSArray arrayWithArray:_dataArray[0]].count%3 == 0)
            {
                count =  [NSArray arrayWithArray:_dataArray[0]].count/3;
            }
            else{
                count = [NSArray arrayWithArray:_dataArray[0]].count/3 + 1 ;   
            
            }
            return 30 + 30 * count + 15 * (count - 1);
        }
        
        return 40 ;

    }

    
    return 40 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
  
    if ([user objectForKey:@"historyCity"]) {
        
        if (section == 0  || section == 1)

            return 1 ;
        
    }
    else{
        
        
        
        if (section == 0)
        return 1;
        
        
        
        
        else return [NSArray arrayWithArray:_dataArray[section]].count;

        
    }

    return [NSArray arrayWithArray:_dataArray[section]].count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    if (indexPath.section == 0)
    {
        
        
        
        DBHotCityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HotCityCell"];
        if (cell == nil)
        {
            

            cell = [[DBHotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotCityCell" withNumber:[NSArray arrayWithArray:_dataArray[0]].count];
        }

        [cell config:_dataArray[indexPath.section]];
        cell.selectionStyle = 0 ;
        
        __weak typeof(self)weak_self = self ;
        cell.cityCilickBlock = ^(NSInteger index)
        {
            
            weak_self.cityChooseBlock(weak_self.dataArray[indexPath.section][index],weak_self.index);
           
//            [weak_self addHistoryCity:_dataArray[indexPath.section][index]];
            [weak_self.navigationController popViewControllerAnimated:YES];
        };
        return cell;
    }

    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
    }
    if (_dataArray.count > 0 )
    {
        cell.textLabel.text = [_dataArray[indexPath.section][indexPath.row]objectForKey:@"cityName"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.selectionStyle = 0 ;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
 
    if ([user objectForKey:@"historyCity"]) {
        
        if (indexPath.section > 1)
        {
            self.cityChooseBlock(_dataArray[indexPath.section][indexPath.row],self.index);
            
            [self addHistoryCity:_dataArray[indexPath.section][indexPath.row]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }

    }
    else{
       
        
        if (indexPath.section > 0)
        {

            self.cityChooseBlock(_dataArray[indexPath.section][indexPath.row],self.index);
            
//            [self addHistoryCity:_dataArray[indexPath.section][indexPath.row]];
        
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }
    

    
}
#pragma mark 私有方法

//热门城市 标题类型
-(void)createHotCity:(UIView*)headView withTitle:(NSString*)title
{
    

    
    UIView * hotCity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    hotCity.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
    [headView addSubview:hotCity];
    
    UILabel * hotCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth -20 , 20)];
    hotCityLabel.text = title;
    hotCityLabel.font = [UIFont systemFontOfSize:11];
    hotCityLabel.textColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1] ;
    [hotCity addSubview:hotCityLabel];
    
    
//    UIView * upLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    upLineView1.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] ;
//    [hotCity addSubview:upLineView1];
//    
//    
//    UIView * downLineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 19.5, ScreenWidth, 0.5)];
//    downLineView1.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]  ;
//    [hotCity addSubview:downLineView1];
}



//添加历史城市

-(void)addHistoryCity:(NSDictionary * )dic
{
    
    
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//    
//    NSMutableArray * cityArrays =[NSMutableArray arrayWithArray:[user objectForKey:@"historyCity"]];
//    
//    if (cityArrays.count < 3)
//    {
//        [cityArrays insertObject:dic atIndex:0];
//    }
//    else if(cityArrays.count == 3)
//    {
//        [cityArrays removeLastObject];
//        [cityArrays insertObject:dic atIndex:0];
//
//    }
//
//    [user setObject:[NSArray arrayWithArray:cityArrays] forKey:@"historyCity"];
}


-(void)cityClick:(UIButton*)button
{
    NSLog(@"%ld",button.tag - 200);
    
}


-(void)back
{
    

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];

    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    
//    [super viewWillDisappear:YES];
//    
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
//    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
//    
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"城市选择页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"城市选择页面"];
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
