//
//  BusinessOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusinessOrderlist,BusinessOrdergoods;
@interface BusinessOrderModel : ResponseObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<BusinessOrderlist *> *orderList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, assign) NSInteger pageCount;

@end
@interface BusinessOrderlist : ResponseObject

@property (nonatomic, copy) NSString *netPurchasePrice;

@property (nonatomic, copy) NSString *orderAmount;

@property (nonatomic, copy) NSString *deliveryId;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, assign) NSInteger payMode;

@property (nonatomic, assign) CGFloat orderDeliveryFee;

@property (nonatomic, copy) NSString *orderFinishTime;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *orderStatusName;

@property (nonatomic, copy) NSString *payStatus;

@property (nonatomic, copy) NSString *storeLongitude;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *payModeName;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *storeLatitude;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSArray<BusinessOrdergoods *> *orderGoods;

@property (nonatomic, copy) NSString *orderComment;

@property (nonatomic, copy) NSString *payStatusName;

@property (nonatomic, copy) NSString *post_address;

@property (nonatomic, copy) NSString *post_phone;

@property (nonatomic, copy) NSString *post_name;


@end

@interface BusinessOrdergoods : ResponseObject

@property (nonatomic, copy) NSString *netPurchasePrice;//网购价格

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_properties;

@property (nonatomic, copy) NSString *priceUnit;

@property (nonatomic, assign) NSInteger  goodsCount;

@property (nonatomic, copy) NSString *store_price;

@property (nonatomic, copy) NSString *order_id;//订单id

@property (nonatomic, copy) NSString *purchase_price;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *original_price;

@property (nonatomic, copy) NSString *concessional_price;

@end

