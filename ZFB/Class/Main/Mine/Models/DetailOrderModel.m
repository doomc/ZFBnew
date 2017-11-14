//
//  DetailOrderModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailOrderModel.h"

@implementation DetailOrderModel

 

+ (NSDictionary *)objectClassInArray{
    return @{@"unpayOrderInfo" : [Unpayorderinfo class]};
}
@end

@implementation DetailShoppcartlist

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsList" : [DetailGoodslist class]};
}

@end


@implementation DetailGoodslist

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsProperties" : [OrderGoodsProperties class]};
}
@end

@implementation OrderGoodsProperties

@end

@implementation Orderdetails

@end


@implementation Deliveryinfo

@end

@implementation DetailcmUserInfo

@end


@implementation Unpayorderinfo

@end


