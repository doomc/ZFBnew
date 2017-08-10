//
//  CheckModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckData,CheckInfo,CheckList;
@interface CheckModel : NSObject



@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) CheckData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface CheckData : NSObject

@property (nonatomic, strong) CheckInfo *info;

@property (nonatomic, strong) NSArray<CheckList *> *list;

@end

@interface CheckInfo : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *serviceNum;

@property (nonatomic, copy) NSString *createTime;

@end

@interface CheckList : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *time;

@end

