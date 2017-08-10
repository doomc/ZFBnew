//
//  AllOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import <Foundation/Foundation.h>

@class Orderlist,Ordergoods;
@interface AllOrderModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<Orderlist *> *orderList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, copy) NSString *resultMsg;


@end

@interface Orderlist : NSObject

@property (nonatomic, strong) NSArray<Ordergoods *> *orderGoods;

@property (nonatomic, copy) NSString *orderStatusName;

@property (nonatomic, copy) NSString *post_name;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *orderDetail;

@property (nonatomic, copy) NSString *storeLatitude;

@property (nonatomic, assign) NSInteger payMode;

@property (nonatomic, copy) NSString *payModeName;

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, assign) CGFloat orderDeliveryFee;

@property (nonatomic, copy) NSString *payStatusName;

@property (nonatomic, copy) NSString *orderAmount;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, copy) NSString *orderFinishTime;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *deliveryId;

@property (nonatomic, copy) NSString *storeLongitude;

@property (nonatomic, assign) NSInteger commentStatus;

@property (nonatomic, copy) NSString *post_phone;

@property (nonatomic, copy) NSString *post_address;

@property (nonatomic, copy) NSString *payStatus;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *orderComment;

@end

@interface Ordergoods : NSObject

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *concessional_price;

@property (nonatomic, copy) NSString *priceUnit;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, copy) NSString *store_price;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *purchase_price;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *original_price;

@property (nonatomic, strong) NSArray *goods_properties;

@end

