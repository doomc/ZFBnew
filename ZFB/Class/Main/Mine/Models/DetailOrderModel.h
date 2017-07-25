//
//  DetailOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailShoppcartlist,DetailOrderGoodslist,Orderdetails,DetailCmuserinfo,Unpayorderinfo;
@interface DetailOrderModel : NSObject


@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<Unpayorderinfo *> *unpayOrderInfo;//付款信息    未付款，需要此内容，用于提交支付信息

@property (nonatomic, strong) DetailCmuserinfo *cmUserInfo;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, strong) Orderdetails *orderDetails;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) DetailShoppcartlist *shoppCartList;

@end
@interface DetailShoppcartlist : NSObject

@property (nonatomic, strong) NSArray<DetailOrderGoodslist *> *goodsList;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *storeName;

@end

@interface DetailOrderGoodslist : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, assign) NSInteger storePrice;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@end

@interface Orderdetails : NSObject

@property (nonatomic, assign) NSInteger cmOrderId;

@property (nonatomic, assign) NSInteger payStatus;

@property (nonatomic, copy) NSString *orderStatusName;

@property (nonatomic, assign) NSInteger payMethod;

@property (nonatomic, assign) NSInteger deliveryFee;

@property (nonatomic, copy) NSString *payStatusName;

@property (nonatomic, copy) NSString *payMethodName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger payRelPrice;

@end

@interface DetailCmuserinfo : NSObject

@property (nonatomic, assign) NSInteger cmUserId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *postAddress;

@end

@interface Unpayorderinfo : NSObject

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *pay_money;

@end

