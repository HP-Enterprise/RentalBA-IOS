//
//  DBVoucherViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/5.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBVoucherViewController.h"

#import "DBvoucherTableViewCell.h"
@interface DBVoucherViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

{
    UILabel * none ;
}

@property (nonatomic,strong)UIScrollView * scrollView;

//按钮底部
@property (nonatomic,strong)UIView * botView;

@property (nonatomic,strong)UITableView * tableView;

//记录上次按钮
@property (nonatomic,strong)UIButton * lastBt;

@property (nonatomic,strong)NSString * state;
@property (nonatomic,strong)UIView * tipView ;

@property (nonatomic,strong)NSArray * voucherArray ;

@property (nonatomic,strong)DBProgressAnimation * progress ;
@end

@implementation DBVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航栏
    [self setNavigation];
    
    
    //创建界面
    [self setUI];
    
    
    //创建Scrollview
    [self setScrollview];
    
    
    //加载积分
    _state = @"2";
    [self loadData];
    
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
-(void)loadData
{
    _voucherArray = [NSArray array];
    
    
    NSUserDefaults * user = [ NSUserDefaults standardUserDefaults];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me/coupon?currentPage=1&pageSize=200&state=%@&uid=%@&applySource=2",Host,_state,[user objectForKey:@"userId"]];

    
    [self addProgress];
    [DBNetworkTool  Get:url parameters:nil success:^(id responseObject) {
      
        
        [self removeProgress];
        NSLog(@"%@",responseObject);
      
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
        {
            _voucherArray = [responseObject objectForKey:@"message"];
            

            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
            if (_voucherArray.count > 0)
            {
                none.hidden = YES;
            }
            else
            {
                none.hidden = NO ;
            }
            
        }
        else
        {
            //            [user setObject:@"0" forKey:@"token"];
        }
        
    } failure:^(NSError *error) {
        
        [self removeProgress];
    
        NSLog(@"%@",error);
        
    }];

}

#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"我的优惠券" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    
    
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"我的优惠券" withLeftBtImage:@"back" withRightImage:nil withRightTitle:@"兑换优惠券" withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [nav.rightButton addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setUI
{
    
    //创建背景界面
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 30)];
    baseView.backgroundColor =[UIColor colorWithRed:0.94 green:1 blue:1 alpha:1];
    [self.view addSubview:baseView];

    //创建分类按钮
    //未使用的优惠券
    UIButton * wouldUser = [UIButton buttonWithType:UIButtonTypeCustom];
    
    wouldUser.frame = CGRectMake(20, 0, 50, 28);
    
    [wouldUser setTitle:@"未使用" forState:UIControlStateNormal];
    [wouldUser setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
    wouldUser.titleLabel.font = [UIFont systemFontOfSize:14];
    wouldUser.tag = 650 ;
    [wouldUser addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:wouldUser];
    _lastBt = wouldUser ;
    
    //按钮底部View
    _botView = [[UIView alloc]initWithFrame:CGRectMake(wouldUser.frame.origin.x, 28, wouldUser.frame.size.width, 2)];
    _botView.backgroundColor = [UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1];
    [baseView addSubview:_botView];
    
    
    
    
    //创建分类按钮
    UIButton * Usered = [UIButton buttonWithType:UIButtonTypeCustom];
    
    Usered.frame = CGRectMake( ScreenWidth /2 -25 , 0 , 50, 28) ;
    
    [Usered setTitle:@"已使用" forState:UIControlStateNormal];
    [Usered setTitleColor:[UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] forState:UIControlStateNormal];
    Usered.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [baseView addSubview:Usered];
    Usered.tag = 651 ;
    [Usered addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建分类按钮
    UIButton * expire = [UIButton buttonWithType:UIButtonTypeCustom];
    
    expire.frame = CGRectMake( ScreenWidth -  70 , 0 , 50, 28) ;
    
    [expire setTitle:@"已过期" forState:UIControlStateNormal];
    [expire setTitleColor:[UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] forState:UIControlStateNormal];
    expire.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [baseView addSubview:expire];
    expire.tag = 652 ;
    [expire addTarget:self action:@selector(BtClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
}


//创建scrollview
-(void)setScrollview
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, ScreenWidth, ScreenHeight-94)];
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.showsHorizontalScrollIndicator = NO ;
    _tableView.delegate = self ;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    none = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 20)];
    none.text = @"没有相关信息" ;
    none.textColor = [UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] ;
    none.font = [UIFont systemFontOfSize:14];
    none.textAlignment = 1 ;
    none.hidden = YES ;
    [self.view addSubview:none];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _voucherArray.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90 ;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBvoucherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"voucherCell"];
    if (cell ==nil)
    {
        cell = [[DBvoucherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voucherCell"];
    }
    
    [cell config:_voucherArray[indexPath.row]];
    
    cell.selectionStyle = 0 ;
    
    return cell;
    
}

-(void)BtClick:(UIButton*)button
{
    
    if (button != _lastBt)
    {
        [_lastBt setTitleColor:[UIColor colorWithRed:0.66 green:0.67 blue:0.67 alpha:1] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor colorWithRed:0.95 green:0.78 blue:0.11 alpha:1] forState:UIControlStateNormal];
        
        _lastBt = button ;
        

        [UIView animateWithDuration:0.01 animations:^{
            
            
            CGRect frame = _botView.frame ;
            

            frame = CGRectMake(button.frame.origin.x, 28, button.frame.size.width, 2);
            
            _botView.frame = frame ;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        
        switch (button.tag) {
            case 650:
                _state = @"2";
                break;
            case 651:
                _state = @"4";
                break;
            case 652:
                _state = @"5";
                break;
                
            default:
                break;
        }

        [self loadData];
        
    }
    
    
}

#pragma mark -- 导航栏点击事件
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showView{
    
    
    
    [TCAlertView shareManage].field.field.text = @"";
    [TCAlertView shareManage].field.field.delegate = self ;
    [[TCAlertView shareManage]showAlertWithMessage:@"兑换优惠券" Block:^{

        [self.tipView removeFromSuperview];
        if ([[TCAlertView shareManage].field.field.text isEqualToString:@""]) {
            
            [self tipShow:@"请输入兑换码"];
        }
        else{
            
            [self exchangeCoupon] ;
        }
        
    }];
    
}

//兑换优惠券

-(void)exchangeCoupon{
    [self addProgress];

    NSString * newStr = [[TCAlertView shareManage].field.field.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * url = [NSString stringWithFormat:@"%@/api/me/coupon/receive?number=%@",Host,newStr];
    
    [DBNetworkTool exchangeCouponPost:url parameters:nil success:^(id responseObject) {
        
        [[TCAlertView shareManage] closeView];
        
        if ([[responseObject allKeys]containsObject:@"message"]) {
            
            if ([[responseObject objectForKey:@"message"]isKindOfClass:[NSString class]]) {
                
                [self tipShow:[responseObject objectForKey:@"message"]];
                
                if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {

                }
                else{
                    [TCAlertView shareManage].field.field.text = @"" ;
                }
            }
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"]) {
                
                [self loadData];
            }
        });
        
        [self removeProgress];
       
    } failure:^(NSError *error) {
        
        [self tipShow:@"连接失败"];

    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    DBLog(@"%@",toBeString);
    if ([TCAlertView shareManage].field.field == textField)  //判断是否时我们想要限定的那个输入框
    {
        NSString *CT = @"^[A-Za-z0-9]+$";
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if ([regextestct evaluateWithObject:toBeString] == YES)
        {
            return YES ;
        }
        else if ([toBeString isEqualToString:@""]){
            return YES ;
        }
        
    }
    return  NO ;

}



- (void)tipShow:(NSString *)str
{
    
    self.tipView = [[DBTipView alloc]initWithHeight:0.8 * ScreenHeight WithMessage:str];
    [self.view addSubview:self.tipView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarHid" object:nil];
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"tabBarShow" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat]pageviewStartWithName:@"优惠券页面"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[BaiduMobStat defaultStat]pageviewEndWithName:@"优惠券页面"];
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
