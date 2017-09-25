//
//  DetailStoreModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cmstoredetailslist,DetailCmgoodslist;

@interface DetailStoreModel : ResponseObject
 
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<DetailCmgoodslist *>  *cmGoodsList;

@property (nonatomic, strong) Cmstoredetailslist *cmStoreDetailsList;

@property (nonatomic, copy) NSString *resultMsg;


@end
@interface Cmstoredetailslist : ResponseObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, assign) NSInteger typeId;//id

@property (nonatomic, assign) NSInteger isCollect;//收藏 0 ,1,

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, copy) NSString *attachUrl;

@end

@interface DetailCmgoodslist : ResponseObject


@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *netPurchasePrice;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

