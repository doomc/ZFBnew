//
//  ReviewingModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  审核中模型

#import "ReviewingModel.h"

@implementation ReviewingModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [ReViewData class]};
}
@end
@implementation ReViewData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return  @{@"goodsId":@"id"};
}
@end


