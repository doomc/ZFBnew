//
//  UserFeedbackModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feedbacklist;
@interface UserFeedbackModel : ResponseObject

@property (nonatomic, strong) NSArray<Feedbacklist *> *feedbackList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;



@end

@interface Feedbacklist : ResponseObject

@property (nonatomic, copy) NSString *feedbackContent;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *feedbackTime;

@property (nonatomic, copy) NSString *feedbackUrl;

@property (nonatomic, copy) NSString *isTreat;

@end

