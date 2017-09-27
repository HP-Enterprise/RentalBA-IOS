//
//  DBSwapViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/9.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSwapViewController.h"

#import "DBScoreExchangeTableViewCell.h"

@interface DBSwapViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _couponArray ;
    
    UITableView * _tableView;
    
    UIView * _tipView ;

    
    UILabel * couponTypeNumber ;
    
    //记录点击
    NSIndexPath *_indexPath;
}

@property (nonatomic,strong)DBProgressAnimation * progress ;

@end

@implementation DBSwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavigation];

    //优惠券列表
    [self setUI];
    
    //创建兑换页面
    [self createExchangeView];
    
    //加载可兑换优惠券
    [self loadCouponDate];
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
-(void)loadCouponDate
{
    NSString * url = [NSString stringWithFormat:@"%@/api/me/couponType?currentPage=1&pageSize=100&applySource=2",Host];
    
    
    //    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    _couponArray = [NSArray array];
    
    
    [self addProgress];
    
    [DBNetworkTool getUserInfoGET:url parameters:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            NSMutableArray * coupArray = [NSMutableArray array];
            NSInteger applySource ;

        
            for (NSDictionary * dic in [responseObject objectForKey:@"message"]) {
                

                if (![[dic objectForKey:@"applySource"] isKindOfClass:[NSNull class]] && ![[dic objectForKey:@"applySource"]isEqualToString:@""]) {
                    
                    applySource = [[dic objectForKey:@"applySource"]integerValue];

                    if (applySource == 2 || applySource == 0) {
                        
                        [coupArray addObject:dic];
                    }

                }
                
            }
            

            _couponArray = [NSArray arrayWithArray:coupArray];
            
            if (_couponArray.count  ==  0) {
                
                [self tipShow:@"没有可兑换的优惠券"];
                
            }
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        }
        else
        {
            
        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        NSLog(@"%@",error);
        
    }];
}

#pragma mark --创建导航栏
-(void)setNavigation
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"积分兑换" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark --创建兑换弹框

-(void)createExchangeView
{
    //兑换弹窗
    UIView * exchangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    exchangeView.backgroundColor = [UIColor clearColor];
    exchangeView.hidden = YES ;
    [self.view bringSubviewToFront:exchangeView];
    [self.view addSubview:exchangeView];
    exchangeView.tag = 700 ;
    
    
    //灰色背景
    
    UIView * grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    grayBackView.backgroundColor = [UIColor grayColor];
    grayBackView.alpha = 0.5 ;
    [exchangeView addSubview:grayBackView];

    
    //白色背景
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake( 30 , 0.4 * ScreenHeight, ScreenWidth - 60 , 160)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 1 ;
    backView.layer.cornerRadius = 10 ;
    backView.layer.masksToBounds = YES ;
    [exchangeView addSubview:backView ];
    
    
    //积分数量背景
    UIView * remainBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, 30)];
    remainBack.backgroundColor = [UIColor colorWithRed:0.94 green:1 blue:1 alpha:1];
    [backView addSubview:remainBack];
    
    //积分数量
    UILabel * remainLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0.5 * remainBack.frame.size.width - 15, remainBack.frame.size.height)];
    remainLable.text =@"兑换数量" ;
    remainLable.font = [UIFont systemFontOfSize:12];
    [remainBack addSubview:remainLable];
    
    
    //优惠券剩余数量
    UILabel * remainNum = [[UILabel alloc]initWithFrame:CGRectMake( 0.5 * remainBack.frame.size.width,0 , 0.5 * remainBack.frame.size.width - 15, remainLable.frame.size.height)];
    remainNum.text = [NSString stringWithFormat:@"剩余%@张",[_couponArray[_indexPath.row]objectForKey:@"remainNum"]];
    remainNum.font  = [UIFont systemFontOfSize:11];
    remainNum.textAlignment = 2;
    [remainBack addSubview:remainNum];
    remainNum.tag = 701 ;
    
    //优惠券类型
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(remainBack.frame)+10, backView.frame.size.width - 15 , 20)];
    title.text = @"国庆优惠" ;
    title.font = [UIFont systemFontOfSize:14];
    [backView addSubview:title];
    title.tag = 702;
    
    //需消耗积分
    UILabel * costRemain = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame)+5, backView.frame.size.width - 15, 15)];
    costRemain.text =[NSString stringWithFormat:@"需消耗%@积分",@"100"];
    costRemain.font = [UIFont systemFontOfSize:11];
    costRemain.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [backView addSubview:costRemain];
    costRemain.tag = 703 ;
    
    
    //删减优惠券张数
    
    UIButton * discreaseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    discreaseBt.frame = CGRectMake(15, CGRectGetMaxY(costRemain.frame)+10 ,(backView.frame.size.width - 50)/3, 25);
    discreaseBt.layer.borderWidth = 0.5 ;
    discreaseBt.layer.borderColor = [UIColor grayColor].CGColor;
    discreaseBt.backgroundColor = [UIColor whiteColor];
    [discreaseBt setTitle:@"-" forState:UIControlStateNormal];
    [discreaseBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [discreaseBt addTarget:self action:@selector(discreaseBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:discreaseBt];
    
    
    //优惠券张数
    couponTypeNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(discreaseBt.frame)+10, discreaseBt.frame.origin.y, discreaseBt.frame.size.width, discreaseBt.frame.size.height)];
    couponTypeNumber.text = @"1";
    couponTypeNumber.textAlignment = 1;
    couponTypeNumber.font = [UIFont systemFontOfSize:14];
    couponTypeNumber.textColor = [UIColor whiteColor];
    couponTypeNumber.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [backView addSubview:couponTypeNumber];
    
    
    //增加优惠券张数
    
    UIButton * increaseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    increaseBt.frame = CGRectMake(CGRectGetMaxX(couponTypeNumber.frame)+10, CGRectGetMaxY(costRemain.frame)+10 ,(backView.frame.size.width - 50)/3, discreaseBt.frame.size.height);
    increaseBt.layer.borderWidth = 0.5 ;
    increaseBt.layer.borderColor = [UIColor grayColor].CGColor;
    increaseBt.backgroundColor = [UIColor whiteColor];
    [increaseBt setTitle:@"+" forState:UIControlStateNormal];
    [increaseBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [increaseBt addTarget:self action:@selector(increaseBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:increaseBt];
    
    
    //取消按钮
    UIButton * cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBt.frame = CGRectMake(0, CGRectGetMaxY(increaseBt.frame)+15 , 0.5 * backView.frame.size.width, 35);
    cancelBt.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    cancelBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBt addTarget:self action:@selector(cancelBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBt];
    
    //确定按钮
    UIButton * submitBt = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBt.frame = CGRectMake(0.5 * backView.frame.size.width, CGRectGetMaxY(increaseBt.frame)+15 , 0.5 * backView.frame.size.width, cancelBt.frame.size.height);
    submitBt.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];

    [submitBt setTitle:@"确定" forState:UIControlStateNormal];
    submitBt.titleLabel.font = [UIFont systemFontOfSize:12];
    [submitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBt addTarget:self action:@selector(submitBtClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBt];


    
    
}



#pragma mark ----设置tableView
-(void)setUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle = NO ;
    [self.view addSubview:_tableView];
    
    
}
#pragma mark ----设置tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90   ;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBScoreExchangeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"exchangeCell"];
    if (cell == nil) {
        cell = [[DBScoreExchangeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeCell"];
    }

    [cell config:_couponArray[indexPath.row]];
    
    cell.selectionStyle = 0 ;

    return cell ;
    
}


#pragma mark 点击列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UIView * exchangeView  = [self.view viewWithTag:700];
    if (exchangeView.hidden == YES)

    {
        
        _indexPath = indexPath ;
        [self showExchangeView];
    }
    
    

}

//删减优惠券
-(void)discreaseBtClick
{
    
    UILabel * costRemain = [self.view viewWithTag:703];

    if ([couponTypeNumber.text integerValue]>0)
    {
        couponTypeNumber.text = [NSString stringWithFormat:@"%ld",[couponTypeNumber.text integerValue]-1];
        costRemain.text =[NSString stringWithFormat:@"需消耗%ld积分",[[_couponArray[_indexPath.row]objectForKey:@"accumulate"]integerValue] * [couponTypeNumber.text integerValue]];

    }
}


//增减优惠券
-(void)increaseBtClick
{
    
    UILabel * costRemain = [self.view viewWithTag:703];
    

    if ([couponTypeNumber.text integerValue] < [[_couponArray[_indexPath.row]objectForKey:@"remainNum"]integerValue])
    {
        couponTypeNumber.text = [NSString stringWithFormat:@"%ld",[couponTypeNumber.text integerValue]+1];
        
        costRemain.text =[NSString stringWithFormat:@"需消耗%ld积分",[[_couponArray[_indexPath.row]objectForKey:@"accumulate"]integerValue] * [couponTypeNumber.text integerValue]];

        
    }
}

//取消兑换
-(void)cancelBtClick
{
    [self hideExchange];
}


//确定兑换
-(void)submitBtClick
{
    
    [self exchangeClickAtIndexPath:_indexPath];
}

#pragma mark 显示兑换弹窗
-(void)showExchangeView
{
    UIView * exchangeView = [self.view viewWithTag:700];
    UILabel * remainNum = [self.view viewWithTag:701];
    UILabel * title = [self.view viewWithTag:702];
    UILabel * costRemain = [self.view viewWithTag:703];

    
    couponTypeNumber.text = @"1" ;
    
    remainNum.text = [NSString stringWithFormat:@"剩余%@张",[_couponArray[_indexPath.row]objectForKey:@"remainNum"]];
    title.text = [_couponArray[_indexPath.row]objectForKey:@"title"];

    costRemain.text =[NSString stringWithFormat:@"需消耗%@积分",[_couponArray[_indexPath.row]objectForKey:@"accumulate"]];

    exchangeView.hidden = NO ;
    
    [UIView animateWithDuration:0.3 animations:^{
        exchangeView.alpha = 1 ;
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark 隐藏兑换弹窗
-(void)hideExchange
{
    
    UIView * exchangeView = [self.view viewWithTag:700];
    [UIView animateWithDuration:0.3 animations:^{
        exchangeView.alpha = 0 ;
    } completion:^(BOOL finished) {
        exchangeView.hidden = YES ;
    }];
    
}


#pragma mark 兑换积分
-(void)exchangeClickAtIndexPath:(NSIndexPath *)indexPath
{
//    http://www.feeling.hpecar.com/api/me/coupon/exchange?num=2&typeId=7
    
    [_tipView removeFromSuperview];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me/coupon/exchange?num=%@&typeId=%@",Host,couponTypeNumber.text,[_couponArray[indexPath.row]objectForKey:@"id"]];
    
    
    [self addProgress];
    
    [DBNetworkTool POST:url parameters:nil success:^(id responseObject)
    {
        
        [self removeProgress];
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            
            [self tipShow:[responseObject objectForKey:@"message"]];
            
            [self loadCouponDate];
            
            [self hideExchange];
            
            
        }
        else
        {
            [self tipShow:[responseObject objectForKey:@"message"]];

        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
        
        [self tipShow:@"数据错误"];
    }];
    
}

- (void)tipShow:(NSString *)str
{
    
    
    
    _tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:_tipView];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"积分兑换页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"积分兑换页面"];
}

-(void)dealloc
{
    NSLog(@"%@ free",self);
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
