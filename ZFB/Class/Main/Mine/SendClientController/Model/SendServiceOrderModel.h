//
//  SendServiceOrderModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SendServiceStoreinfomap,SendServiceOrdergoodslist,SendServiceGoodsProperties;
@interface SendServiceOrderModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray<SendServiceStoreinfomap *> *storeInfoMap;

@property (nonatomic, assign) NSInteger resultCode;

@end

@interface SendServiceStoreinfomap : ResponseObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) CGFloat orderAmmount;

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, assign) NSInteger orderStatus;


@property (nonatomic, strong) NSArray<SendServiceOrdergoodslist *> *orderGoodsList;

@property (nonatomic, assign) CGFloat orderDeliveryFee;

@end

@interface SendServiceOrdergoodslist : ResponseObject

@property (nonatomic, copy) NSString *netPurchasePrice;//网购价格

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger storePrice;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger concessionalPrice;

@property (nonatomic, assign) NSInteger originalPrice;

@property (nonatomic, copy) NSString * purchasePrice;//网购价格

@property (nonatomic, assign) NSInteger orderId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, strong) NSArray<SendServiceGoodsProperties *> *goodsProperties;


@end

@interface SendServiceGoodsProperties : ResponseObject

@property (nonatomic, copy) NSString *nameId;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueId;
@property (nonatomic, copy) NSString *name;

@end
