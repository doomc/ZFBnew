//
//  CouponModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Couponlist;
@interface CouponModel : ResponseObject

@property (nonatomic, strong) NSArray<Couponlist *> *couponList;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface Couponlist : ResponseObject

/**
 用于编辑删除
 */
@property (nonatomic, assign) BOOL isChoosedCoupon;

@property (nonatomic, copy) NSString * eachOneAmount;

@property (nonatomic, assign) NSInteger putUserId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString * amountLimit;

@property (nonatomic, copy) NSString *effectEndTime;

@property (nonatomic, assign) NSInteger serviceType;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *effectStartTime;

@property (nonatomic, assign) NSInteger couponKind;

@property (nonatomic, assign) NSInteger couponId;

@property (nonatomic, assign) NSInteger   useRange;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *goodsIds;

@property (nonatomic, copy) NSString *validPeriod;//1有效期内 ，2无效了



@end

