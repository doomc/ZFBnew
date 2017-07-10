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

-(NSDictionary *)signStringWithParam:(NSDictionary *)param 
{
    //获取当前时间
    NSDate *date = [NSDate date];
    NSString *DateTime =  [dateTimeHelper htcTimeToLocationStr: date];

    //创建一个临时dataParam 接收源数据
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [dataParam removeObjectForKey:@"svcName"];
    
    NSString * jsonStr = [NSString convertToJsonData:dataParam];
    NSString * data = [NSString stringWithBase64EncodedString:jsonStr];
    
    //通用MD5_KEY
    NSString * transactionTime = DateTime;//当前时间
    NSString * transactionId = DateTime; //每个用户唯一
    //    NSLog(@"%@",DateTime);
    
    //    signDict 原来的参数进行封装
    NSDictionary *signDict = @{
                               
//                               @"svcName":[param objectForKey:@"svcName"],
                               @"signType":@"MD5",
                               @"transactionTime":transactionTime,
                               @"transactionId":transactionId,
                               @"data":data,
                               };
    
    NSArray *keyArray = [signDict allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSString *sortString in sortArray) {
        
        [valueArray addObject:[signDict objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        NSString * valueStr = [NSString stringWithFormat:@"%@",valueArray[i]];
        
        if ( !kStringIsEmpty(valueStr)) {
            
            [signArray addObject:keyValueStr];
        }
    }
  
    //md5key拼接签名
    NSString * md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],MD5_key];
    NSLog(@"signStr = %@",md5String);
    
    //sign 加密验证 +MD5ss
    NSString * sign =  [MD5Tool MD5ForLower32Bate:md5String];
    
    NSDictionary *signDic2 = @{
//                               @"cmUserId":BBUserDefault.cmUserId,
                               @"signType":@"MD5",
                               @"transactionTime":transactionTime,
                               @"transactionId":transactionId,
                               @"data":data,
                               };
    
    NSMutableDictionary *muParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [muParam addEntriesFromDictionary:signDic2];
    
    [muParam setObject:sign forKey:@"sign"];
    
    NSLog(@"muParam = = %@ =  parma",muParam);

    return muParam;
}



@end
