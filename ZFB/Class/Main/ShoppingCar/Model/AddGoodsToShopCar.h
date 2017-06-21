//
//  AddGoodsToShopCar.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Shoppcartlist;
@interface AddGoodsToShopCar : NSObject



@property (nonatomic, strong) NSArray<Shoppcartlist *> *shoppCartList;

@property (nonatomic, assign) NSInteger resultCode;

@end
@interface Shoppcartlist : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *coverImgUrl;

@end

