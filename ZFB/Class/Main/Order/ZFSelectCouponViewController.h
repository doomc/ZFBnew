//
//  ZFSelectCouponViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"


/**
 回传优惠券信息

 @param couponId id
 @param userRange 范围
 @param couponAmount 优惠金额
 */
typedef void(^couponDealBlock)(NSString * couponId,NSString *userRange,NSString *couponAmount,NSString *storeId,NSString *goodsIds);

@interface ZFSelectCouponViewController : BaseViewController

@property (nonatomic , copy) NSString * goodsIdJson;
@property (nonatomic , copy) NSString * storeIdjosn;
@property (nonatomic , copy) NSString * goodsAmount;
@property (nonatomic , copy) NSString * storeArray;//json在字符串


@property (nonatomic , copy) couponDealBlock couponBlock;

@end
