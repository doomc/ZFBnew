//
//  CollectModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cmkeepgoodslist;
@interface CollectModel : NSObject

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) NSArray<Cmkeepgoodslist *> *cmKeepGoodsList;

@end
@interface Cmkeepgoodslist : NSObject

@property (nonatomic, assign) BOOL isCollectSelected;//选择单个商品

@property (nonatomic, copy) NSString *cartItemId;

@property (nonatomic, copy) NSString *goodId;

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

