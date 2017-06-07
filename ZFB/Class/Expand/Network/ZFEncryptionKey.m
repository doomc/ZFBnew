//
//  ZFEncryptionKey.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEncryptionKey.h"

static const NSString  * MD5_key = @"1233@sdf%22dscE3";//全局

@implementation ZFEncryptionKey

-(NSString *)signStringWithParam:(NSDictionary *)param
{
    NSArray *keyArray = [param allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[param objectForKey:sortString]];
        
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        NSString * valueStr = [NSString stringWithFormat:@"%@",valueArray[i]];
       
        if (!kStringIsEmpty(valueStr)) {//安全操作 判断是不是value有空值
            
            [signArray addObject:keyValueStr];
        }
    }
  
    NSString * md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],MD5_key];
   
    NSLog(@"signStr = %@",md5String);
    
    NSString * sign =  [MD5Tool MD5ForLower32Bate:md5String];
    
    return sign;
}


@end
