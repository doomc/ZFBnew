//
//  NSString+JsonChange.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/7.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonChange)
//1.字典转Json字符串
+ (NSString *)convertToJsonData:(NSDictionary *)dict;


//2. JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//数组转json
+ (NSString *)arrayToJSONString:(NSArray *)array;


//MD5 加密 排序
+(NSString *)singmd5:(NSDictionary *)JSONDic MD5KEY:(NSString *)MD5KEY ;

//base64转换
+(NSString *)base64:(NSString *)dataStr;

@end
