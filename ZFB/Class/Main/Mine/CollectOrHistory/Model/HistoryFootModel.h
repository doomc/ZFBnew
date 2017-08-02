//
//  HistoryFootModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DataAA,Cmscanfoolprintslist;
@interface HistoryFootModel : NSObject


@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) DataAA *data;

@end

@interface DataAA : NSObject

@property (nonatomic, strong) NSArray<Cmscanfoolprintslist *> *cmScanFoolprintsList;

@property (nonatomic, assign) NSInteger totalCount;

@end

@interface Cmscanfoolprintslist : NSObject

@property (nonatomic, assign) NSInteger foolId;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger goodId;

@property (nonatomic, assign) NSInteger createName;

@property (nonatomic, assign) CGFloat storePrice;

@property (nonatomic, copy) NSString *goodName;

@property (nonatomic, copy) NSString *coverImgUrl;

@end

