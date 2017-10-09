//
//  AccountModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel


+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [accountData class]};
}
@end
 
@implementation accountData

+ (NSDictionary *)objectClassInArray{
    return @{@"cashFlowList" : [Cashflowlist class]};
}

@end


@implementation Cashflowlist

@end


