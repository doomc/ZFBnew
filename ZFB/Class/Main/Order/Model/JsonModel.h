//
//  JsonModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Usergoodsinfojson,JosnGoodslist;

@interface JsonModel : ResponseObject

@property (nonatomic, strong) NSArray<Usergoodsinfojson *> *userGoodsInfoJSON;

@end

@interface Usergoodsinfojson : ResponseObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray<JosnGoodslist *> *goodsList;

@end

@interface JosnGoodslist : ResponseObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *goodsProp;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, assign) CGFloat storePrice;//门店价
@property (nonatomic, copy) NSString *concessionalPrice;//优惠价

@property (nonatomic, copy) NSString *purchasePrice;//价格

@property (nonatomic, copy) NSString *originalPrice;//原价格



@end

