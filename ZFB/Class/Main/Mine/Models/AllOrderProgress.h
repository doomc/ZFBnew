//
//  AllOrderProgress.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProgressData,List;
@interface AllOrderProgress : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) ProgressData *data;

@property (nonatomic, copy) NSString *resultCode;



@end
@interface ProgressData : ResponseObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<List *> *list;

@end

@interface List : ResponseObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *serviceNum;

@property (nonatomic, copy) NSString * saleId;//	售后申请id

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *refund;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *createTime;

@end

