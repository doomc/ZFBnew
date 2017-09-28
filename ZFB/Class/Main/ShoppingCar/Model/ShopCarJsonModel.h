//
//  ShopCarJsonModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoodsProplist;
@interface ShopCarJsonModel : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray <GoodsProplist *>*goodsProp;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *concessionalPrice;

@property (nonatomic, copy) NSString *originalPrice;

@property (nonatomic, copy) NSString *purchasePrice;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *storeName;


@end

@interface GoodsProplist : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameId;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueId;


@end
