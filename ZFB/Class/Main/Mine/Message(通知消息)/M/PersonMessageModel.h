//
//  PersonMessageModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PushMessageList;
@interface PersonMessageModel : NSObject

@property (nonatomic , copy) NSString *resultMsg;
@property (nonatomic , assign) NSInteger total;
@property (nonatomic , strong) NSArray <PushMessageList*> *pushMessageList ;

@end

@interface PushMessageList : NSObject

@property (nonatomic , copy) NSString * content;
@property (nonatomic , copy) NSString * object;
@property (nonatomic , copy) NSString * createTime;
@property (nonatomic , copy) NSString * title;

@property (nonatomic , assign) int status;
@property (nonatomic , assign) int userId;
@property (nonatomic , assign) int msg_type;
@property (nonatomic , assign) int isRead;
@property (nonatomic , assign) int isNew;
@property (nonatomic , assign) int pushmsgId;

@end

