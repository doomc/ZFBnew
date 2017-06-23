//
//  ShoppingCarModel.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

+ (NSDictionary *)objectClassInArray{
    return @{@"shoppCartList" : [Shoppcartlist class]};
}
@end


@implementation Shoppcartlist

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsList" : [Goodslist class]};
}

@end


@implementation Goodslist


@end


