//
//  ZFEncryptionKey.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEncryptionKey.h"

static  NSString  * MD5_key = @"1233@sdf%22dscE3";//全局

@implementation ZFEncryptionKey



-(NSDictionary *)signStringWithParamdic:(NSDictionary *)param
{
    // 固定参数
    NSDate *date = [NSDate date];
    NSString *DateTime =  [dateTimeHelper htcTimeToLocationStr: date];
    NSString * transactionTime = DateTime;
    NSString * transactionId = DateTime;
    
    // 实际参数生成data
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString * jsonStr = [NSString convertToJsonData:dataParam];
    NSString * data = [NSString base64:jsonStr];
    if (BBUserDefault.cmUserId  == nil) {
        BBUserDefault.cmUserId =@"";
    }
    
    
    // 添加默认参数
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"signType":@"MD5",
                                                                                     @"transactionTime":transactionTime,
                                                                                     @"transactionId":transactionId,
                                                                                     @"data":data,
                                                                                     }];
    
    // sign签名（MD5规则）
    NSArray *keyArray = [paramDict allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                          {
                              return [obj1 compare:obj2 options:NSNumericSearch];
                          }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        
        [valueArray addObject:[paramDict objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    ///判断如果登录成功了  给一个登陆状态
    _md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],MD5_key];
    
    if (BBUserDefault.isLogin == YES) {///判断如果登录成功了  给一个登陆状态
        
        _md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],BBUserDefault.userKeyMd5];
        
    }
    NSString * sign =  [MD5Tool MD5ForLower32Bate:_md5String];
    
    // 添加sign 参数
    [paramDict setValue:sign forKey:@"sign"];
    
    return paramDict;
}
@end

