//
//  SureOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Storedeliveryfeelist;
@interface SureOrderModel : ResponseObject

@property (nonatomic, strong) NSArray<Storedeliveryfeelist *> *storeDeliveryfeeList;

@property (nonatomic, assign) CGFloat goodsCount;

@property (nonatomic, assign) CGFloat costNum;

@property (nonatomic, assign) CGFloat userCostNum;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface Storedeliveryfeelist : ResponseObject

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *orderDeliveryfee;

@end

