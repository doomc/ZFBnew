//
//  StoreListModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreListModel.h"

@implementation StoreListModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"storeId" : @"storeId",
             @"storeName" : @"storeName",
             @"likeNum" : @"likeNum",
             @"urls" : @"urls",
             @"thumbnailUrls" : @"thumbnailUrls",
             @"juli": @"juli",
             @"resultCode": @"resultCode",
 
             };
}

@end
