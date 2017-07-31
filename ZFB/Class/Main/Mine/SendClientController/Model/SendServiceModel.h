//
//  SendServiceModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weedmap,Monthmap,Numarray,Todaymap;
@interface SendServiceModel : NSObject

@property (nonatomic, strong) Weedmap *weedMap;

@property (nonatomic, strong) Monthmap *monthMap;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) Numarray *numArray;

@property (nonatomic, assign) NSInteger deliveryId;

@property (nonatomic, strong) Todaymap *todayMap;

@end
@interface Weedmap : NSObject

@property (nonatomic, assign) NSInteger distriCount;

@property (nonatomic, copy) NSString *startDay;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger orderDeliveryFee;

@end

@interface Monthmap : NSObject

@property (nonatomic, assign) NSInteger distriCount;

@property (nonatomic, copy) NSString *statusMbth;

@property (nonatomic, copy) NSString *endMonth;

@property (nonatomic, copy) NSString *betweenMonth;

@property (nonatomic, assign) NSInteger orderDeliveryFee;

@end

@interface Numarray : NSObject

@property (nonatomic, assign) NSInteger num;

@end

@interface Todaymap : NSObject

@property (nonatomic, assign) NSInteger distriCount;

@property (nonatomic, copy) NSString *nowDay;

@property (nonatomic, assign) NSInteger orderDeliveryFee;

@property (nonatomic, copy) NSString *completTimeStart;

@property (nonatomic, copy) NSString *completTimeEnd;


@end

