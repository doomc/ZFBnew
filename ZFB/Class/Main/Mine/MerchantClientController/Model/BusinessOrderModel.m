
//
//  BusinessOrderModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BusinessOrderModel.h"

@implementation BusinessOrderModel


+ (NSDictionary *)objectClassInArray{
    return @{@"orderList" : [BusinessOrderlist class]};
}
@end
@implementation BusinessOrderlist

+ (NSDictionary *)objectClassInArray{
    return @{@"orderGoods" : [BusinessOrdergoods class]};
}

@end


@implementation BusinessOrdergoods
+ (NSDictionary *)objectClassInArray{
    return @{@"goods_properties" : [BusinessOrderproperties class]};
}

@end
@implementation BusinessOrderproperties

@end


