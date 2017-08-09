//
//  DetailOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

 
@class DetailShoppcartlist,DetailGoodslist,Orderdetails,Deliveryinfo,Unpayorderinfo,DetailcmUserInfo;
@interface DetailOrderModel : NSObject


@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<Unpayorderinfo *> *unpayOrderInfo;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, strong) Orderdetails *orderDetails;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) DetailShoppcartlist *shoppCartList;

@property (nonatomic, strong) Deliveryinfo *deliveryInfo;

@property (nonatomic, strong) DetailcmUserInfo *cmUserInfo;

@end
@interface DetailcmUserInfo : NSObject

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *postAddress;

@property (nonatomic, copy) NSString *mobilePhone;

@end


@interface DetailShoppcartlist : NSObject

@property (nonatomic, strong) NSMutableArray<DetailGoodslist *> *goodsList;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *storeName;

@end

@interface DetailGoodslist : NSObject

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

@interface Orderdetails : NSObject

@property (nonatomic, copy) NSString * payRelPrice;

@property (nonatomic, copy) NSString * payStatus;

@property (nonatomic, copy) NSString *orderStatusName;

@property (nonatomic, assign) NSInteger payMethod;

@property (nonatomic, copy) NSString * deliveryFee;

@property (nonatomic, copy) NSString *payStatusName;

@property (nonatomic, copy) NSString *payMethodName;

@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, copy) NSString  * goodsAmount;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger cmOrderId;

@end

@interface Deliveryinfo : NSObject

@property (nonatomic, assign) NSInteger deliveryId;

@property (nonatomic, copy) NSString *deliveryName;

@property (nonatomic, copy) NSString *deliveryPhone;

@end

@interface Unpayorderinfo : NSObject

@property (nonatomic, copy) NSString *order_num;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pay_money;

@end

