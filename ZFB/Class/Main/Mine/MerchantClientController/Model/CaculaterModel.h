//
//  CaculaterModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ResponseObject.h"

@class Settlementlist;
@interface CaculaterModel : ResponseObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger settlementCount;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray<Settlementlist *> *settlementList;

@property (nonatomic, copy) NSString *responseText;

@property (nonatomic, assign) NSInteger resultCode;


@end
@interface Settlementlist : NSObject

@property (nonatomic, assign) NSInteger delivery_id;

@property (nonatomic, copy) NSString * settlement_delivery_amount;

@property (nonatomic, copy) NSString * order_amount;

@property (nonatomic, copy) NSString *settlement_num;

@property (nonatomic, copy) NSString * settlement_store_amount;

@property (nonatomic, copy) NSString *settlement_time;

@property (nonatomic, copy) NSString *order_num;

@property (nonatomic, assign) NSInteger store_id;

@end

