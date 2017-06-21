//
//  DetailGoodsModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailGoodsModel.h"

@implementation DetailGoodsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"cmGoodsDetailsList" : [Cmgoodsdetailslist class]};
}

@end


@implementation Cmgoodsdetailslist

@end


@implementation Productsku

+ (NSDictionary *)objectClassInArray{

    return @{@"reluJson" : [Relujson class]};

}

@end


@implementation Relujson

@end



