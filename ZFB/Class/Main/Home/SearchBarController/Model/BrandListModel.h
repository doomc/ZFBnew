//
//  BrandListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandData,BrandFindbrandlist;
@interface BrandListModel : ResponseObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) BrandData *data;


@end

@interface BrandData : ResponseObject

@property (nonatomic, strong) NSArray<BrandFindbrandlist *> *findBrandList;

@end

@interface BrandFindbrandlist : ResponseObject

@property (nonatomic, assign) NSInteger orderNum;

@property (nonatomic, assign) NSInteger isRecommend;

@property (nonatomic, copy) NSString * brandId;

@property (nonatomic, copy) NSString * brandName;

@end

