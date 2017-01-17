//
//  DBDatePickViewController.m
//  ShenHuaCar
//
//  Created by 段博 on 16/4/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBDatePickViewController.h"

@interface DBDatePickViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic)NSInteger  rowA;
@property (nonatomic)NSString * city;



@end

@implementation DBDatePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)initWithProData:(NSArray*)proArray withCityData:(NSArray*)cityArray
{
  
    _cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBt.frame = CGRectMake( 0  , 0 ,  ScreenWidth / 2 , 40 * ScreenHeight / 667);
    [_cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBt setTitleColor:[UIColor colorWithRed:46 / 255.f green:186/ 255.f blue:238 / 255.f alpha:1.f] forState:UIControlStateNormal];

    _cancelBt.titleLabel.font = [UIFont systemFontOfSize:14 * ScreenWidth / 320];
  
    _cancelBt.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [_cancelBt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBt];

    _selectBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBt.frame = CGRectMake( ScreenWidth/ 2  , 0 ,  ScreenWidth / 2 , 40 * ScreenHeight / 667);
    [_selectBt setTitle:@"确定" forState:UIControlStateNormal];
    [_selectBt setTitleColor:[UIColor colorWithRed:46 / 255.f green:186/ 255.f blue:238 / 255.f alpha:1.f] forState:UIControlStateNormal];
    
    _selectBt.titleLabel.font = [UIFont systemFontOfSize:14 * ScreenWidth / 320];

    _selectBt.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [_selectBt addTarget:self action:@selector(btClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBt];


    _dataArray = [NSArray arrayWithArray:proArray];
    _cityArray = [NSArray arrayWithArray:cityArray];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 250 * ScreenHeight / 667, ScreenWidth, 200 * ScreenHeight / 667)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:_pickerView];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _rowA = 0;
    self.city = _dataArray[_rowA];
    NSLog(@"1111%@",_dataArray);
    

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
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.font = [UIFont systemFontOfSize:16];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    _rowA = row ;
    self.city = _dataArray[row];

}


-(void)btClick:(UIButton *)button
{
    
    if ([button.titleLabel.text isEqualToString:@"取消"])
    {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
    else
    {
        
        
        if (self.city != nil)
        {
            
            self.btBlock(self.city,_rowA);
       
        }

    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [_dataArray objectAtIndex:row];
}


-(void)dealloc
{

    NSLog(@"DBDatePickViewController dealloc");
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
