
//
//  DBSystemSetViewController.m
//  GJCAR.COM
//
//  Created by 段博 on 16/7/20.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBSystemSetViewController.h"

@interface DBSystemSetViewController ()<UIAlertViewDelegate>
{
    NSString *cachePath;

    
}
@end

@implementation DBSystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavigation];
    
    
    [self setUI];
}



#pragma mark 创建界面

#pragma mark --创建导航栏
-(void)setNavigation
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    DBNavgationView * nav = [[DBNavgationView alloc]initNavgationWithTitle:@"设置" withLeftBtImage:@"back" withRightImage:nil withFrame:CGRectMake(0, 0, ScreenWidth , 64)];
    [self.view addSubview:nav];
    
    [nav.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setUI
{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 80)];
    [self.view addSubview:baseView];
    
    
    //循环创建
    
    for (int i = 0 ; i < 2; i ++)
    {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + i * 40  , ScreenWidth, 0.5)];
        lineView.backgroundColor  =  [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1];
        [baseView addSubview:lineView];
        
        
    }

    
    //清除缓存
    UILabel * clear = [[UILabel alloc]initWithFrame:CGRectMake( 20, 0, ScreenWidth-20, 40)];
    [baseView addSubview:clear];
    clear.text = @"清除缓存";
    clear.font = [UIFont systemFontOfSize:14];
    clear.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];


    
    //缓存大小
    UILabel * cacheFloat = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 70, clear.frame.origin.y, 50, 40)];
    
    cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    cacheFloat.text = [NSString stringWithFormat:@"%.2fM",[DBcommonUtils folderSizeAtPath:cachePath]];
    cacheFloat.font = [UIFont systemFontOfSize:12];
    cacheFloat.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
    [baseView addSubview:cacheFloat];
    cacheFloat.tag = 555 ;

    
    
    //清除缓存点击事件
    UIControl * cleatControl = [[UIControl alloc]initWithFrame:CGRectMake(0, clear.frame.origin.y, ScreenWidth, 40)];
    [cleatControl addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
    
    
    [baseView addSubview:cleatControl];

    
//    
//    //更新版本
//    UILabel * version = [[UILabel alloc]initWithFrame:CGRectMake( 20, 40, ScreenWidth-20, 40)];
//    [baseView addSubview:version];
//    version.text = @"版本";
//    version.font = [UIFont systemFontOfSize:14];
//    version.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
//
//    
//    //版本号
//    
//    NSString*str = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];
//
//    
//    UILabel * versionNumber = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 70, version.frame.origin.y, 50, 40)];
//    
//    versionNumber.text = [NSString stringWithFormat:@"v%@",str];
//    [baseView addSubview:versionNumber];
//    versionNumber.font = [UIFont systemFontOfSize:12];
//    versionNumber.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1];
//
//    
//    //更新点击事件
//    UIControl * versionControl = [[UIControl alloc]initWithFrame:CGRectMake(0, version.frame.origin.y, ScreenWidth, 40)];
////    versionControl.backgroundColor = [UIColor greenColor ];
//    [versionControl addTarget:self action:@selector(loadVersion) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [baseView addSubview:versionControl];

    
}

-(void)clearCache
{
    
    
    UILabel * label = [self.view viewWithTag:555];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [DBcommonUtils clearCache:cachePath];
        label.text = [NSString stringWithFormat:@"%.2fM",[DBcommonUtils folderSizeAtPath:cachePath]];

                     }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancleAction];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
    
    
    
    

   


}



#pragma mark 检测新版本


-(void)loadVersion
{
    

    
    
    
    
    NSString * url =[NSString stringWithFormat:@"http://www.feeling.hpecar.com/api/appManage/latest?appType=1"];
    
    
    [DBNetworkTool Get:url parameters:nil success:^(id responseObject)
     {
        
         if ([[responseObject objectForKey:@"status"]isEqualToString:@"true"])
         {
             
             if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSNull class]] || [responseObject objectForKey:@"message"] ==nil)
             {
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为最新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];

                 UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                 
                 [alertController addAction:cancleAction];
                 
//                 [alertController addAction:okAction];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
                 
                 
             }
             else
             {
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可供更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1151833888"]];
                     
                 }];
                 
                 UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                 
                 [alertController addAction:cancleAction];
                 
                 [alertController addAction:okAction];
                 [self presentViewController:alertController animated:YES completion:nil];
                 
            }
             
         }
         
         
     } failure:^(NSError *error) {
         
     }];
    
}



-(void)checkVersion:(NSString*)version
{
    
    
    //判断新版本
    
    NSString*str = [[NSBundle mainBundle]objectForInfoDictionaryKey:(NSString*)@"CFBundleShortVersionString"];
    
    
    
    if (![[NSString stringWithFormat:@"v%@",str] isEqualToString:version])
    {
        
        [ self update];
        
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为最新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        //                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确性" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/7ab5"]];
        //
        //                 }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:cancleAction];
        
        //                 [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 1)
    {
        [self update];
        //[NSString stringWithFormat:@"tel://%@",[[self.infoDic objectForKey:@"takeCarStore"]objectForKey:@"phone"]]
    }
}


- (void)update {
    
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可供更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/7a8c"]];
    //
    //    }];
    //
    //    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    //
    //    [alertController addAction:cancleAction];
    //
    //    [alertController addAction:okAction];
    //
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = infoDict[@"CFBundleShortVersionString"];
    NSString *url = [[NSString alloc] initWithFormat:@"http://itunes.apple.com/lookup?id=%@", @"1151833888"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript", nil];
    
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSNumber *number = responseObject[@"resultCount"];
        
        if (number.intValue == 1) {
            
            NSString *newVersion = responseObject[@"results"][0][@"version"];
            
            if (![newVersion isEqualToString:oldVersion]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可供更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1151833888"]];
                    
                }];
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:cancleAction];
                
                [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前为最新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                //                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确性" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                //                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/7ab5"]];
                //
                //                 }];
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:cancleAction];
                
                //                 [alertController addAction:okAction];
                
                [self presentViewController:alertController animated:YES completion:nil];

            }
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"数据错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:cancleAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
      

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"数据错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:cancleAction];

          [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"%@", error);
        
    }];
    
}



-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
