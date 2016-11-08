//
//  DBSecendViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/14.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSecendViewController.h"

#import "DBBeltDriveViewController.h"
@interface DBSecendViewController ()

@end

@implementation DBSecendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self setUI];
    
    
    [self setSiftView];
    
}

#pragma mark ----创建城市筛选页面

//创建详情选项
-(void)setSiftView
{
    
    
//    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWidth * 571/777, ScreenWidth, ControlHeight - ScreenWidth * 571/777)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    header.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] ;
    [baseView addSubview:header];
    
    
    UIView * header1 = [[UIView alloc]initWithFrame:CGRectMake(0, 29.5, ScreenWidth, 0.5)];
    header1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1] ;
    [baseView addSubview:header1];
    
    
    //取还车方式 标题
    UILabel * mustCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenWidth, 20)];
    mustCostLabel.text = @"门到门服务";
    mustCostLabel.font = [UIFont systemFontOfSize:12];
    mustCostLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1] ;
    mustCostLabel.tag = 100 ;
    [baseView addSubview:mustCostLabel];
    
    
    
    
    //选择开关
    UISwitch * invoiceSwitch = [[UISwitch alloc]initWithFrame:CGRectMake( ScreenWidth - 60 ,0, 51, 15)];
    
    invoiceSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    invoiceSwitch.onTintColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    
    [baseView addSubview:invoiceSwitch];
//    [invoiceSwitch addTarget:self action:@selector(switchIsOn:) forControlEvents:UIControlEventTouchUpInside];
    [invoiceSwitch setOn:YES animated:NO] ;
    

    
    CGSize  four = [DBcommonUtils calculateStringLenth:@"取车城市" withWidth:ScreenWidth withFontSize:12];
    
    //定位图片
    UIImageView * cityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 ,40  , 10 , 10 )];
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
    takeCityLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takeCityLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:takeCityLabel];
    
    
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takeCityLabel.frame)+5,  takeCityLabel.frame.origin.y , 0.5 , 20)];
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView];
    
    
    //定位城市
    UILabel * cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, takeCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView.frame)  - 50, 20)];
    cityLabel.text = @"城市加载中...";
    cityLabel.textAlignment = 0 ;
    cityLabel.textColor =[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:12 ];
    
    [baseView addSubview:cityLabel];
    cityLabel.tag = 101 ;
    
    
    //城市选择点击事件
    UIControl * takeCity = [[UIControl alloc]initWithFrame:CGRectMake(cityLabel.frame.origin.x, cityLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(takeCityLabel.frame) - 20, cityLabel.frame.size.height)];
    takeCity.tag = 111 ;
//    [takeCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:takeCity];
    
    cityLabel.userInteractionEnabled = YES;
    
    
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake( takeCityLabel.frame.origin.x, CGRectGetMaxY(lineView.frame) + 5  ,ScreenWidth - 2 * takeCityLabel.frame.origin.x , 0.5)];
    lineView1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView1];
    
    
    //取车地点
    UILabel * takePlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView1.frame)+5 ,four.width + 5, 20 )];
    takePlaceLabel.text = @"取车地点";
    takePlaceLabel.textAlignment = 1 ;
    takePlaceLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    takePlaceLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:takePlaceLabel];
    takePlaceLabel.tag = 105 ;
    
    
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(takePlaceLabel.frame)+5,  takePlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView2.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView2];
    
    
    //取车地点
    UILabel * placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame)+5, takePlaceLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20)];
    placeLabel.text = @"请输入地址";
    placeLabel.textAlignment = 0 ;
    placeLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    placeLabel.font = [UIFont systemFontOfSize:12 ];
    placeLabel.adjustsFontSizeToFitWidth = YES ;
    [baseView addSubview:placeLabel];
    placeLabel.tag = 103 ;
    
    
    
    //取车地点选择
    UIControl * takePlace = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, placeLabel.frame.size.width, placeLabel.frame.size.height)];
    takePlace.tag = 113 ;
//    [takePlace addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [placeLabel addSubview:takePlace];
    
    placeLabel.userInteractionEnabled = YES;
    
    //取还车分割线
    
    UIView * carveLine = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView2.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine];
    
    //还车位置图片
    UIImageView * returnCityImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 , CGRectGetMaxY(carveLine.frame) + 10 , 10 , 10 )];
    returnCityImage.image = [UIImage imageNamed:@"position-1"];
    [baseView addSubview:returnCityImage];
    
    
    //展开的小箭头
    
    UIImageView * returnMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth -27 ,returnCityImage.frame.origin.y  +3, 7 , 4 )];
    returnMoreImage.image = [UIImage imageNamed:@"more-image"];
    [baseView addSubview:returnMoreImage];
    
    
    //取车城市
    UILabel * returnCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(returnCityImage.frame)+5 ,  CGRectGetMaxY(carveLine.frame)+5 ,four.width + 5, 20 )];
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
    UILabel * returnLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView3.frame)+5, returnCityLabel.frame.origin.y, ScreenWidth -  CGRectGetMaxX(lineView3.frame) - 5  - 50, 20)];
    returnLabel.text = @"城市加载中...";
    returnLabel.textAlignment = 0 ;
    returnLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnLabel.font = [UIFont systemFontOfSize:12 ];
    
    [baseView addSubview:returnLabel];
    returnLabel.tag = 102 ;
    
    
    //城市选择点击事件
    UIControl * returnCity = [[UIControl alloc]initWithFrame:CGRectMake(returnLabel.frame.origin.x,returnLabel.frame.origin.y, ScreenWidth - CGRectGetMaxX(lineView3.frame) - 20, cityLabel.frame.size.height)];
    returnCity.tag = 112 ;
//    [returnCity addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:returnCity];
    
    returnLabel.userInteractionEnabled = YES;
    
    
    
    //横线
    UIView * lineView4 = [[UIView alloc]initWithFrame:CGRectMake( returnCityLabel.frame.origin.x, CGRectGetMaxY(lineView3.frame) + 5  ,lineView1.frame.size.width, 0.5)];
    lineView4.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView4];
    
    
    //还车地点
    UILabel * returnPlaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityImage.frame)+5 , CGRectGetMaxY(lineView4.frame)+5 ,four.width + 5, 20 )];
    returnPlaceLabel.text = @"还车地点";
    returnPlaceLabel.textAlignment = 1 ;
    returnPlaceLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnPlaceLabel.font = [UIFont systemFontOfSize:12 ];
    [baseView  addSubview:returnPlaceLabel];
    returnPlaceLabel.tag = 106 ;
    
    
    
    //竖线
    UIView * lineView5 = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(returnPlaceLabel.frame)+5,  returnPlaceLabel.frame.origin.y , 0.5 , 20)];
    lineView5.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:lineView5];
    
    
    //还车地点
    UILabel * returnPlace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView5.frame)+5 , returnPlaceLabel.frame.origin.y,ScreenWidth -  CGRectGetMaxX(lineView2.frame)  - 50, 20 )];
    returnPlace.text = @"请输入地址";
    returnPlace.textAlignment = 0 ;
    returnPlace.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1];
    returnPlace.font = [UIFont systemFontOfSize:12 ];
    returnPlace.adjustsFontSizeToFitWidth = YES ;
    [baseView  addSubview:returnPlace];
    returnPlace.tag = 104 ;
    
    
    //取车地点选择
    UIControl * returnPlaceC = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, returnPlace.frame.size.width, returnPlace.frame.size.height)];
    returnPlaceC.tag = 114 ;
//    [returnPlaceC addTarget:self action:@selector(takeCity:) forControlEvents:UIControlEventTouchUpInside];
    [returnPlace addSubview:returnPlaceC];
    
    returnPlace.userInteractionEnabled = YES;
    
    //    取还车与时间分割线
    
    UIView * carveLine1 = [[UIView alloc]initWithFrame:CGRectMake( 0, CGRectGetMaxY(lineView5.frame) + 5  ,ScreenWidth, 0.5)];
    carveLine1.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
    [baseView addSubview:carveLine1];
    
    
    
    
}




-(void)setUI
{
    

    UIImageView * imageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*571/777)];
    imageV.image = [UIImage imageNamed:@"截图"];
    [self.view addSubview:imageV];

    
    //选车按钮
    
    UIButton * chooseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBt.frame = CGRectMake(50, ControlHeight - 50, ScreenWidth-100, 30);
    chooseBt.layer.cornerRadius = 3;
    chooseBt.backgroundColor = [UIColor colorWithRed:0.91 green:0.76 blue:0.17 alpha:1];
    [chooseBt setTitle:@"立即去选车" forState:UIControlStateNormal];
    [chooseBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chooseBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    [chooseBt addTarget:self action:@selector(chooseBt) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseBt];

}

-(void)chooseBt
{
    DBBeltDriveViewController * beltDrive = [[DBBeltDriveViewController alloc ]init];
    [self.navigationController pushViewController:beltDrive animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
