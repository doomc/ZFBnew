//
//  AllOrderModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllOrderModel.h"

@implementation AllOrderModel
 

+ (NSDictionary *)objectClassInArray{
    return @{@"orderList" : [Orderlist class]};
}
@end


@implementation Orderlist

+ (NSDictionary *)objectClassInArray{
    return @{@"orderGoods" : [Ordergoods class]};
}

@end


@implementation Ordergoods

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_properties" : [OrderProper class]};
}

@end

@implementation OrderProper


@end

