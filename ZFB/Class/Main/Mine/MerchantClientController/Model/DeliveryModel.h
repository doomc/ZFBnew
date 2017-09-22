//
//  DeliveryModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

 
@class Deliverylist;
@interface DeliveryModel : NSObject


@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<Deliverylist *> *deliveryList;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, copy) NSString *resultMsg;

@end

@interface Deliverylist : NSObject

@property (nonatomic, assign) NSInteger cmAreaId;

@property (nonatomic, assign) NSInteger review;

@property (nonatomic, copy) NSString *deliveryName;

@property (nonatomic, assign) NSInteger deliveryStatus;

@property (nonatomic, assign) long long reviewTime;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *deliveryArea;

@property (nonatomic, assign) NSInteger deliveryDist;

@property (nonatomic, assign) NSInteger cmUserId;

@property (nonatomic, copy) NSString *deliveryPhone;

@property (nonatomic, assign) NSInteger deliveryId;

@property (nonatomic, copy) NSString *deliveryNum;

@property (nonatomic, assign) CGFloat orderDeliveryFee;



@end

