//
//  SkuMatchModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SkuMatchModel.h"

@implementation SkuMatchModel

@end
@implementation SkuData

+ (NSDictionary *)objectClassInArray{
    return @{@"skuMatch" : [Skumatch class]};
}

@end


@implementation Skumatch

+ (NSDictionary *)objectClassInArray{
    return @{@"valuList" : [SkuValulist class]};
}

@end


@implementation SkuValulist
 
+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"typeId":@"id"
             };
}
@end


