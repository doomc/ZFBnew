//
//  PersonMessageModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PushMessageList,DateList;
@interface PersonMessageModel : NSObject

@property (nonatomic , copy) NSString *resultMsg;
@property (nonatomic , assign) NSInteger total;
@property (nonatomic , strong) NSArray <PushMessageList*> *pushMessageList ;

@end

@interface PushMessageList : NSObject

@property (nonatomic , strong) NSArray <DateList*> *list ;
@property (nonatomic , copy) NSString * title;

@end

@interface DateList : NSObject

@property (nonatomic , copy) NSString * title;
@property (nonatomic , copy) NSString * content;
@property (nonatomic , copy) NSString * object;
@property (nonatomic , copy) NSString * createTime;
@property (nonatomic , copy) NSString * pltime;

@property (nonatomic , assign) NSInteger status;
@property (nonatomic , assign) NSInteger userId;
@property (nonatomic , assign) NSInteger msg_type;
@property (nonatomic , assign) NSInteger isRead;
@property (nonatomic , assign) NSInteger isNew;
@property (nonatomic , assign) NSInteger pushmsgId;

@end
