//
//  ShopCarJsonModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class StoreList,UserJsonGoodslist,UserJsonGoodsprop;
@interface ShopCarJsonModel : NSObject

@property (nonatomic, strong) NSArray<StoreList *> *storeList;

@end
@interface StoreList : NSObject

@property (nonatomic, strong) NSArray<UserJsonGoodslist *> *goodsList;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeId;

@end

@interface UserJsonGoodslist : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray<UserJsonGoodsprop *> *goodsProp;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *concessionalPrice;

@property (nonatomic, copy) NSString *originalPrice;

@property (nonatomic, copy) NSString *purchasePrice;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@end

@interface UserJsonGoodsprop : NSObject

@property (nonatomic, assign) NSInteger nameId;

@property (nonatomic, assign) NSInteger valueId;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *name;

@end

