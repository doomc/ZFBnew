//
//  dateTimeHelper.h
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dateTimeHelper : NSObject

//转换成北京时间字符串
+ (NSString *)htcTimeToLocationStr:(NSDate*)curDate;
//格式不同
+ (NSString *)TimeToLocationStr:(NSDate*)curDate;

+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo ;

@end
