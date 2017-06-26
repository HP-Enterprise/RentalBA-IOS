
//
//  DBOrderData.m
//  GJCAR.COM
//
//  Created by 段博 on 2016/10/10.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "DBOrderData.h"


#import "DBShowListModel.h"

#import "DBActivityShows.h"


@implementation DBOrderData

+(NSMutableDictionary*)createOrderInfoWithPriceDic:(NSDictionary*)priceDic CarDic:(DBCarModel *)carModel Price:(NSString*)price PayWay:(NSString*)payWay WithAddValueArr:(NSArray*)_addValueArr{
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    
    
    NSMutableDictionary * parDic = [NSMutableDictionary dictionary];

    
    
    parDic[@"averagePrice"] =[NSString stringWithFormat:@"%@",[priceDic objectForKey:@"averagePrice"]];
    parDic[@"basicInsuranceAmount"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"basicInsuranceAmount"]];
    parDic[@"rentalAmount"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"totalAmount"]];
    parDic[@"payAmount"] = price ;
    parDic[@"tenancyDays"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"daySum"]];
    
    parDic[@"totalTasicInsuranceAmount"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"totalBasicInsuranceAmount"]];
    
    parDic[@"timeoutPrice"] =[NSString stringWithFormat:@"%@",[priceDic objectForKey:@"delayAmount"]];
    
    parDic[@"totalTimeoutPrice"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"totalDelayAmount"]];
    
    if ([[priceDic objectForKey:@"toStoreReduce"]isKindOfClass:[NSNull class]]) {
        parDic[@"toStoreReduce"] = @"";
    }
    else{
         parDic[@"toStoreReduce"] = [NSString stringWithFormat:@"%@",[priceDic objectForKey:@"toStoreReduce"]];
    }
   
   
    
    parDic[@"prepay"] = [priceDic objectForKey:@"totalPrepayAmount"] ;
    
    parDic[@"brandId"] =[NSString stringWithFormat:@"%@",carModel.vehicleModelShow.brandId];
    
    
    DBShowListModel * model = [carModel.vendorStorePriceShowList firstObject] ;
    
    parDic[@"modelId"] = [NSString stringWithFormat:@"%@",model.modelId];
    
    
    parDic[@"orderState"] = @"1";
    
    
    parDic[@"payWay"] = payWay;
    
    
    
    parDic[@"source"] = @"5";
    
    
    parDic[@"rentalId"] = [priceDic objectForKey:@"rentalIds"];
    
    
    
    NSMutableArray * array = [NSMutableArray array];
    
    //    //送车上门参数
    if ([[user objectForKey:@"takeState"]isEqualToString:@"0"])
    {
        parDic[@"orderType"] = @"2";
        parDic[@"returnCarLatitude"] =  [[user objectForKey:@"returnPlace"]objectForKey:@"latitude"];
        parDic[@"returnCarLongitude"] = [[user objectForKey:@"returnPlace"]objectForKey:@"longitude"];
        parDic[@"serviceType"] = @"3";
        parDic[@"returnCarAddress"] =[NSString stringWithFormat:@"%@%@",[[user objectForKey:@"returnPlace"]objectForKey:@"name"],[[user objectForKey:@"returnPlace"]objectForKey:@"address"]];
        
        
        DBShowListModel * store = [carModel.vendorStorePriceShowList firstObject];
        parDic[@"returnCarStoreId"] = store.storeId;
        
        
        parDic[@"takeCarStoreId"] = store.storeId;
        parDic[@"takeCarLatitude"]  = [[user objectForKey:@"takePlace"]objectForKey:@"latitude"];
        parDic[@"takeCarLongitude"] = [[user objectForKey:@"takePlace"]objectForKey:@"longitude"];
        
        parDic[@"takeCarAddress"]   = [NSString stringWithFormat:@"%@%@",[[user objectForKey:@"takePlace"]objectForKey:@"name"],[[user objectForKey:@"takePlace"]objectForKey:@"address"]];
        
        NSLog(@"%@",parDic[@"returnCarLatitude"]);
        NSLog(@"%@",parDic[@"returnCarLongitude"]);
        NSLog(@"%@",parDic[@"returnCarAddress"]);
        NSLog(@"%@",parDic[@"returnCarStoreId"]);
        
    }
    
    //门店取车参数
    else
    {
        
        // parDic[@"returnCarLatitude"] =  [[user objectForKey:@"returnStore"]objectForKey:@"latitude"];
        //parDic[@"returnCarLongitude"] = [[user objectForKey:@"returnStore"]objectForKey:@"longitude"];
        parDic[@"serviceType"] = @"0";
        parDic[@"orderType"] = @"1";
        parDic[@"returnCarAddress"] = [[user objectForKey:@"returnStore"]objectForKey:@"storeName"];
        parDic[@"returnCarStoreId"] = [[user objectForKey:@"returnStore"]objectForKey:@"id"];
        
        //parDic[@"takeCarLatitude"]  = [[user objectForKey:@"takeStore"]objectForKey:@"latitude"];
        //parDic[@"takeCarLongitude"] = [[user objectForKey:@"takeStore"]objectForKey:@"longitude"];
        
        parDic[@"takeCarAddress"] = [[user objectForKey:@"takeStore"]objectForKey:@"storeName"];
        parDic[@"takeCarStoreId"] =[[user objectForKey:@"takeStore"]objectForKey:@"id"];
        
        NSLog(@"%@",parDic[@"returnCarLatitude"]);
        NSLog(@"%@",parDic[@"returnCarLongitude"]);
        NSLog(@"%@",parDic[@"returnCarAddress"]);
        NSLog(@"%@",parDic[@"returnCarStoreId"]);
        
  
    }
    
    //手续费
    NSMutableDictionary * poundageAmount = [NSMutableDictionary dictionary];
    NSDictionary * details = [[[priceDic objectForKey:@"poundageAmount"]objectForKey:@"details"]firstObject];
    
    
    poundageAmount[@"serviceAmount"] = [NSString stringWithFormat:@"%@",[details objectForKey:@"price"]];
    poundageAmount[@"serviceId"] = [NSString stringWithFormat:@"%@",[[priceDic objectForKey:@"poundageAmount"]objectForKey:@"chargeId"]];
    poundageAmount[@"description"] =[NSString stringWithFormat:@"%@",[[priceDic objectForKey:@"poundageAmount"]objectForKey:@"chargeName"]];
    [array addObject:poundageAmount];

    
     parDic[@"poundageAmount"] = [NSString stringWithFormat:@"%@",[details objectForKey:@"price"]];
    //增值服务
    
    if (_addValueArr.count>0)
    {
        for (NSDictionary * dic in _addValueArr)
        {
            NSDictionary * details =[[dic objectForKey:@"details"]firstObject];
            
            NSMutableDictionary * poundage = [NSMutableDictionary dictionary];
            
            if ([[dic objectForKey:@"chargeName"]isEqualToString:@"不计免赔"]){

                NSLog(@"%ld",[[priceDic objectForKey:@"daySum"]integerValue]);
            
                poundage[@"serviceAmount"] = [NSString stringWithFormat:@"%ld",[[details objectForKey:@"price"]integerValue]* [DBcommonUtils calculateRegardless:[[priceDic objectForKey:@"daySum"]integerValue]]] ;
                
            }
            else{
                poundage[@"serviceAmount"] = [NSString stringWithFormat:@"%@",[details objectForKey:@"price"]];
                
            }
            
            poundage[@"serviceId"] = [NSString stringWithFormat:@"%@",[dic objectForKey:@"chargeId"]];
            poundage[@"description"] = [NSString stringWithFormat:@"%@",[dic objectForKey:@"chargeName"]];
            
            [array addObject:poundage];
            
        }
        
    }
    
    
    if (![[priceDic objectForKey:@"doorToDoor"]isKindOfClass:[NSNull class]] && [priceDic objectForKey:@"doorToDoor"]  && [NSArray arrayWithArray:[priceDic objectForKey:@"doorToDoor"]].count > 0  ) {
        
        NSMutableDictionary * poundage = [NSMutableDictionary dictionary];
        
        NSDictionary  * difprice = [[NSArray arrayWithArray:[priceDic objectForKey:@"doorToDoor"]]firstObject];
        NSDictionary *difCostDic = [[NSArray arrayWithArray:[difprice objectForKey:@"details"]]firstObject] ;

        
        poundage[@"serviceAmount"] = [NSString stringWithFormat:@"%@",[difCostDic objectForKey:@"price"]] ;


        poundage[@"serviceId"] = [NSString stringWithFormat:@"%@",[difprice objectForKey:@"chargeId"]];
        poundage[@"description"] = [NSString stringWithFormat:@"%@",[difprice objectForKey:@"chargeName"]];

        [array addObject:poundage];
    }

    parDic[@"orderValueAddedServiceRelativeShow"] =  array;
    
    parDic[@"returnCarCity"] = [user objectForKey:@"returnCityId"];
    
    parDic[@"returnCarDate"] = [user objectForKey:@"returnTime"];
    
    parDic[@"takeCarCity"] = [user objectForKey:@"takeCityId"];
    
    parDic[@"takeCarDate"] = [user objectForKey:@"takeTime"];
    
    parDic[@"userId"] = [user objectForKey:@"userId"];
    
    parDic[@"vendorId"] = @"1";
    
    
    return parDic;
}

@end
