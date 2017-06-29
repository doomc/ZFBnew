//
//  ClearingStoreList.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商家清单

#import "ClearingStoreList.h"


@class Productlist,Cmgoodslist,Goodsprop;

@interface ClearingStoreList : ResponseObject

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) Productlist *productList;

@property (nonatomic, copy) NSString *goodsAllCount;

@end

//@interface Productlist : ResponseObject
//
//@property (nonatomic, copy) NSString *storeId;
//
//@property (nonatomic, copy) NSString *storeName;
//
//@property (nonatomic, strong) NSArray<Cmgoodslist *> *cmGoodsList;
//
//@end
//
//@interface Cmgoodslist : ResponseObject
//
//@property (nonatomic, strong) NSArray<Goodsprop *> *goodsProp;
//
//@property (nonatomic, copy) NSString *storePrice;
//
//@property (nonatomic, copy) NSString *goodsCount;
//
//@property (nonatomic, copy) NSString *goodsId;
//
//@property (nonatomic, copy) NSString *coverImgUrl;
//
//@property (nonatomic, copy) NSString *goodsName;
//
//@end
//
//@interface Goodsprop : ResponseObject
//
//@property (nonatomic, copy) NSString *name;
//
//@property (nonatomic, copy) NSString *value;

//@end

