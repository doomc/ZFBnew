//
//  ShoppingCarModel.h
//  ZFB
//
//  Created by 熊维东 on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Shoppcartlist,Goodslist;

@interface ShoppingCarModel : ResponseObject

@property (nonatomic) BOOL isSelected;

@property (nonatomic, strong) NSMutableArray<Shoppcartlist *> *shoppCartList;

@property (nonatomic, assign) NSInteger resultCode;

@end

@interface Shoppcartlist : ResponseObject
// 左侧按钮是否选中
@property (nonatomic,assign) BOOL leftShoppcartlistIsChoosed;
// 商品是否全部编辑状态
@property (nonatomic,assign) BOOL ShoppcartlistIsEditing;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSMutableArray<Goodslist *> *goodsList;

@end

@interface Goodslist : ResponseObject
// 商品左侧按钮是否选中
@property (nonatomic,assign) BOOL goodslistIsChoosed;

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, assign) NSInteger  goodsCount;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

