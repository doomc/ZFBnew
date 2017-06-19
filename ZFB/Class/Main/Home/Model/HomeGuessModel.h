//
//  HomeGuessModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGuessModel : NSObject
/** 商品id*/
@property (nonatomic, copy) NSString * pid;//(id)

/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;

/** 门店名称 */
@property (nonatomic, copy) NSString * storeName;

/** 商品封面的url地址 */
@property (nonatomic, copy) NSString * coverImgUrl;

/** 网购价*/
@property (nonatomic, copy) NSString * netPurchasePrice;

/** 返回 0 成功、1失败 */
@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, strong) HomeGuessModel * cmAdvertImgList;/* 自我模型类型 */
@end