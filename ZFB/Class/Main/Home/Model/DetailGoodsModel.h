//
//  DetailGoodsModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商品详情


#import <Foundation/Foundation.h>
#import "SkuMatchModel.h"

typedef NS_ENUM(NSUInteger, ValueSelectType) {
  
    ValueSelectType_normal,  //没选
    ValueSelectType_selected,  //已选
    ValueSelectType_enable  //不可选
};

@class detailData,Goodsinfo,Storeinfo,Productattribute,Valuelist;
@interface DetailGoodsModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) detailData *data;




@end

@interface detailData : ResponseObject

@property (nonatomic, strong) Goodsinfo *goodsInfo;

@property (nonatomic, strong) Storeinfo *storeInfo;

@property (nonatomic, strong) NSArray<Productattribute *> *productAttribute;

@property (nonatomic, copy) NSString *accId;

@end

@interface Goodsinfo : ResponseObject

@property (nonatomic, copy) NSString *goodsType;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *isReturned;//是否支持退货

@property (nonatomic, copy) NSString *priceRange;//范围价格


@property (nonatomic, copy) NSString *coverImgUrl;///商品封面

@property (nonatomic, copy) NSString *auditMemo;

@property (nonatomic, assign) NSInteger auditUserId;

@property (nonatomic, copy) NSString *attachImgUrl;///商品轮播地址

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, assign) NSInteger onlineFlag;

@property (nonatomic, assign) NSInteger isFeatured;

@property (nonatomic, copy) NSString *commentNum;

@property (nonatomic, copy) NSString *goodsDetail;//网址链接
@property (nonatomic, copy) NSString *specificationsUrl;//网址链接
@property (nonatomic, copy) NSString *goodsPeomise;//网址链接

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *goodsDesc;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *operateUserId;

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, copy) NSString *inventory;///商品总库存

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, assign) NSInteger snapshotFlag;

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, strong) NSArray *productList;

@property (nonatomic, copy) NSString *isGoodsRules;

@property (nonatomic, assign) NSInteger originalGoodsId;

@property (nonatomic, copy) NSString *netPurchasePrice;///	网购价	用户售卖时的价格

@property (nonatomic, assign) NSInteger goodsSales;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *productSkuId;///没有规格的时候取这个id，有规格取 sukid

@property (nonatomic, assign) NSInteger isRecommened;

@property (nonatomic, copy) NSString* isCollect;///是否收藏	1.收藏 2.不是

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) NSString *goodsTypeName;

@property (nonatomic, assign) NSInteger goodsPv;

@property (nonatomic, copy) NSString *brandId;

@property (nonatomic, assign) NSInteger goodsStatus;

@property (nonatomic, assign) NSInteger lockFlag;

@end


@interface Storeinfo : ResponseObject

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *storeDist;///门店距离	单位：米(m)

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, copy) NSString *address;///门店地址

@end

@interface Productattribute : ResponseObject///规格

@property (nonatomic, strong) NSArray<Valuelist *> *valueList;

@property (nonatomic, assign) NSInteger nameStatus;

@property (nonatomic, assign) NSInteger goodsTypeId;

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, assign) NSInteger nameId;//根据这个id区匹配

@property (nonatomic, copy) NSString *name;///尺寸：颜色：类型


@end

@interface Valuelist : ResponseObject

@property (nonatomic, assign) ValueSelectType selectType;  //根据枚举类型显示

@property (nonatomic, strong) SkuMatchModel *skuMatchModel;  //改规格匹配规格

@property (nonatomic, assign) NSInteger nameId;

@property (nonatomic, assign) NSInteger valueId;

@property (nonatomic, assign) NSInteger nameStatus;

@property (nonatomic, assign) NSInteger goodsTypeId;

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, copy) NSString * name;  //value：尺寸：颜色：类型

 


@end

