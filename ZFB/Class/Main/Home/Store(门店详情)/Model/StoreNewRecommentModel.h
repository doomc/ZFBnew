//
//  StoreNewRecommentModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoreRecommentData,StoreRecommentList,StoreRecommentGoodsList;

@interface StoreNewRecommentModel : NSObject
@property (nonatomic, strong) StoreRecommentData *data;
@property (nonatomic, copy) NSString * resultCode;

@end
@interface StoreRecommentData : NSObject

@property (nonatomic, strong) NSArray <StoreRecommentList *>* recommentList;


@end

@interface StoreRecommentList : NSObject

@property (nonatomic, strong) NSArray <StoreRecommentGoodsList *> *goodsList;
@property (nonatomic, copy) NSString * createTime;

@end


@interface StoreRecommentGoodsList : NSObject

@property (nonatomic, copy) NSString * isGoodsRules;
@property (nonatomic, copy) NSString * storePrice;
@property (nonatomic, copy) NSString * minPrice;
@property (nonatomic, copy) NSString * priceRange;
@property (nonatomic, copy) NSString * netPurchasePrice;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * attachImgUrl;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, assign) NSInteger  goodsSales;
@property (nonatomic, assign) NSInteger  goodsId;
@property (nonatomic, copy) NSString * collcetNumber;
@property (nonatomic, copy) NSString * coverImgUrl;

@end
