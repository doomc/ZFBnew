
//
//  ClearingStoreList.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ClearingStoreList.h"

@implementation ClearingStoreList


+ (NSDictionary *)objectClassInArray{
    return @{@"productList" : @"Productlist"};
}
@end



@implementation Productlist

+ (NSDictionary *)objectClassInArray{
    return @{@"cmGoodsList" :  @"Cmmgoodslist"};
}

@end


@implementation Cmmgoodslist

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsProp" : @"Goodsprop"};
}

@end


@implementation Goodsprop

@end


