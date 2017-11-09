//
//  BussnissListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BussnissUserStoreList ,BussnissGoodsInfoList,BussnissgoodsProp;
@interface BussnissListModel : ResponseObject

@property (nonatomic, strong) NSArray<BussnissUserStoreList *> *userGoodsList;

@property (nonatomic, assign) NSInteger countNum;

@end

@interface BussnissUserStoreList : ResponseObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray<BussnissGoodsInfoList *> *goodsInfoList;

@property (nonatomic, copy) NSString *deliveryTypeName;

@property (nonatomic, copy) NSString *deliveryType; // 1.  2。快递 3、

@end


@interface BussnissGoodsInfoList : ResponseObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsNum;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, strong) NSArray<BussnissgoodsProp *> *goodsProp;

@end

@interface BussnissgoodsProp : ResponseObject

@property (nonatomic, copy) NSString *nameId;

@property (nonatomic, copy) NSString *valueId;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *name;



@property (nonatomic, strong) NSArray<BussnissgoodsProp *> *goodsProp;

@end
