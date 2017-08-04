//
//  ShopCarJsonModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserGoodsInfoJSON,JsonGoodslist;

@interface ShopCarJsonModel : NSObject

@property (nonatomic, strong) NSArray <UserGoodsInfoJSON *> *userGoodsInfoJSON;


@end

@interface UserGoodsInfoJSON : NSObject


@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSMutableArray <JsonGoodslist *> *goodsList;

@end

@interface JsonGoodslist : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, assign) NSInteger  goodsCount;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;///图片地址

@property (nonatomic, copy) NSString *goodsProp;//规格

@property (nonatomic, copy) NSString *goodsName;


@end
