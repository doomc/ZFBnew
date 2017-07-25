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
    return @{@"goodsList" : [DetailOrderGoodslist class]};
}

@end


@implementation DetailOrderGoodslist

@end


@implementation Orderdetails

@end


@implementation DetailCmuserinfo

@end


@implementation Unpayorderinfo

@end


