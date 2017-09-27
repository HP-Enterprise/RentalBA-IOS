//
//  DBThirdViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBThirdViewController.h"

#import "DBCityListViewController.h"

#import "DBTailwindViewController.h"

@interface DBThirdViewController ()
{
    UILabel * takeLabel ;
    
    UILabel * returnLabel ;
}

//取车城市id
@property (nonatomic,strong)NSString * takeCityId ;

//还车城市id
@property(nonatomic,strong )NSString * returnCityId;
//错误提示
@property (nonatomic,strong)UIView * tipView ;

@end

@implementation DBThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
}
-(void)goSafari
{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    [application openURL:[NSURL URLWithString:@"http://www.b-car.cn/Pages/8.jsp"]];
    
}
-(void)setUI
{
    
    //添加背景图片
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
    
    UIImageView * imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*571/777)];
    imageV.image = [UIImage imageNamed:@"截图.jpeg"];
    [self.view addSubview:imageV];
    imageV.userInteractionEnabled = YES ;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goSafari)];
    
    [imageV addGestureRecognizer:tap];

    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imageV.frame), ScreenWidth, ControlHeight - ScreenWidth*571/777)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    header.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] ;
    [baseView addSubview:header];
    
    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:12];
    
    //定位图片
    UIImageView * cityImage = [[UIImageView alloc]initWithFrame:CGRectMake( 20 , 15 , 10 , 10 )];
    cityImage.image = [UIImage imageNamed:@"position"];
    [baseView addSubview:cityImage];
    

    //展开的小箭头
    
    UIImageView * moreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 27 , cityImage.frame.origin.y + 3, 7 , 4 )];
    moreImage.image = [UIImage imageNamed:@"more-image"];
    [baseView addSubview:moreImage];
    
    //取车城市
    UILabel * takeCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 ,  cityImage.frame.origin.y-5 ,four.width + 5, 20 )];
    takeCityLabel.text = @"取车城市";
    takeCityLabel.textAlignment = 1 ;
    takeCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:takeCityLabel];
    

    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView];
    
    
    //定位城市
    takeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 20)];
    takeLabel.text = @"请选择城市";
    takeLabel.textAlignment = 0 ;
    takeLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    takeLabel.font = [UIFont systemFontOfSize:12 ];
    
    [baseView addSubview:takeLabel];
    
    
    //城市选择点击事件
    UIControl * takeCity = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeLabel.frame.size.width, takeLabel.frame.size.height)];
    takeCity.tag = 451 ;
    [takeCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [takeLabel addSubview:takeCity];
    
    takeLabel.userInteractionEnabled = YES;
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 5  ,ScreenWidth - takeCityLabel.frame.origin.x - 20, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];

    
    UIImageView * returnCityImage = [[UIImageView alloc]initWithFrame:CGRectMake(20 , CGRectGetMaxY(lineView1.frame) + 15 , 10 , 10 )];
    returnCityImage.image = [UIImage imageNamed:@"position-1"];
    [baseView addSubview:returnCityImage];
    
    
    //展开的小箭头
    
    UIImageView * returnMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -27 ,returnCityImage.frame.origin.y  +3, 7 , 4 )];
    returnMoreImage.image = [UIImage imageNamed:@"more-image"];
    [baseView addSubview:returnMoreImage];
    
    
    //取车城市
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnCityImage.frame)+5 ,  CGRectGetMaxY(lineView1.frame)+10 ,four.width + 5, 20 )];
    returnCityLabel.text = @"还车城市";
    returnCityLabel.textAlignment = 1 ;
    returnCityLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnCityLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:returnCityLabel];
    
    //竖线
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnCityLabel.frame)+5,  returnCityLabel.frame.origin.y , 0.5 , 20)];
    lineView3.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView3];
    
    
    //定位城市
    returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView3.frame) - 5  - 50, 20)];
    returnLabel.text = @"请选择城市";
    returnLabel.textAlignment = 0 ;
    returnLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnLabel.font = [UIFont systemFontOfSize:12 ];
    
    [baseView addSubview:returnLabel];
    
    UIView * carveLine1 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView3.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine1];

    
    //城市选择点击事件
    UIControl * returnCity = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, takeLabel.frame.size.width, takeLabel.frame.size.height)];
    returnCity.tag = 452 ;
    [returnCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [returnLabel addSubview:returnCity];
    
    returnLabel.userInteractionEnabled = YES;
    
    
    //选车按钮
    
    UIButton * chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBt.frame = CGRectMake(50, CGRectGetMaxY(carveLine1.frame)+50, ScreenWidth-100, 30);
    chooseBt.layer.cornerRadius = 3;
    chooseBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [chooseBt setTitle:@"立即选车" forState:UIControlStateNormal];
    [chooseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    [chooseBt addTarget:self action:@selector(chooseBt) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:chooseBt];

    

    
}

#pragma mark 加载还车城市
-(void)loadReturnCity
{
    //加载顺风车城市
    NSString * url =[NSString stringWithFormat:@"%@/api/freeRide/returnCarCity?getCarCityId=%@",Host,self.takeCityId];
    
//    __weak typeof(self)weak_self = self;
    
//    [self addProgress];
    
    [DBNetworkTool getAllCitysGET:url parameters:nil success:^(id responseObject) {
        
        
//        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {
            
            if (![[responseObject objectForKey:@"message"] isKindOfClass:[NSNull class]])
            {

                NSArray * array =[NSArray arrayWithArray:[responseObject objectForKey:@"message"]];
                
                if (array.count > 0 )
                {
                    
                    returnLabel.text = [array[0]objectForKey:@"cityName"];
                    _returnCityId = [NSString stringWithFormat:@"%@",[array[0] objectForKey:@"id"]];
 
                }
                else if (array.count == 0)
                {
                    NSLog(@"没有数据");
                    returnLabel.text = @"请选择城市";

                }
                
                
            }
            
        }
        
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
        
        
//        [self removeProgress];
        
        
    }];
}


#pragma mark ----选车城市点击事件
-(void)takeCity:(UIControl*)control
{
    DBCityListViewController * cityList = [[DBCityListViewController alloc]init];
    
    
    
    if (control.tag == 451)
    {
        cityList.index = @"take";
        cityList.indexKind = 2 ;
        [self.navigationController pushViewController:cityList animated:YES];

    }
    else if (control.tag == 452)
    {
        
        cityList.index = @"return";
         cityList.indexKind = 2;
        cityList.cityId = self.takeCityId ;
        [self.navigationController pushViewController:cityList animated:YES];

    }

    cityList.cityChooseBlock = ^(NSDictionary* city,NSString * index)
    {
        
        if ([index isEqualToString:@"take"])
        {
            takeLabel.text  = [city objectForKey:@"cityName"];
            returnLabel.text = @"请选择城市";
            _takeCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
            [self loadReturnCity];
            

        }
        else if ([index isEqualToString:@"return"])
        {
            returnLabel.text = [city objectForKey:@"cityName"];
             _returnCityId = [NSString stringWithFormat:@"%@",[city objectForKey:@"id"]];
        }

    };

    
}

-(void)chooseBt
{
    [self.tipView removeFromSuperview];
    
//    if (self.takeCityId == nil || self.returnCityId == nil)
//    {
//        [self tipShow:@"请选择取还车城市"];
//    }

    DBTailwindViewController * carList = [[DBTailwindViewController alloc]init];

    if (!self.takeCityId) {
        self.takeCityId = @"";
    }
    if (!self.returnCityId) {
        self.returnCityId = @"";
    }
    
    carList.takeCityId = self.takeCityId ;
    carList.returnCityId = self.returnCityId ;
    
    
    [self.navigationController pushViewController:carList animated:YES];

//    }
    
    
    
    
    
}



- (void)tipShow:(NSString *)str
{
    
    
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ControlHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
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
