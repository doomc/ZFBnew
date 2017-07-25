//
//  SkuMatchModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SkuData,Skumatch,SkuValulist;
@interface SkuMatchModel : NSObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) SkuData *data;

@end
@interface SkuData : NSObject

@property (nonatomic, strong) NSArray<Skumatch *> *skuMatch;

@end

@interface Skumatch : NSObject

@property (nonatomic, assign) NSInteger nameId;

@property (nonatomic, strong) NSArray<SkuValulist *> *valuList;

@end

@interface SkuValulist : NSObject

@property (nonatomic, assign) BOOL isSelect;//用来判断记录选择

@property (nonatomic, assign) NSInteger valueId;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) NSInteger nameId;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, assign) NSInteger typeId;

@property (nonatomic, assign) NSInteger skuId;

@end

