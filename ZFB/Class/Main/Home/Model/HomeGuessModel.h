//
//  HomeGuessModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GuessData,Cmgoodsbrowselist,Findgoodslist;
@interface HomeGuessModel : NSObject


@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) GuessData *data;

@end
@interface GuessData : NSObject

@property (nonatomic, strong) Cmgoodsbrowselist *cmGoodsBrowseList;

@end

@interface Cmgoodsbrowselist : NSObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<Findgoodslist *> *findGoodsList;

@end

@interface Findgoodslist : NSObject

@property (nonatomic, copy) NSString *goodsType;

@property (nonatomic, copy) NSString *offlineDate;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *onlineDate;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *auditMemo;

@property (nonatomic, assign) NSInteger auditUserId;

@property (nonatomic, copy) NSString *attachImgUrl;

@property (nonatomic, copy) NSString *goodsUnit;

@property (nonatomic, assign) NSInteger onlineFlag;

@property (nonatomic, assign) NSInteger isFeatured;

@property (nonatomic, copy) NSString *goodsDetail;

@property (nonatomic, copy) NSString *goodsDesc;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *operateUserId;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, copy) NSString *inventory;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, assign) NSInteger snapshotFlag;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *isGoodsRules;

@property (nonatomic, assign) NSInteger originalGoodsId;

@property (nonatomic, copy) NSString *netPurchasePrice;

@property (nonatomic, assign) NSInteger goodsSales;

@property (nonatomic, copy) NSString *productSkuId;

@property (nonatomic, copy) NSString *brandId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, assign) NSInteger isRecommened;

@property (nonatomic, copy) NSString *auditTime;

@property (nonatomic, copy) NSString *goodsTypeName;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, assign) NSInteger goodsPv;///访问量

@property (nonatomic, copy) NSString * storeDist;///距离



@property (nonatomic, assign) NSInteger isCollect;

@property (nonatomic, assign) NSInteger goodsStatus;

@property (nonatomic, assign) NSInteger lockFlag;

@end

