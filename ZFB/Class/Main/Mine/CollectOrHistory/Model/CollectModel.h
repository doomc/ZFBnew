//
//  CollectModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data,Cmkeepgoodslist;
@interface CollectModel : ResponseObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) Data *data;

@end

@interface Data : ResponseObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<Cmkeepgoodslist *> *cmKeepGoodsList;

@end

@interface Cmkeepgoodslist : ResponseObject

@property (nonatomic, assign) BOOL isCollectSelected;//选择单个商品

@property (nonatomic, assign) NSInteger cartItemId;

@property (nonatomic, copy) NSString *goodName;

@property (nonatomic, copy) NSString *starLevel;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSInteger goodId;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *isDel;//0 未删除，1删除




@end

