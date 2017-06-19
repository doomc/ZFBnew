//
//  DetailGoodsModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情


#import <Foundation/Foundation.h>

@class ReluJsonModel;

@interface DetailGoodsModel : NSObject

/** 门店id*/
@property (nonatomic, copy) NSString * storeId;
/** 商品id*/
@property (nonatomic, copy) NSString * goodsId;
/** 店铺名字storeName */
@property (nonatomic, copy) NSString * storeName;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 门店地址 */
@property (nonatomic, copy) NSString * address;
/** 门店电话号码*/
@property (nonatomic, copy) NSString * contactPhone;
/** 商品封面*/
@property (nonatomic, copy) NSString * coverImgUrl;

/** 距离*/
@property (nonatomic, copy) NSString * juli;

/** 总库存*/
@property (nonatomic, copy) NSString * inventory;
/** 商品详情多张url地址 attachImgUrl*/
@property (nonatomic, copy) NSString * attachImgUrl;
/** 已售卖*/
@property (nonatomic, copy) NSString * goodsSales;
/** 用户售卖时的价格netPurchasePrice*/
@property (nonatomic, copy) NSString * netPurchasePrice ;
/** 是否支持到店付 1.支持 0.不支持*/
@property (nonatomic, copy) NSString * payType;

@property (nonatomic, strong) DetailGoodsModel * productSku;//产品规格
@property (nonatomic, strong) ReluJsonModel * reluJson;// {color:灰色,白色,藏青色,size:XL,XXL,M}"






@end
