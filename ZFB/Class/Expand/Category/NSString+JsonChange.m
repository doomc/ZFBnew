
//
//  NSString+JsonChange.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "NSString+JsonChange.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation NSString (JsonChange)

// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSString *jsonString;
    

    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{

        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
 
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
 
    
    return mutStr;
    
}
//2. JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//数组转json
+ (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    if (array.count > 0) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        return jsonString;
    }
    
    return nil;
}

+(NSString*)ObjectTojsonString:(id)object
{
    NSString *jsonString = [[NSString   alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:object options:NSJSONWritingPrettyPrinted  error:&error];
    
    if (! jsonData) {
        
        NSLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString  alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString === %@",jsonString);

    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@"" options:NSLiteralSearch range:range2];
    
    NSRange range3 = {0, mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range3];
    
//    NSLog(@"mutStr ====%@",mutStr);
    
    return mutStr;
    
}

+(NSString *)base64:(NSString *)dataStr;
{
    NSData *strData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseStr = [strData base64EncodedStringWithOptions:0];
    return baseStr;
}

+ (NSString *)singmd5:(NSDictionary *)JSONDic MD5KEY:(NSString *)MD5KEY {
    
    // 校验数据是否被篡改
    NSMutableString *JSONStr = [NSMutableString string];
    NSArray *JSONArr = [JSONDic allKeys];
    JSONArr = [JSONArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    for (NSString *dicKeyStr in JSONArr) {
        if ([dicKeyStr isEqualToString:@"sign"]) {
            
        }else{
            [JSONStr appendFormat:@"%@=%@|",dicKeyStr,JSONDic[dicKeyStr]];
        }
    }
    [JSONStr appendFormat:@"%@", MD5KEY];
    
    const char *cStr = [JSONStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr),digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}


@end
