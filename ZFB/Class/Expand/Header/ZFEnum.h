//
//  ZFEnum.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 用户端

 - OrderTypeAllOrder: 默认全部配送
 */
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAllOrder = 0,//全部订单
    OrderTypeWaitPay,//待付款
    OrderTypeWaitSend,//待配送
    OrderTypeSending,//配送中
    OrderTypeSended,//已配送
    OrderTypeDealSuccess,//交易完成
    OrderTypeCancelSuccess,//取消交易
    OrderTypeAfterSale,//售后
    OrderTypeWaitSending,//待发货
    OrderTypeWaitRecive,//待收货

};


/**
 订单详情cell

 - OrderDetailTypeOrderDetailCell: 订单详情cell类型
 */
typedef NS_ENUM(NSUInteger, OrderDetailType) {
    OrderDetailTypeOrderDetailCell = 0,//公共cell 例如 订单号
    OrderDetailTypeOrderWithAddressCell,//地址信息
    OrderDetailTypeOrderDetailSectionCell,//店铺名称
    OrderDetailTypeOrderDetailGoosContentCell,//商品简要
    OrderDetailTypeOrderDetailCountCell,//商品金额+配送费
    OrderDetailTypeOrderDetailPaycashCell,//付款

};


/**
  配送端

 - SendServicTypeWaitSend: 默认待配送
 */
typedef NS_ENUM(NSUInteger, SendServicType) {
    SendServicTypeWaitSend = 0,//待配送
    SendServicTypeSending,//配送中
    SendServicTypeSended,//已配送
//    SendServicTypeWaitSending,//待发货
//    SendServicTypeWaitReceived,//待收货
    
};


/**
 商户端
 
 - SendServicTypeWaitSend: 默认待配送
 */
typedef NS_ENUM(NSUInteger, BusinessServicType) {
    BusinessServicTypeWaitSendlist = 0,//待派单
    BusinessServicTypeSending,//配送中
    BusinessServicTypeWaitPay,//待付款
    BusinessServicTypeDealComplete,//交易完成
    BusinessServicTypeSureReturn,//待确认退回
    BusinessServicTypeSended,//配送完成
    BusinessServicTypeCancelOrder,//取消订单
    BusinessServicTypeWaitSending,//待发货
    BusinessServicTypeWaitReceived,//待收货
    BusinessServicTypeWiatCheck,//待审批 

};


/**
网络状态

 - DDAFNetworkReachabilityStatusUnknown: -1
 - DDAFNetworkReachabilityStatusNotReachable: 0
 - DDAFNetworkReachabilityStatusReachableViaWWAN: 1
 - DDAFNetworkReachabilityStatusReachableViaWiFi: 2
 */
typedef NS_ENUM(NSUInteger, DDAFNetworkReachabilityStatus ) {
    DDAFNetworkReachabilityStatusUnknown = -1,
    DDAFNetworkReachabilityStatusNotReachable = 0,
    DDAFNetworkReachabilityStatusReachableViaWWAN = 1,
    DDAFNetworkReachabilityStatusReachableViaWiFi = 2,
};


/**
 门店详情的筛选

 */
typedef NS_ENUM(NSUInteger, StoreScreenType ) {
    StoreScreenTypeAll = 0, //综合类型
    StoreScreenTypeSales ,//销量
    StoreScreenTypelastGoods,//最新
    StoreScreenTypePrice ,//价格
 
};
/**
 商品详情的参数筛选
 
 */
typedef NS_ENUM(NSUInteger, GoodsParamType ) {
    GoodsParamTypeDetailContent = 0, //图文详情
    GoodsParamTypeSkuParam ,//规格参数
    GoodsParamTypePromiss,//商家承诺
    
};


@interface ZFEnum : NSObject

@end
