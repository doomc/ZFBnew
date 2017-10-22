//
//  PersonMessageModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PushMessageList;
@interface PersonMessageModel : ResponseObject

@property (nonatomic , copy) NSString *resultCode;
@property (nonatomic , copy) NSString *resultMsg;
@property (nonatomic , assign) NSInteger total;
@property (nonatomic , strong) NSArray <PushMessageList*> *pushMessageList ;

@end

@interface PushMessageList : ResponseObject

@property (nonatomic , assign) NSInteger pushmsgId;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *object;
@property (nonatomic , assign) NSInteger status;
@property (nonatomic , copy) NSString *createTime;
@property (nonatomic , copy) NSString *userId;
@property (nonatomic , assign) NSInteger msg_type;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , assign) NSInteger isRead;
@property (nonatomic , assign) NSInteger isNew;

@end



