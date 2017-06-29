//
//  StoreListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeStoreListModel : ResponseObject

/** 门店id*/
@property (nonatomic, copy) NSString * storeId;
/** 店铺名字storeName */
@property (nonatomic, copy) NSString * storeName;
/** 喜欢个数 */
@property (nonatomic, copy) NSString * likeNum;
/** 图片原图url*/
@property (nonatomic, copy) NSString * urls;
/** 图片缩略图2*/
@property (nonatomic, copy) NSString * thumbnailUrls;
/** 距离 */
@property (nonatomic, copy) NSString * juli;
/** 返回 0 成功、1失败 */
@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, copy) NSString * starLevel;//starLevel

@property (nonatomic, strong) HomeStoreListModel * cmStoreList;/* 自我模型类型 */


@end

