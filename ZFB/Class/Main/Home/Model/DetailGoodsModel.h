//
//  DetailGoodsModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情


#import <Foundation/Foundation.h>

@class Cmgoodsdetailslist,Productsku,Relujson;
@interface DetailGoodsModel : NSObject

@property (nonatomic, strong) NSArray<Cmgoodsdetailslist *> *cmGoodsDetailsList;

@end


@interface Cmgoodsdetailslist : NSObject

/** 门店id*/
@property (nonatomic, copy) NSString *sotreName;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, copy) NSString *juli;

//产品规格
@property (nonatomic, strong) Productsku *productSku;

@property (nonatomic, assign) NSInteger commentNum;

@property (nonatomic, copy) NSString *netPurchasePrice;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *attachImgUrl;

@property (nonatomic, copy) NSString *sotreId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsSales;

@property (nonatomic, assign) NSInteger resultCode;
/** 商品封面*/
@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsId;

@end

@interface Productsku : NSObject

@property (nonatomic, copy) NSString *inStock;

// {color:灰色,白色,藏青色,size:XL,XXL,M}"
@property (nonatomic, strong) NSArray<Relujson *> *reluJson;

@end

@interface Relujson : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@end

