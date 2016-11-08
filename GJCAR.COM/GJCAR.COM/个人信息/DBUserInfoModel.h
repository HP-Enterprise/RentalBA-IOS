//
//  DBUserInfoModel.h
//  GJCAR.COM
//
//  Created by 段博 on 16/7/13.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import "JSONModel.h"

@interface DBUserInfoModel : JSONModel

@property (nonatomic,strong)NSString * id ;
@property (nonatomic,strong)NSString * nickName;
@property (nonatomic,strong)NSString <Optional> * realName ;
@property (nonatomic,strong)NSString  * gender ;
@property (nonatomic,strong)NSString  <Optional> * birth ;

@property (nonatomic,strong)NSString  <Optional> * country ;
@property (nonatomic,strong)NSString  <Optional> * address ;
@property (nonatomic,strong)NSString  <Optional> * postCode ;
@property (nonatomic,strong)NSString  <Optional> * phone ;
@property (nonatomic,strong)NSString  <Optional> * email ;
@property (nonatomic,strong)NSString  * emailStatus ;
@property (nonatomic,strong)NSString  <Optional> * credentialType ;
@property (nonatomic,strong)NSString  <Optional> * credentialNumber ;
@property (nonatomic,strong)NSString  <Optional> * contactPerson ;

@property (nonatomic,strong)NSString  <Optional> * contactPhone ;

@property (nonatomic,strong)NSString  <Optional> * registerWay ;
@property (nonatomic,strong)NSString  <Optional> * customerSource ;
@property (nonatomic,strong)NSString  <Optional> * modifyDate ;
@property (nonatomic,strong)NSString  <Optional> * modifyUser ;
@property (nonatomic,strong)NSString  <Optional> * createDate ;
@property (nonatomic,strong)NSString  <Optional> * createUser ;
@property (nonatomic,strong)NSString  <Optional>* lvl ;
@property (nonatomic,strong)NSString  <Optional>* expirydate ;
@property (nonatomic,strong)NSString  <Optional> * isEnable ;

/*
 
 "id": 22,
 "nickName": "15827653951",
 "realName": null,
 "gender": 1,
 "birth": null,
 
 "country": null,
 "address": null,
 "postCode": null,
 "phone": "15827653951",
 "email": null,
 "emailStatus": 0,
 "credentialType": null,
 "credentialNumber": null,
 
 "contactPerson": null,
 "contactPhone": null,
 "registerWay": null,
 "customerSource": null,
 "modifyDate": null,
 "modifyUser": null,
 "createDate": null,
 "createUser": null,
 "lvl": 1,
 "expirydate": 1499788799000,
 "isEnable": null
 
 */

@end
