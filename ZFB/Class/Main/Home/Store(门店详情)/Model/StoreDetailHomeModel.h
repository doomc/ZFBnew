//
//  StoreDetailHomeModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoreData,GoodsExtendList;

@interface StoreDetailHomeModel : NSObject

@property (nonatomic, strong) StoreData *data;
@property (nonatomic, copy) NSString * resultCode;
@property (nonatomic, copy) NSString * resultMsg;

@end
@interface StoreData : NSObject

@property (nonatomic, strong) NSArray <GoodsExtendList *> *goodsExtendList;
@property (nonatomic, assign) NSInteger  totalCount;

@end

@interface GoodsExtendList : NSObject

@property (nonatomic, copy) NSString * isGoodsRules;
@property (nonatomic, copy) NSString * storePrice;
@property (nonatomic, copy) NSString * minPrice;
@property (nonatomic, copy) NSString * priceRange;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * attachImgUrl;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, assign) NSUInteger   goodsSales;
@property (nonatomic, copy) NSString * coverImgUrl;
@property (nonatomic, assign) NSUInteger  goodsId;
@property (nonatomic, copy) NSString * collcetNumber;
@property (nonatomic, copy) NSString * netPurchasePrice;


@end
