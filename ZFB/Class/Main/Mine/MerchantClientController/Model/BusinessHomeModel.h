//
//  BusinessHomeModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Orderunpayinfo,Todayorderinfo,Sevendayorderinfo,Monthorderinfo;
@interface BusinessHomeModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) Sevendayorderinfo *sevenDayOrderInfo;

@property (nonatomic, strong) Todayorderinfo *todayOrderInfo;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) Monthorderinfo *monthOrderInfo;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, strong) Orderunpayinfo *orderUnpayInfo;

@end
@interface Orderunpayinfo : NSObject

@property (nonatomic, copy) NSString *order_count;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, copy) NSString *date_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@end

@interface Todayorderinfo : NSObject

@property (nonatomic, copy) NSString *order_count;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, copy) NSString *date_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@end

@interface Sevendayorderinfo : NSObject

@property (nonatomic, copy) NSString *order_count;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, copy) NSString *date_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@end

@interface Monthorderinfo : NSObject

@property (nonatomic, copy) NSString *order_count;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, copy) NSString *date_time;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@end

