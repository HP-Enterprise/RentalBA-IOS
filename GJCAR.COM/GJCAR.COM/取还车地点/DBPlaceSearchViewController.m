//
//  DBPlaceSearchViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/1.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBPlaceSearchViewController.h"

#import "DBMapViewController.h"

#import "DBCityTableViewCell.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface DBPlaceSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)DBTextField * searchFiled;

@property (nonatomic,strong)DBMapViewController * MapViewC ;

@property (nonatomic,strong)UIView * tipView;

@property (nonatomic,strong)UITableView * tableView ;

//地址数组 包含街道名 经纬度 地址名
@property (nonatomic,strong)NSMutableArray * addrArray;

@property (nonatomic,strong)UILabel * searchNull;

@property (nonatomic,strong)NSString * city ;


@end

@implementation DBPlaceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    [self setSearchView];
    
    [self setTableView];
    
    [self setMap];
    

    
}



//设置地图
-(void)setMap
{
    _MapViewC  =[[DBMapViewController alloc]init];
    [self addChildViewController:_MapViewC];
    
    
    _addrArray = [NSMutableArray array];
    
    
    //   [_MapViewC searchInCity:self.city withWord:@"guang gu"];
    
    //没有搜索到结果提示无结果
    
    _searchNull = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 20)];
    
    [self.view addSubview:_searchNull];
    _searchNull.font = [UIFont systemFontOfSize:12];
    _searchNull.textAlignment = 1;
    
    
    __weak typeof(self)weak_self = self;
    
    
    
    //设置搜索范围
//    [self setSearchScope:self.serveScopeArray];

    
    _MapViewC.searchSuggBlock = ^(NSArray * cityArray, NSArray * nameArray, NSArray * disArray , NSArray * array, NSInteger index)
    {

        [weak_self.tipView removeFromSuperview];
            
            weak_self.searchNull.text = @"";
            
            _addrArray = [NSMutableArray array];
            
            for (int i = 0; i < array.count; i++) {
                
                
                NSValue * a = array[i];
                CLLocationCoordinate2D coor;
                [a getValue:&coor];
                //
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                
                dic[@"name"] = nameArray[i];
                dic[@"address"] = disArray[i];
                
                
                
                NSLog(@" nameArray %@",nameArray[i]);
                NSLog(@" disArray  %@",disArray[i]);
                

                if ([cityArray[i]isEqualToString:[NSString stringWithFormat:@"%@市",[weak_self.takeCityInfoDic objectForKey:@"cityName"]]])
                {
                    
                    dic[@"latitude"] = [NSString stringWithFormat:@"%lf",coor.latitude];
                    dic[@"longitude"] = [NSString stringWithFormat:@"%lf",coor.longitude];
                    
             
                    
                    
                    [weak_self.addrArray addObject:dic];

                }
                
                else
                {
                    weak_self.addrArray = [NSMutableArray array];
                    
                    [weak_self tipShow:@"当前地址超出服务范围"];
                    
                    
                    
                    [weak_self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

                    return ;
                    
                }

                
            }
        
        
    
            [weak_self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        
        
    };
    
    
    
    
}


//判断断续地点是否在范围内
-(BOOL)isInCity:(CLLocationCoordinate2D)coor;
{
    
    
    
    
    CLLocationCoordinate2D coords[30] = {0};
    
    if (_serveScopeArray.count > 0)
    {
        for (int i = 0 ; i < _serveScopeArray.count; i ++)
        {
            
            coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
            coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
            
        }
        
    }
    
    
    CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
    
    
    
    
    
    BOOL isIn =  BMKPolygonContainsCoordinate(CLLocationCoordinate2DMake(coor.latitude, coor.longitude), coords,  _serveScopeArray.count);
    
    
    
    
    return isIn;
    
    
}


//-(void)setSearchScope:(NSArray *)array
//{
//    
//    CLLocationCoordinate2D coords[30] = {0};
//    
//    
//    for (int i = 0 ; i < _serveScopeArray.count; i ++)
//    {
//        
//        
//        
//        coords[i].latitude =[[_serveScopeArray[i]objectForKey:@"lat"]doubleValue];
//        coords[i].longitude =[[_serveScopeArray[i]objectForKey:@"lng"]doubleValue];
//        
//    }
//    
//    
//    BMKPolygon* polygon = [BMKPolygon polygonWithCoordinates:coords count:5];
//    
//    
//    
//    [_MapViewC.mapView addOverlay:polygon];
//}


-(void)setSearchView
{
    
    
    self.city =[NSString stringWithFormat:@"%@市",[self.takeCityInfoDic objectForKey:@"cityName"]];
    
    
    //灰色背景
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    baseView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] ;
    [self.view addSubview:baseView];
    
    
    //账号输入框
    _searchFiled = [[DBTextField alloc]initWithFrame:CGRectMake(25, 27, ScreenWidth-100, 30)withImage:nil];
    _searchFiled.layer.cornerRadius = 5;
    //    userNameField.layer.borderWidth = 1;
    //    userNameField.layer.borderColor =[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor;
   
    //添加事件
    [_searchFiled.field addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    _searchFiled.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.97 alpha:1];
    _searchFiled.field.placeholder = @"请输入地址";

    [_searchFiled.field setValue:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [_searchFiled.field setValue:[UIFont systemFontOfSize:15 / 320.0 *ScreenWidth] forKeyPath:@"_placeholderLabel.font"];
    
    _searchFiled.field.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:_searchFiled];

    
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(CGRectGetMaxX(_searchFiled.frame)+20, 0, 40, 44);
    [baseView addSubview:cancel];
    
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelBt) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)setTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 64, ScreenWidth, ScreenHeight - 64) ];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];

}

//检测搜索框输入的字符
-(void)textFieldDidChange
{
    NSString *strUrl = [_searchFiled.field.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSLog(@"%@****************%@",self.city,strUrl);
    
    
//    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    [_MapViewC searchInCity:self.city withWord:strUrl];

    
//    if ([pred evaluateWithObject: strUrl]) {
//
//        [_MapViewC searchInCity:self.city withWord:strUrl];
//        
//        NSLog(@"输入汉字了");
//    }
    
    
}

////检测textField输入字符数量

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    
//    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
//    
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
//    
//    if (_searchFiled.field == textField)  //判断是否时我们想要限定的那个输入框
//    {
//        
//
//        [_MapViewC searchInCity:self.city withWord:toBeString];
//        
//    }
//    return YES;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    return _addrArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50;
}




-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DBCityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TradeAreaCll"];
    if (cell == nil)
    {
        cell = [[DBCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TradeAreaCll"];
    }


    if (_addrArray.count>0)
    {
        
        cell.city.text = [_addrArray[indexPath.row]objectForKey:@"name"];
        
        
        
        cell.addr.text =[NSString stringWithFormat:@"%@",[_addrArray[indexPath.row]objectForKey:@"address"]];
    
        
           
        
    }
    
    cell.selectionStyle = 0 ;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    dic[@"latitude"] = [NSString stringWithFormat:@"%.6f",coor.latitude];
//    dic[@"longitude"] = [NSString stringWithFormat:@"%.6f",coor.longitude];

//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[_addrArray[indexPath.row]objectForKey:@"latitude"]doubleValue], [[_addrArray[indexPath.row]objectForKey:@"longitude"]doubleValue]);

    CLLocationCoordinate2D coor ;

    
    coor.latitude = [[_addrArray[indexPath.row]objectForKey:@"latitude"]floatValue];
    coor.longitude =[[_addrArray[indexPath.row]objectForKey:@"longitude"]floatValue];
    
    
    
    
    
    [self.tipView removeFromSuperview];
    
    if (self.serveScopeArray.count >= 3)
    {
        
        
        
        if ([self isInCity:coor])
        {

            
            
            self.placeBlock(_addrArray[indexPath.row]);

            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [self tipShow:@"当前地址超出服务范围"];
        }

    }
    

    
    
    
    
}


- (void)tipShow:(NSString *)str
{
    
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.3 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}



-(void)cancelBt
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc
{
    NSLog(@"%@ free",self);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
