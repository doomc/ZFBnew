//
//  UserFeedbackModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Userfeedbacklist;
@interface UserFeedbackModel : NSObject

 
@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray<Userfeedbacklist *> *userFeedbackList;

@property (nonatomic, assign) NSInteger resultCode;

@end

@interface Userfeedbacklist : NSObject

@property (nonatomic, copy) NSString *feedbackId;

@property (nonatomic, copy) NSString *idea;

@property (nonatomic, copy) NSString *ideaTime;

@end

