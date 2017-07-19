//
//  JsonModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "JsonModel.h"

@implementation JsonModel

+ (NSDictionary *)objectClassInArray{
    return @{@"userGoodsInfoJSON" : [Usergoodsinfojson class]};
}
@end

@implementation Usergoodsinfojson

+ (NSDictionary *)objectClassInArray{
    return @{@"goodsList" : [JosnGoodslist class]};
}

@end


@implementation JosnGoodslist

@end


