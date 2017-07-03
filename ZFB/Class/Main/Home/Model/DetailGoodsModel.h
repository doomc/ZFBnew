//
//  DetailGoodsModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情


#import <Foundation/Foundation.h>

@class Cmgoodsdetailslist,Productsku,Relujson;
@interface DetailGoodsModel : ResponseObject


@property (nonatomic, strong) NSArray<Cmgoodsdetailslist *> *cmGoodsDetailsList;


@end

@interface Cmgoodsdetailslist : NSObject

@property (nonatomic, copy) NSString *sotreName;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, copy) NSString *juli;

@property (nonatomic, copy) NSString *longitude;



@property (nonatomic, strong) NSArray<Productsku *> *productSku;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) NSInteger commentNum;

@property (nonatomic, copy) NSString *netPurchasePrice;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *attachImgUrl;

@property (nonatomic, copy) NSString *sotreId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsSales;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;
///是否收藏	1.收藏 2.不是
@property (nonatomic, assign) NSInteger isCollect ;


@end

@interface Productsku : NSObject

@property (nonatomic, strong) NSArray<Relujson *> *reluJson;

//价格
@property (nonatomic, copy) NSString *purchase;
//库存
@property (nonatomic, copy) NSString *buyNum;

@end

@interface Relujson : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@end

