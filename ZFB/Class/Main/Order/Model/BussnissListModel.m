//
//  BussnissListModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BussnissListModel.h"

@implementation BussnissListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"userGoodsList" : [BussnissUserStoreList class]};
}

@end

@implementation BussnissUserStoreList

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsInfoList" : [BussnissGoodsInfoList class]};
}
@end


@implementation BussnissGoodsInfoList

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsProp" : [BussnissgoodsProp class]};
}
@end


@implementation BussnissgoodsProp


@end
