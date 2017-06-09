//
//  dateTimeHelper.m
//  MobileProject
//
//  Created by wujunyang on 16/7/20.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "dateTimeHelper.h"

@implementation dateTimeHelper

+ (NSString *)htcTimeToLocationStr:(NSDate*)curDate
{
    if (curDate==nil) {
        return @"";
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
   
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:curDate];
    return fixString;
}

//倒计时工具
+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
