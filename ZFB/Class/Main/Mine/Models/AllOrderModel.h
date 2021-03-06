//
//  AllOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  全部订单

#import <Foundation/Foundation.h>

@class Orderlist,Ordergoods,OrderProper;
@interface AllOrderModel : ResponseObject

//@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSArray<Orderlist *> *orderList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, copy) NSString *resultMsg;


@end

@interface Orderlist : ResponseObject

@property (nonatomic, strong) NSArray<Ordergoods *> *orderGoods;

@property (nonatomic, copy) NSString *expressNumber;//物流运单号

@property (nonatomic, copy) NSString *orderStatusName;

@property (nonatomic, copy) NSString *is_comment;//0 未晒单 1已晒单 

@property (nonatomic, copy) NSString *post_name;

@property (nonatomic, copy) NSString *orderStatus;    //    orderStatus  -1：关闭,0待配送 1配送中 2.配送完成，3交易完成（用户确认收货），4.待付款,5.待审批,6.待退回，7.服务完成 8 待接单 9.代发货 10.已发货

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *orderDetail;

@property (nonatomic, copy) NSString *storeLatitude;

@property (nonatomic, assign) NSInteger payMode;

@property (nonatomic, copy) NSString *payModeName;

@property (nonatomic, assign) NSInteger payType;//线上线下

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

@property (nonatomic, copy) NSString *partRefund;

@property (nonatomic, assign) NSInteger skuId;


@end

@interface Ordergoods : ResponseObject
///商品唯一编号
@property (nonatomic, copy) NSString *orderGoodsId;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, assign) NSInteger status;  //status  申请售后的状态 0未操作 1退货中 2服务完成 3未通过

@property (nonatomic, copy) NSString *statusName;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *concessional_price;

@property (nonatomic, copy) NSString *priceUnit;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, copy) NSString *store_price;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *purchase_price;//网购价

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *original_price;

@property (nonatomic, strong) NSArray <OrderProper *>*goods_properties;

@property (nonatomic, copy) NSString * is_comment;//0 是未评论 1 是已评论



@end
@interface OrderProper : ResponseObject

@property (nonatomic, copy) NSString * nameId;
@property (nonatomic, copy) NSString * valueId;
@property (nonatomic, copy) NSString * value;
@property (nonatomic, copy) NSString * name;
 


@end
