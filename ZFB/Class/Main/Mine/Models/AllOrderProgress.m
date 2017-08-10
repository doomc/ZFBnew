//
//  AllOrderProgress.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllOrderProgress.h"

@implementation AllOrderProgress

@end
@implementation ProgressData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [List class]};
}

@end


@implementation List

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"saleId":@"id"
             };
}
@end


