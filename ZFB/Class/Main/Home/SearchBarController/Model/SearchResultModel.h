//
//  SearchResultModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResultNewData,ResultFindgoodslist;
@interface SearchResultModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) ResultNewData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface ResultNewData : ResponseObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<ResultFindgoodslist *> *findGoodsList;

@end

@interface ResultFindgoodslist : ResponseObject


@property (nonatomic, copy) NSString *priceTostr;

@property (nonatomic, copy) NSString *goodsTypeName;

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, assign) NSInteger lockFlag;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, assign) NSInteger goodsPv;

@property (nonatomic, assign) NSInteger goodsSales;

@property (nonatomic, copy) NSString *storeDist;

@property (nonatomic, assign) NSInteger onlineFlag;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, assign) NSInteger originalGoodsId;

@property (nonatomic, assign) NSInteger storePrice;

@property (nonatomic, assign) NSInteger auditUserId;

@property (nonatomic, assign) NSInteger goodsStatus;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *goodsDesc;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *brandId;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, copy) NSString *goodsDetail;

@property (nonatomic, assign) NSInteger isFeatured;

@property (nonatomic, copy) NSString *goodsType;

@property (nonatomic, copy) NSString *auditMemo;

@property (nonatomic, copy) NSString *netPurchasePrice;

@end

