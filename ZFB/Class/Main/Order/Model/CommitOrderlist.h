//
//  CommitOrderlist.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AOrderlist;
@interface CommitOrderlist : NSObject

@property (nonatomic, strong) NSArray<AOrderlist *> *orderList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface AOrderlist : NSObject

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pay_money;

@end

