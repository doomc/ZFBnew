//
//  ShopCarJsonModel.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarJsonModel.h"

@implementation ShopCarJsonModel

@end

@implementation UserGoodsInfoJSON

+(NSDictionary *)objectClassInArray
{
    return @{
             @"userGoodsInfoJSON" :[UserGoodsInfoJSON class],
             };
}

@end

@implementation JsonGoodslist

+(NSDictionary *)objectClassInArray
{
    return @{
             @"goodsList":[JsonGoodslist class],
             };
}



@end