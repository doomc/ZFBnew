//
//  StoreListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreListModel : NSObject


@property (nonatomic, copy) NSString * resultCode;

/** storeId*/
@property (nonatomic, copy) NSString * storeId;
/** 店铺名字storeName */
@property (nonatomic, copy) NSString * storeName;
/** 喜欢个数 */
@property (nonatomic, copy) NSString * likeNum;
/** 图片url*/
@property (nonatomic, copy) NSString * urls;
/** 链接2*/
@property (nonatomic, copy) NSString * thumbnailUrls;
/** 距离 */
@property (nonatomic, copy) NSString * juli;



@end
