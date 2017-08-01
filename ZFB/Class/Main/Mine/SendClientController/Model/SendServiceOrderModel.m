//
//  SendServiceOrderModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendServiceOrderModel.h"

@implementation SendServiceOrderModel
 


+ (NSDictionary *)objectClassInArray{
    return @{@"storeInfoMap" : [SendServiceStoreinfomap class]};
}
@end


@implementation SendServiceStoreinfomap

+ (NSDictionary *)objectClassInArray{
    return @{@"orderGoodsList" : [SendServiceOrdergoodslist class]};
}

@end


@implementation SendServiceOrdergoodslist

@end


