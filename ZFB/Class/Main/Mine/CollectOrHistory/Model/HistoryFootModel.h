//
//  HistoryFootModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cmscanfoolprintslist,Cmgoodsinfo;
@interface HistoryFootModel : NSObject

@property (nonatomic, strong) Cmscanfoolprintslist *cmScanFoolprintsList;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface Cmscanfoolprintslist : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *cmUserId;

@property (nonatomic, strong) NSArray<Cmgoodsinfo *> *cmGoodsInfo;

@end

@interface Cmgoodsinfo : NSObject

@property (nonatomic, copy) NSString *storePrice;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *coverImgUrl;

@property (nonatomic, copy) NSString *goodsName;

@end

