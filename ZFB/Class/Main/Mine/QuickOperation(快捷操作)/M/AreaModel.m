
//
//  AreaModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [AreaData class]};
}
@end
@implementation AreaData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"areaId":@"id",
             };
}

@end
