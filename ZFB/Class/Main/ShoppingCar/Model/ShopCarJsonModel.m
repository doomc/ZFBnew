//
//  ShopCarJsonModel.m
//  ZFB
//
//  Created by 熊维东 on 2017/7/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShopCarJsonModel.h"

@implementation ShopCarJsonModel



+ (NSDictionary *)objectClassInArray{
    return @{@"StoreList" : [StoreList class]};
}
@end
@implementation StoreList

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsList" : [UserJsonGoodslist class]};
}

@end


@implementation UserJsonGoodslist

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsProp" : [UserJsonGoodsprop class]};
}

@end


@implementation UserJsonGoodsprop

@end


