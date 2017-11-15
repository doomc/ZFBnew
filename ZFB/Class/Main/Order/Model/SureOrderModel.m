//
//  SureOrderModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SureOrderModel.h"

@implementation SureOrderModel


+ (NSDictionary *)objectClassInArray{
    return @{
             @"storeDeliveryfeeList" : [Storedeliveryfeelist class],
             @"deliveryFeeList" : [AlldeliveryFeeList class]
             };
}



@end
@implementation AlldeliveryFeeList

@end

@implementation Storedeliveryfeelist

@end

