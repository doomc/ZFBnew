//
//  IMSearchResultModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "IMSearchResultModel.h"

@implementation IMSearchResultModel : NSObject
@end

@implementation IMSearchData

+ (NSDictionary *)objectClassInArray{
    return @{@"userInfo" : [IMSearchUserinfo class]};
}

@end


@implementation IMSearchUserinfo

@end
