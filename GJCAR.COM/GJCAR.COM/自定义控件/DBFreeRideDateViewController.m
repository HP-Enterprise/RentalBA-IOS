//
//  DBFreeRideDateViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/29.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBFreeRideDateViewController.h"


@interface DBFreeRideDateViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>


//年份位置
@property (nonatomic)NSInteger  rowYear;

//月份位置
@property (nonatomic)NSInteger rowMonth;

//日期位置
@property (nonatomic)NSInteger rowDay ;

//回调选择的时间
@property (nonatomic)NSString * date;

//回调选择的消失
@property (nonatomic)NSString  *hour ;

@end

@implementation DBFreeRideDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithProData:(DBFreeRideModel*)model withCityData:(DBFreeRideModel*)model1
{
    
    
    
    
    [self loadDataWith:model];
    
    
    
    
    
    _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBt.frame = CGRectMake( 0  , 0 ,  ScreenWidth / 3 , 40 );
    [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBt setTitleColor:[UIColor colorWithRed:46 / 255.f green:186/ 255.f blue:238 / 255.f alpha:1.f] forState:UIControlStateNormal];
    
    _cancelBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    //    _cancelBt.layer.cornerRadius = 10 * ScreenWidth / 320 ;
    //    _cancelBt.backgroundColor = [UIColor colorWithRed:0.07 green:0.55 blue:0.82 alpha:1];
    [_cancelBt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBt];
    _cancelBt.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    _selectBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBt.frame = CGRectMake( ScreenWidth * 2 / 3 , 0 ,  ScreenWidth / 3 , 40 );
    [_selectBt setTitle:@"确定" forState:UIControlStateNormal];
    [_selectBt setTitleColor:[UIColor colorWithRed:46 / 255.f green:186/ 255.f blue:238 / 255.f alpha:1.f] forState:UIControlStateNormal];
    
    _selectBt.titleLabel.font = [UIFont systemFontOfSize:14 ];
    //    _selectBt.layer.cornerRadius = 10 * ScreenWidth / 320 ;
    //    _selectBt.backgroundColor = [UIColor colorWithRed:0.07 green:0.55 blue:0.82 alpha:1];
    [_selectBt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBt];
    _selectBt.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth / 3 , 0 , ScreenWidth /3 , 40 )];
    _label.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    _label.textAlignment = 1;
    _label.textColor = [UIColor colorWithRed:46 / 255.f green:186/ 255.f blue:238 / 255.f alpha:1.f];
    
    _label.font = [UIFont systemFontOfSize:14 ];
    [self.view addSubview:_label] ;
    
    
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 40 , ScreenWidth, 200 )];
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.view addSubview:_pickerView];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    
    

//    //时间
    self.date = @"2016-05-10日 周二";
  
    self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[_yearArray[0]objectForKey:@"year"]];
    
    
    self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[[NSArray arrayWithArray:[_yearArray[0]objectForKey:@"monthList"]][0]objectForKey:@"month"]];
    [self.pickerView reloadComponent:2];
    
    
    
    self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(8, 6) withString:[NSArray arrayWithArray:[[NSArray arrayWithArray:[_yearArray[0]objectForKey:@"monthList"]][0]objectForKey:@"dayList"]][0]];
    
    
    self.hour = _hourArray[0];

    
    
    NSLog(@"%@",self.date);
    
    self.hour = _hourArray[0];
    
    
    _rowYear = 0 ;
    _rowMonth = 0;
    
    
    NSLog(@"%ld",_rowMonth);
    _rowDay = 0;
    
    
    
    
    
    
    [_pickerView selectRow:0 inComponent:1 animated:YES];
    [_pickerView selectRow:0 inComponent:2 animated:YES];
    
}


-(void)loadDataWith:(DBFreeRideModel*)model
{
    _yearArray= [NSMutableArray array];
    _hourArray = @[@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00"];
    
    
    
    NSInteger MIN_YEAR = [[model.takeCarDateStart substringWithRange:NSMakeRange(0, 4)]integerValue];
    NSInteger MAX_YEAR = [[model.takeCarDateEnd substringWithRange:NSMakeRange(0, 4)]integerValue];


    

    for (NSInteger i = MIN_YEAR ; i <= MAX_YEAR; i++)
    {
        NSMutableArray * monthArray = [NSMutableArray array];

        NSArray * tempAyyay = @[@"31",[self LeepYear:i] ? @"29" : @"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
        
        
        
        NSInteger MIN_MONTH = [[model.takeCarDateStart substringWithRange:NSMakeRange(5, 2)]integerValue];
        NSInteger MAX_MONTH = [[model.takeCarDateEnd substringWithRange:NSMakeRange(5, 2)]integerValue];


        for (NSInteger j = MIN_MONTH ; j<= MAX_MONTH ; j++ )
        {
            
            NSMutableArray * dayArray = [NSMutableArray array];

            NSInteger MIN_DAY = [[model.takeCarDateStart substringWithRange:NSMakeRange(8, 2)]integerValue];
            NSInteger MAX_DAY = [[model.takeCarDateEnd substringWithRange:NSMakeRange(8, 2)]integerValue];
            
            if (MIN_MONTH == MAX_MONTH)
            {
                for (NSInteger z = MIN_DAY ;  z <= MAX_DAY; z ++)
                {

                    NSString * week = [DBcommonUtils weekdayStringFromDate:nil withDateStr:[NSString stringWithFormat:@"2016-%.2ld-%.2ld 10:00:00",j,z]];
                    [dayArray addObject:[NSString stringWithFormat:@"%02ld日 %@",z,week]];
  
                }

                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                
                [dic setObject:dayArray forKey:@"dayList"];
                [dic setObject:[NSString stringWithFormat:@"%02ld",j] forKey:@"month"];
                

                [monthArray addObject:dic];


            }
            else
            {
                if (j == MIN_MONTH) {
                    
                    for (NSInteger z = MIN_DAY ;  z <= [tempAyyay[j-1]integerValue] ; z ++)
                    {
                        
                        NSString * week = [DBcommonUtils weekdayStringFromDate:nil withDateStr:[NSString stringWithFormat:@"2016-%.2ld-%.2ld 10:00:00",j,z]];
                        [dayArray addObject:[NSString stringWithFormat:@"%02ld日 %@",z,week]];
                    }
                }
                else if (j == MAX_MONTH){
                    for (NSInteger z = 1;  z <= MAX_DAY ; z ++)
                    {
                        
                        NSString * week = [DBcommonUtils weekdayStringFromDate:nil withDateStr:[NSString stringWithFormat:@"2016-%.2ld-%.2ld 10:00:00",j,z]];
                        [dayArray addObject:[NSString stringWithFormat:@"%02ld日 %@",z,week]];
                    }
                }
                else{
                    for (NSInteger z = 1;   z <= [tempAyyay[j-1]integerValue] ; z ++)
                    {
                        
                        NSString * week = [DBcommonUtils weekdayStringFromDate:nil withDateStr:[NSString stringWithFormat:@"2016-%.2ld-%.2ld 10:00:00",j,z]];
                        [dayArray addObject:[NSString stringWithFormat:@"%02ld日 %@",z,week]];
                    }

                }
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                
                [dic setObject:dayArray forKey:@"dayList"];
                [dic setObject:[NSString stringWithFormat:@"%02ld",j] forKey:@"month"];
                
                [monthArray addObject:dic];

            }
            
        }

        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"%ld",i] forKey:@"year"];
        [dic setObject:monthArray forKey:@"monthList"];
        [_yearArray addObject:dic];

    }
    

}


//判断是否闰年
-(BOOL)LeepYear:(NSInteger)year
{
    if (year % 100 == 0 )
    {
        if (year % 400 == 0)
        {
            return 1;
        }
        return 0;
    }
    else if (year % 4 == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        
        //        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        pickerLabel.textColor = [UIColor blackColor];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextAlignment:1];
        
    }
    // Fill the label text here
    
    if (component == 0 )
    {
        
        pickerLabel.text=[NSString stringWithFormat:@"%@年",[self pickerView:pickerView titleForRow:row forComponent:component]];
        
        
    }
    else if (component ==1)
    {
        pickerLabel.text=[NSString stringWithFormat:@"%@月",[self pickerView:pickerView titleForRow:row forComponent:component]];
        
    }
    
    
    else if (component == 2)
    {
        pickerLabel.text=[NSString stringWithFormat:@"%@",[self pickerView:pickerView titleForRow:row forComponent:component]];
        
    }
    
    else if (component ==3)
    {
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        
        
    }
    
    pickerLabel.font = [UIFont systemFontOfSize:16];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0 )
    {
        _rowYear = row ;
        self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[_yearArray[row]objectForKey:@"year"]];
        
        [self.pickerView reloadAllComponents];
        
    }
    else if (component ==1)
    {
        _rowMonth = row ;
        self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][row]objectForKey:@"month"]];
        [self.pickerView reloadComponent:2];
    }

    else if (component == 2)
    {
        _rowDay = row ;
        self.date = [self.date  stringByReplacingCharactersInRange:NSMakeRange(8, 6) withString:[NSArray arrayWithArray:[[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][_rowMonth]objectForKey:@"dayList"]][row]];
    }
    
    else if (component == 3)
    {
        self.hour = _hourArray[row];
    }
    //    self.date = [NSString stringWithFormat:@"%@-%02ld-%02ld",[_yearArray[_rowYear]objectForKey:@"year"],_rowMonth+1,row+1];
    
    
    //    else if (component ==3)
    //    {
    //        _rowMonth = row ;
    //        [self.pickerView reloadComponent:2];
    //    }
    //    self.city = _yearArray[row];
}


-(void)btClick:(UIButton *)button
{
    
    if ([button.titleLabel.text isEqualToString:@"取消"])
    {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
        
        //        self.DateBlock(@"取消",@"取消啦");
    }
    else
    {
        
        if (self.date != nil)
        {
            self.freeRidedateBlock(self.date,self.hour);
            
        }
        
    }
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0 )
    {
        return _yearArray.count;
    }
    else if (component ==1)
        
    {
        return  [NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]].count;
    }
    
    else if (component==2)
    {
        return [NSArray arrayWithArray:[[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][_rowMonth]objectForKey:@"dayList"]].count;
    }
    
    else if (component==3)
    {
        
        return _hourArray.count;
    }
    
    return 0;
}


-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if (component == 0 )
    {
        return [_yearArray[row]objectForKey:@"year"];
    }
    else if (component == 1)
    {
        
        //        NSLog(@"%@",[[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][row]objectForKey:@"month"]);
        
        return  [[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][row]objectForKey:@"month"];
    }
    else if (component == 2)
        
    {
        
        return [NSArray arrayWithArray:[[NSArray arrayWithArray:[_yearArray[_rowYear]objectForKey:@"monthList"]][_rowMonth]objectForKey:@"dayList"]][row];
        
    }
    else if (component == 3)
    {
        return _hourArray[row];
    }
    
    return nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)dealloc
{
    
    [_pickerView removeFromSuperview];
    _pickerView = nil ;
    
    [_cancelBt removeFromSuperview];
    [_selectBt removeFromSuperview];
    [_label removeFromSuperview];
    
    NSLog(@"DBChooseDateViewController  dealloc");
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
