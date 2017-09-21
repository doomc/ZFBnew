//
//  ShareWaterFullModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareWaterFullModel.h"

@implementation ShareWaterFullModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [ShareGoodsData class]};
}
@end
@implementation ShareGoodsData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
  return @{@"thumsId": @"id"};}

@end


