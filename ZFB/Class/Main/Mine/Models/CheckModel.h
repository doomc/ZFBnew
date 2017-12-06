//
//  CheckModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckData,CheckInfo,CheckList;
@interface CheckModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) CheckData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface CheckData : ResponseObject

@property (nonatomic, strong) CheckInfo *info;

@property (nonatomic, strong) NSArray<CheckList *> *list;

@property (nonatomic, strong) NSArray  *imgList;

@end

@interface CheckInfo : ResponseObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *serviceNum;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *refundTypeName;
@property (nonatomic, copy) NSString *problemDescr;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *goodsPicture;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger  goodsCount;

@end

@interface CheckList : ResponseObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *time;

@end

