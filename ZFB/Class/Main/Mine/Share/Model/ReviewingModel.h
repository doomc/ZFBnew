//
//  ReviewingModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReViewData;
@interface ReviewingModel : ResponseObject


@property (nonatomic, strong) NSArray<ReViewData *> *data;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *resultMsg;
//已审核的字段
@property (nonatomic, copy) NSString *generalIncome;//总收入
@property (nonatomic, copy) NSString *goodsCount;//数量
@property (nonatomic, copy) NSString *todayIncome;//今日收入啊

@end

@interface ReViewData : ResponseObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *imgUrls;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *describe;

//已审核的字段
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *reward;//奖励金
@property (nonatomic, assign) NSInteger goodsCount;

//总收入的字段
@property (nonatomic, copy) NSString *goodsNum;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *goodsLogo;
@property (nonatomic, copy) NSString *orderNum;
 


@end

