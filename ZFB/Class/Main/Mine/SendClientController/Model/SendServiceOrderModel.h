//
//  SendServiceOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SendServiceStoreinfomap,SendServiceOrdergoodslist;
@interface SendServiceOrderModel : NSObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray<SendServiceStoreinfomap *> *storeInfoMap;

@property (nonatomic, assign) NSInteger resultCode;

@end

@interface SendServiceStoreinfomap : NSObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger orderAmmount;

@property (nonatomic, strong) NSArray<SendServiceOrdergoodslist *> *orderGoodsList;

@property (nonatomic, assign) NSInteger orderDeliveryFee;

@end

@interface SendServiceOrdergoodslist : NSObject

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger storePrice;

@property (nonatomic, copy) NSString *goodsProperties;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger concessionalPrice;

@property (nonatomic, assign) NSInteger originalPrice;

@property (nonatomic, assign) NSInteger purchasePrice;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, assign) NSInteger goodsId;

@end

