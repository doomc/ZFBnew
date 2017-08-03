//
//  JsonModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Usergoodsinfojson,JosnGoodslist;
@interface JsonModel : NSObject

@property (nonatomic, strong) NSArray<Usergoodsinfojson *> *userGoodsInfoJSON;

@end

@interface Usergoodsinfojson : NSObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray<JosnGoodslist *> *goodsList;

@end

@interface JosnGoodslist : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *goodsProp;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *consessionalPrice;

@end

