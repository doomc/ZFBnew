//
//  ZFEnum.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户端
typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAllOrder,//全部订单
    OrderTypeWaitPay,//待付款
    OrderTypeWaitSend,//待发货
    OrderTypeSending,//配送中
    OrderTypeSended,//已配送
    OrderTypeDealSuccess,//交易完成
    OrderTypeCancelSuccess,//取消交易
    OrderTypeAfterSale,//售后
    
};
//配送端
typedef NS_ENUM(NSUInteger, SendServicType) {
    SendServicTypeWaitSend,//待配送
    SendServicTypeSending,//配送中
    SendServicTypeSended,//已配送
    SendServicTypeUpdoor,//上门取件
 
    
};

@interface ZFEnum : NSObject

@end
