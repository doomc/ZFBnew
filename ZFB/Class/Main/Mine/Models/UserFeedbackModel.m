//
//  UserFeedbackModel.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  用户反馈模型

#import "UserFeedbackModel.h"

@implementation UserFeedbackModel
 

+ (NSDictionary *)objectClassInArray{
    return @{@"feedbackList" : [Feedbacklist class]};
}
@end


@implementation Feedbacklist

@end


