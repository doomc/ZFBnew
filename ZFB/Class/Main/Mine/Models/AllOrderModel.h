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

@property (nonatomic, strong) NSArray<Orderlist *> *orderList;

@property (nonatomic, assign) NSInteger totalCount;

@end

@interface Orderlist : NSObject

///订单id
@property (nonatomic, assign) NSInteger orderId;
/// 0.未支付的初始状态 1.支付成功 -1.支付失败 3.付款发起 4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)',
@property (nonatomic, assign) NSInteger payStatus;

@property (nonatomic, assign) NSInteger payPrice;

@property (nonatomic, strong) NSArray<Ordergoods *> *orderGoods;

///0待配送 1配送中 2配送完成
@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, strong) NSDate *createTime;

@property (nonatomic, copy) NSString *storeName;

@end

@interface Ordergoods : NSObject

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger goodsId;
///商品单位  包
@property (nonatomic, copy) NSString *goodsUnit;
///原价
@property (nonatomic, assign) NSInteger originalPrice;

@property (nonatomic, copy) NSString *coverImgUrl;
///价格单位
@property (nonatomic, assign) NSInteger priceUnit;

@end

