//
//  ShoppingCarModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Shoppcartlist,ShopGoodslist,ShopGoodsprop;
@interface ShoppingCarModel : ResponseObject

@property (nonatomic, strong) NSArray<Shoppcartlist *> *shoppCartList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic) BOOL isSelected;


@end

@interface Shoppcartlist : ResponseObject

@property (nonatomic, strong) NSMutableArray<ShopGoodslist *> *goodsList;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSInteger storeId;
// 左侧按钮是否选中
@property (nonatomic,assign) BOOL leftShoppcartlistIsChoosed;
// 商品是否全部编辑状态
@property (nonatomic,assign) BOOL ShoppcartlistIsEditing;


@end

@interface ShopGoodslist : ResponseObject
// 商品左侧按钮是否选中
@property (nonatomic,assign) BOOL goodslistIsChoosed;

@property (nonatomic, strong) NSMutableArray<ShopGoodsprop *> *goodsProp;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) NSInteger goodsCount;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, copy) NSString  *netPurchasePrice;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, copy) NSString * cartItemId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *consessionalPrice;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *isReturned;



@end

@interface ShopGoodsprop : ResponseObject

@property (nonatomic, assign) NSInteger nameId;

@property (nonatomic, assign) NSInteger valueId;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *name;

@end

