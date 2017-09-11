//
//  DBCarListTableViewCell.m
//  GJCAR.COM
//
//  Created by 段博 on 16/6/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBCarListTableViewCell.h"



//日历控件
#import "DBCollectionViewCell.h"


#import "HeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"



@implementation DBCarListTableViewCell 



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatCollectionView];
    }
    return self;
}

#pragma mark --初始化日历
-(void)creatCollectionView
{
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init] ;
    //设置collectionView的滑动方向
    //UICollectionViewScrollDirectionVertical 垂直滑动   默认滑动方向
    //UICollectionViewScrollDirectionHorizontal 水平滑动
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //在垂直方向  设置的是cell上下之间的最小间距 在水平方向  设置的是cell左右之间的最小间距
    flowLayout.minimumLineSpacing = 0.5 ;
    //在垂直方向  设置的是cell左右之间的最小间距 在水平方向  设置的是cell上下之间的最小间距
    flowLayout.minimumInteritemSpacing = 0.5 ;
    //设置collectionViewCell的大小
    
    flowLayout.itemSize = CGSizeMake(ScreenWidth/7-1 ,ScreenWidth/7-1);
    
    //设置头部视图的大小
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, ScreenWidth/7) ;
    
    //设置尾部视图的大小
    flowLayout.footerReferenceSize = CGSizeMake(ScreenWidth, ScreenWidth/7-20) ;
    
    //第一个参数  位置大小
    //第二个参数  流布局对象 （UICollectionViewFlowLayout）
    
    
    _collcetionView  =[[ UICollectionView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenWidth/7 * 8 -20) collectionViewLayout:flowLayout];
    
    
    [self addSubview:_collcetionView];
    
    
    _collcetionView.delegate = self ;
    _collcetionView.dataSource =self ;
    
    
    //    在这个地方进行cell复用注册
    [_collcetionView registerClass:[DBCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"] ;
    //
    _collcetionView.backgroundColor = [UIColor clearColor];
    
    //在这个地方进行头部视图复用注册
    //    UICollectionElementKindSectionHeader 头部表示kind
    //    UICollectionElementKindSectionFooter 尾部表示kind
    [_collcetionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"] ;
    
    [_collcetionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"] ;

    
     _isFirst = YES ;
    
    
    
    //计算月份天数
    [self setMonthDays:nil];

}

//计算月份天数
-(void)setMonthDays:(NSString *)index
{
    
//    NSInteger  startDay = [[[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(8, 2)]integerValue];
//
     NSUserDefaults * user  =[ NSUserDefaults standardUserDefaults];

    
//    NSInteger  startMonth = [[[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(5, 2)]integerValue];
//
//    NSInteger  endMonth = [[[user objectForKey:@"returnCarDate"]substringWithRange:NSMakeRange(5, 2)]integerValue];
    

    NSString * starDate = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)];
    
    NSString * endDate = [[user objectForKey:@"returnCarDate"]substringWithRange:NSMakeRange(0, 7)];
    

    
    _daysArray = [NSMutableArray array];
    
    
    
    NSInteger days ;
    NSInteger week ;
    
    
    if (_nowDate == nil)
    {

        _nowDate = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)];


        days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[user objectForKey:@"takeCarDate"]]];
        
        week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[user objectForKey:@"takeCarDate"]]];

    }

    else
    {
        if ([index isEqualToString:@"next"])
        {
            
            
            NSLog(@"%d",[DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endDate]);

            _nowDate = [DBcommonUtils setupRequestMonthWithMonth:1 withDate:_nowDate];
            
            NSMutableString * date = [user objectForKey:@"takeCarDate"];
            
            
            
            days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
            
            week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
            
            _isFirst = NO;

//            if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endDate]== 1){
//                
//                _isFirst = NO;
//            }
                //            {

//            if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endDate]== -1)
//            {
//                
//                _nowDate = [DBcommonUtils setupRequestMonthWithMonth:1 withDate:_nowDate];
//
//                NSMutableString * date = [user objectForKey:@"takeCarDate"];
//                
//                
//                
//                days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
//                
//                week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
//                
//                
//                _isFirst = NO ;
//
//                
//                
//                
//                
//                NSLog(@"啦啦啦");
//            }
//
//            else
//                
//            {
//                NSLog(@"最大月份");
//                
//                return ;
//            }

        }
        
        else if ([index isEqualToString:@"last"])
        {
            
            NSLog(@"%d",[DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:starDate]);
            _nowDate = [DBcommonUtils setupRequestMonthWithMonth:-1 withDate:_nowDate];
            
            
            
            NSMutableString * date = [user objectForKey:@"takeCarDate"];
            
            days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
            
            week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];

      
                _isFirst = NO ;
//            if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:starDate]== -1){
//                _isFirst = NO ;
//            }

                //            {
            
//            if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:starDate]== 1)
//            {
//                
//                _nowDate = [DBcommonUtils setupRequestMonthWithMonth:-1 withDate:_nowDate];
//                
//          
//                
//                NSMutableString * date = [user objectForKey:@"takeCarDate"];
//
//                days = [DBcommonUtils totaldaysInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
//                
//                week  = [DBcommonUtils firstWeekdayInThisMonth:[NSDate date] with:[NSString stringWithFormat:@"%@ 10:00:00",[date stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate]]];
//
//                _isFirst = NO ;
//                
//               
//
//                
//            }
//
//            else
//            {
//                NSLog(@"最小月份");
//                return ;
//            }
            
            
        }

    }
    
    
    NSLog(@"星期 ----%ld",week);
    
    for (int i  = 0; i < 42 ; i ++)
    {
        if ( i - week < 0)
        {
            [_daysArray addObject:@"_"];
        }
        
        else if ( i - week < days)
        {
            [_daysArray addObject:[NSString stringWithFormat:@"%ld",i-week+1]];
        }
        else if ( i >= days)
                   
       {
           [_daysArray addObject:@"_"];


       }
        
        
        NSLog(@"%ld",i - week + 1);
        
        NSLog(@"今天是%@号",_daysArray[i]);
        
    }
    
  
    
    
    NSLog(@"这个月有%ld天 , 第一天是%ld",(long)days,(long)week);
    
    
    
    
    if (_isFirst == YES)
    {

        [self rentalDate:days];
       
    }
    else
    {
        [self loadPrice:index withDays:days];
 
    }


}


-(void)rentalDate:(NSInteger)days
{
    _rentalArray = [NSMutableArray array];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    

    NSInteger  startDay = [[[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(8, 2)]integerValue];
    
    
    NSString *   startMonth = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)];

    NSInteger  endDay = [[[user objectForKey:@"returnCarDate"]substringWithRange:NSMakeRange(8, 2)]integerValue];
    
    
    NSString *  endMonth = [[user objectForKey:@"returnCarDate"]substringWithRange:NSMakeRange(0, 7)];

    
//    NSInteger rentalDays = [[user objectForKey:@"rentalDay"]integerValue];
    
    
    if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:startMonth]== 0)
    {
        if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endMonth]== 0)
        {
            for (NSInteger i = startDay ; i <= endDay; i ++)
            {

                [_rentalArray addObject:[NSString stringWithFormat:@"%ld",i]];
            }
        }
        else
        {

            for (NSInteger i = startDay ; i <= days; i ++)
            {
                [_rentalArray addObject:[NSString stringWithFormat:@"%ld",i]];
            }
 
        }
    }
    else
    {
        if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endMonth]== 0 )
        {

            for (NSInteger i = 0 ; i <= endDay; i ++)
            {
                
                
                [_rentalArray addObject:[NSString stringWithFormat:@"%ld",i]];
            }
            
        }
        else if([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:startMonth]== 1 && [DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endMonth]== -1)
        {
            for (NSInteger i = 0 ; i <= days; i ++)
            {
                
                [_rentalArray addObject:[NSString stringWithFormat:@"%ld",i]];
            }
            
            
        }
        else{
            
            
        }

    }

    [_collcetionView reloadData];
}




#pragma mark 加载价格日历
-(void)loadPrice:(NSString *)index withDays:(NSInteger)days

{
    
    NSUserDefaults  * user = [NSUserDefaults standardUserDefaults];
    
    _priceArray = [NSArray array];
        
    NSString * url = [NSString stringWithFormat:@"%@/api/rentalPack/prices_a",Host];
    

    NSString * startDate =[[user objectForKey:@"takeCarDate"] stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:_nowDate];
 
    NSString * endMonth =[_nowDate substringWithRange:NSMakeRange(5, 2) ];

    NSString * endDate = [startDate stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:[NSString stringWithFormat:@"%02ld",[endMonth integerValue]+1]];
    
//    
//    NSString * startDate = @"2017-07-01";
//    NSString * endDate = @"2017-08-01";
    
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];
    
    parDic[@"startDate"] = [startDate stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:@"01"];
    
    parDic[@"endDate"] = [endDate stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:@"01"];;
    
    parDic[@"modelId"] =  [[user objectForKey:@"carSection"]objectForKey:@"modelId"] ;

    parDic[@"storeId"] = [[user objectForKey:@"carSection"]objectForKey:@"storeId"] ;

    
    

    [DBNetworkTool Get:url parameters:parDic success:^(id responseObject) {
        DBLog(@"%@",responseObject);
        

        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"true"]){

            _priceArray = [NSArray arrayWithArray:[responseObject objectForKey:@"message"]] ;

//            NSMutableArray * newArr = [NSMutableArray arrayWithArray:_priceArray];
//            [newArr replaceObjectAtIndex:0 withObject:[NSNull alloc]];
//            _priceArray = [NSArray arrayWithArray:newArr];
//            
            [self rentalDate:days];

        }
        
    } failure:^(NSError *error) {
        

        
    }];
    

    
}








#pragma mark -- UICollectionViewDelegate

//设置每个分组中collectionViewCell的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{


    return _daysArray.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSInteger index ;
    
    DBCollectionViewCell * cell = [_collcetionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath] ;
    
    for (UIView *subView in cell.contentView.subviews)
    {
        

        [subView removeFromSuperview];
    }

     [cell config:nil];
   
    if (_daysArray.count > 0 )
    {

        if (indexPath.row % 7 == 0 || (indexPath.row + 1) % 7 == 0)
        {
 
            cell.dateLabel.textColor = [UIColor grayColor];
            cell.priceLable.textColor = [UIColor grayColor];
        }

        cell.dateLabel.text = _daysArray[indexPath.row];

        cell.backgroundColor =  [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1] ;
        

        index = [_daysArray[indexPath.row]integerValue] ;
        
        NSLog(@"这是第%ld个元素   值是%ld",indexPath.row,index);
        
        if ( index > 0  && index <=  _priceArray.count)
        {

            for (NSString * date in _rentalArray)
            {
                if ([[NSString stringWithFormat:@"%ld",index]isEqualToString:date])
                {
                    cell.backgroundColor =  [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];

                }
                
            }

            NSLog(@"%@",_priceArray[index-1]);

            if ([_priceArray[index-1]isKindOfClass:[NSNull class]])
            {
                cell.priceLable.text =@"_";
            }
            else{
                NSDictionary * dic = _priceArray[index-1] ;

                NSString *  date  = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]] substringWithRange:NSMakeRange(8, 2)];
        
                if ([date integerValue] == index)
                {
                    if ([[_priceArray[index-1]objectForKey:@"rentalAmount"]isKindOfClass:[NSNull class]]) {
                        cell.priceLable.text =@"_";
                    }
                    else{
                        cell.priceLable.text =[NSString stringWithFormat:@"￥%@",[_priceArray[index-1]objectForKey:@"rentalAmount"]];
                    }
                  

                }
                      
            }
                
        }

    }

    return cell ;
}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    判断是否是头部视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //从复用池中去头部视图
        HeaderCollectionReusableView * headerView = [_collcetionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath] ;
        //        headerView.backgroundColor = [UIColor yellowColor] ;
        if (headerView == nil)
        {
            headerView =[[HeaderCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/7)];
        }
       
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        
        NSString* startMonth = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)];
        
        NSString *  endMonth = [[user objectForKey:@"returnCarDate"]substringWithRange:NSMakeRange(0, 7)];

        
        NSString * date = [[user objectForKey:@"takeCarDate"]substringWithRange:NSMakeRange(0, 7)] ;
        
  

        
        __weak typeof(headerView)weak_headerView = headerView ;

        
        headerView.changeMonthBlock = ^(NSString * index )
        {

            NSLog(@"%ld",indexPath.row);
            

            
            if (_nowDate == nil)
            {
                
                _nowDate =[NSString stringWithFormat:@"%@",startMonth];

                weak_headerView.timeLabel.text = date ;

            }
            
            else
            {
                if ([index isEqualToString:@"next"])
                {
                    weak_headerView.timeLabel.text = [DBcommonUtils setupRequestMonthWithMonth:1 withDate:_nowDate] ;
//                    if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:endMonth]== -1)
//                    {
//                        
//
//
//                        weak_headerView.timeLabel.text = [DBcommonUtils setupRequestMonthWithMonth:1 withDate:_nowDate] ;
//
//                    }
                    

                }
                
                else if ([index isEqualToString:@"last"])
                {
                    
                    
                    weak_headerView.timeLabel.text = [DBcommonUtils setupRequestMonthWithMonth:-1 withDate:_nowDate] ;

//                    if ([DBcommonUtils compareOneMonth:_nowDate withAnotherMonth:startMonth]== 1)
//                    {
//                       
//                        
//                        
//                        weak_headerView.timeLabel.text = [DBcommonUtils setupRequestMonthWithMonth:-1 withDate:_nowDate] ;
//                        
//                    }
                    
                }

            }

              [self setMonthDays:index];
            
        };
        
      

        
        return headerView ;
        
        
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //从复用池中去头部视图
        FooterCollectionReusableView * footerView = [_collcetionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath] ;
        
        if (footerView == nil)
        {
            footerView =[[FooterCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth , ScreenWidth / 7-20)];
            
        }
        
        return footerView ;
        
    }
    
    else
        return nil ;
}


//点击某个cell会调用此函数
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"列%ld---行%ld",indexPath.section,(long)indexPath.row) ;
}

-(void)config:(NSArray*)array withPriceDaysArray:(NSMutableArray*)daysArray
{

    _priceArray = array ;

    if (daysArray)
    {
        _daysArray  = daysArray ;

    }
    

    //计算月份天数
//    [self setMonthDays];

//    [_collcetionView reloadData];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
