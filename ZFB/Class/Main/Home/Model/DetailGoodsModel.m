//
//  DetailGoodsModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailGoodsModel.h"

@implementation DetailGoodsModel

 

@end


@implementation detailData

+ (NSDictionary *)objectClassInArray{
    return @{@"productAttribute" : [Productattribute class]};
}

@end


@implementation Goodsinfo

@end

 

@implementation Storeinfo

@end


@implementation Productattribute

+ (NSDictionary *)objectClassInArray{
    return @{@"valueList" : [Valuelist class]};
}

@end


@implementation Valuelist

-(instancetype)init {
    
    self = [super init];
    if (self) {
        _selectType = ValueSelectType_normal;
    }
    return self;
}
@end


