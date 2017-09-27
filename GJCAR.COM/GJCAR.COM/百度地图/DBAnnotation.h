//
//  DBAnnotation.h
//  ShenHuaCar
//
//  Created by 段博 on 16/3/23.
//  Copyright © 2016年 DuanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKAnnotation.h"

@interface DBAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;


@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString  *iconImgName;




@end
