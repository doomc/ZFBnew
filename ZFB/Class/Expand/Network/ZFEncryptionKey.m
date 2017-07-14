//
//  ZFEncryptionKey.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFEncryptionKey.h"
#import "AppDelegate.h"
//static  NSString  * MD5_key = @"1233@sdf%22dscE3";//全局

@implementation ZFEncryptionKey

-(NSDictionary *)signStringWithParamdic:(NSDictionary *)param
{
//    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"isLogin====%d",BBUserDefault.isLogin);
    
    if (BBUserDefault.isLogin == 1) {
    
        _MD5_key = BBUserDefault.userKeyMd5 ;
    
    }else{
        BBUserDefault.cmUserId = @"";
        _MD5_key = @"1233@sdf%22dscE3";//全局
    }
    NSLog(@" ////////登录状态  = %d --------- _MD5_key 值== %@ ///////////",BBUserDefault.isLogin,BBUserDefault.userKeyMd5 );

    // 固定参数
    NSDate * date = [NSDate date];
    NSString * DateTime =  [dateTimeHelper htcTimeToLocationStr: date];
    NSString * transactionTime = DateTime;
    NSString * transactionId = DateTime;
    
    // 实际参数生成data
    NSMutableDictionary *dataParam = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString * jsonStr = [NSString convertToJsonData:dataParam];
    NSString * data = [NSString base64:jsonStr];
    
    NSLog(@"data ====%@",data);
    if (BBUserDefault.cmUserId == nil) {
        BBUserDefault.cmUserId = @"";
    }
    
    NSLog(@" ======= cmUserId=======%@",BBUserDefault.cmUserId );
    // 添加默认参数
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"signType":@"MD5",
                                                                                     @"transactionTime":transactionTime,
                                                                                     @"transactionId":transactionId,
                                                                                     @"data":data,
                                                                                     @"userId":BBUserDefault.cmUserId,
                                                                                     
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
        NSString *ValueStr = [NSString stringWithFormat:@"%@",valueArray[i]];
        //////重要
        if (!kStringIsEmpty(ValueStr)) {//如果有value为空不参与加密
            [signArray addObject:keyValueStr];
        }
    }
    
    NSString * md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],_MD5_key];
  
    NSString * sign =  [MD5Tool MD5ForLower32Bate:md5String];
    
    // 添加sign 参数
    [paramDict setValue:sign forKey:@"sign"];
 
    return paramDict;
}


- (NSDictionary *)signStringWithParamdic:(NSDictionary *)param andMD5Key:(NSString* )MD5key
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
    
    NSLog(@"_MD5_key = %@",BBUserDefault.userKeyMd5);
    
    NSString * md5String =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],MD5key];
    
    NSString * sign =  [MD5Tool MD5ForLower32Bate:md5String];
    
    // 添加sign 参数
    [paramDict setValue:sign forKey:@"sign"];
    
    return paramDict;
}

@end

