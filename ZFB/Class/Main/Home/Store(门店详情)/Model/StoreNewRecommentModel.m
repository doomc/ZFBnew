
//
//  StoreNewRecommentModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreNewRecommentModel.h"

@implementation StoreNewRecommentModel

@end

@implementation StoreRecommentData

+(NSDictionary *)objectClassInArray
{
    return @{@"recommentList":[StoreRecommentList class]};
}
@end

@implementation StoreRecommentList
+(NSDictionary *)objectClassInArray
{
    return @{@"goodsList":[StoreRecommentGoodsList class]};
}

@end

@implementation StoreRecommentGoodsList

@end
