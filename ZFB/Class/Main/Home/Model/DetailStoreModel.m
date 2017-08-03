//
//  DetailStoreModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailStoreModel.h"

@implementation DetailStoreModel


+ (NSDictionary *)objectClassInArray{
    return @{@"cmGoodsList" : [DetailCmgoodslist class]};
}
@end
@implementation Cmstoredetailslist
+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"typeId":@"id"
             };
}
@end


@implementation DetailCmgoodslist

@end


