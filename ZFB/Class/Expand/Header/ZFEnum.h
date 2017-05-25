//
//  ZFEnum.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAllOrder,
    OrderTypeWaitPay,
    OrderTypeWaitSend,
    
    OrderTypeSending,
    OrderTypeSended,
    OrderTypeDealSuccess,
    
    OrderTypeCancelSuccess,
    OrderTypeAfterSale,
    
};
@interface ZFEnum : NSObject

@end
