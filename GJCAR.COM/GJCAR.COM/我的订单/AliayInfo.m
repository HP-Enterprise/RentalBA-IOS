//
//  AliayInfo.m
//  GJCAR.COM
//
//  Created by 段博 on 16/8/16.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "AliayInfo.h"

//支付
#import "Order.h"
//
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation AliayInfo




#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO:(NSDictionary*)dic
{

    return [dic objectForKey:@"orderIdToAlipay"];

}



#pragma mark   ==============产生订单信息==============

- (void)generateData:(NSDictionary*)dic with:(NSString *)price{
    
    
    
    
    _product = [[Product alloc] init];
    _product.subject = @"赶脚租车";
    _product.body = [dic objectForKey:@"model"];
    
    _product.price = (float)[price integerValue];
//    _product.price = 0.01f ;
    
    [self clickAlipay:dic];
    
}
- (void)clickAlipay:(NSDictionary*)dic
{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = @"2088311106439495";
//    NSString *seller = @"huachen_zulin@163.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOEclJmrVzeQp9Hdk7VYvKFSH3UXIav/c/KEGxUt8HchGBYS14GJwhnvc07jGILVbReCS57d+pcZHw2E2RrqvDMyzx8LK5T8g649JTAMhwMwRoM/fbpVB0a95H229YBNhmCv2IHihhkGzYt8tZBbwTLun16AhB2CmqLxVXnyerUpAgMBAAECgYBF8OVSoWOlxfH+SIO+EmX5EVTowlkZ4XKa5OStPeq6eLPNF+mRO8Xs3PLMjc5tx/XvGfJ416smCw4U2zPBIzF5eZKAfsakpsLVXZEhdZlmqoJOiKakFCO18uTU4ve48fKeoyb6X8qxhZLeamA7km3Bjisb5L9Gt2Ak9ddRyBRAAQJBAPboZc4qUtN6JeADkEA56rU1C5H9Eny00pAGdRDDNPpDA4IJ/FecN5hsTlkZOk0ebeFjuvkPnCNb5xXOd/FNoSkCQQDpZrXNcqtF/EecVt4/riBaKp/Y40oyF4nL0VAwXCLr7FSILqgOjwpwaWLKXQWisoK4b6M6rE7/qJbrfaifQvQBAkEAz/uBTkIelN9Oqj22NDPVPqEZRvdbrEqRGBsoX19f7/OlL9QDiTUhK7cH5Eu47Z9VRcfBhu0cRDi1FoxeQph2yQJBAOHF1Aknahwp3I+TzCsnYe42mydvPd9Uu5uoHvyYs8Mped+92h0zKvLwTnrYHtJyAVctzmS8NzLBPzQO+qUMXAECQHSaXCxkfN6/M75BAcnYFgOYntbOekFwKAmTVb8au23Ul6/z6S1F3bQtrwcfj3OTs4tEVVhjUyCvGkhCCfmDGmg=";
    
    NSString *partner = @"2088221353698177";
    NSString *seller = @"zucheyun@b-car.cn";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALTC/6PbrpCw2IK5pNFwfJ9xmR5tpRkbcLcGHbuu0mB9cBeK5mzvGiCSQp1SYXaaNIsffA1wkKtuwTD2KXYraG1wh2bYNb8WtBTUtwJxLEHaPtMV9/uBrbqDfOtddp96KR+GnQEAF/6HkKsMfxf8mHzfrBv2kyQCbhiAVBrx6PzdAgMBAAECgYB+aYBuD0vdVE+V3E4vSgNdXgw/A17aWB5TYKuafYASiqbBUBolRHF5JdAARYRzdRQZ10LiAz6pJSNmIkCMq36zHXK6WakLn4iNmxKYuwkCvz0Jmk1EBurBIvrcmlESW1IPTp/EFVoD/6m4q133d3XsxjlVUCGZ5AFKX9+9eVWd4QJBANv8D9Af2zzPzhXyIQ4ajQnnC8yHaTWGTFHRk/+Nn114dpZNEfXZNs3Pog4I6epz+VgSw2du/0Dyafgmn2kmKoMCQQDSWwljq7BqYSRcuqvHPjmSRtaSo9WdQ5TnYW9J/mDgByfAMRYFeX0Xpls7BHDjo+MK+7jvth4zUpSnIeyJUx0fAkEAg/dzOQRTTejPlaS6Ja7R2xXqoxi8iap2EEMsiIraBoWkhkfXtWdIFDEx4z9/q/FErIwdAui4YarK3V22FasapwJBAIlLwAIc8mVMiCY59Jpz47G0qKJHaspdbNfkgXXDIUm3gdtwblYeaGZCPzNy/5ekxTDLAXb74BRRZxL7El7DL7MCQAN+bV2TmstYA7Ea2osPloAMZHuKZNhcgPr4gxMNLeWPlKjnnydY7Xg2xFvmmSfJ6Wh5et1wdpleXGeMArsx8YM=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    //
    //    /*
    //     *生成订单信息及签名
    //     */
    //    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [self generateTradeNO:dic]; //订单ID（由商家自行制定）
    order.subject = _product.subject; //商品标题
    order.body = _product.body; //商品描述
    order.totalFee = [NSString stringWithFormat:@"%.2f",_product.price]; //商品价格
    
    order.notifyURL =[NSString stringWithFormat:@"%@/api/alipay/notify",Host]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"GJCAR.COM";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            NSLog(@"reslut = %@",resultDic);
          
            
            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]]isEqualToString:@"9000"])
                
            {

                [[NSNotificationCenter defaultCenter]postNotificationName:@"PopView" object:nil];
                
            }

       
        }];
   
    }
}

@end
