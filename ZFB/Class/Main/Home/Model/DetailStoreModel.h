//
//  DetailStoreModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailStoreModel : NSObject


/** 门店id*/
@property (nonatomic, copy) NSString * storeId;

/** 店铺名字storeName */
@property (nonatomic, copy) NSString * storeName;

/** 商品名goodsName */
@property (nonatomic, copy) NSString * goodsName;

/** 门店地址 */
@property (nonatomic, copy) NSString * address;

/** 门店电话号码*/
@property (nonatomic, copy) NSString * contactPhone;

/** 商品封面url*/
@property (nonatomic, copy) NSString * coverImgUrl;

/** 是否支持到店付 1.支持 0.不支持*/
@property (nonatomic, copy) NSString * payType;

/** 返回 0 成功、1失败 */
@property (nonatomic, copy) NSString * resultCode;


@end
