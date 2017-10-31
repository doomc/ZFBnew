//
//  HomeFuncModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YypeData,CMgoodstypelist;

@interface HomeFuncModel : ResponseObject

@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, copy) NSString *resultMsg;
@property (nonatomic, strong) YypeData *data;


@end
@interface YypeData : ResponseObject

@property (nonatomic, strong) NSArray <CMgoodstypelist *> *CmGoodsTypeList;


@end

@interface CMgoodstypelist : ResponseObject

@property (nonatomic, assign) NSInteger goodId;//重命名的id

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, assign) NSInteger typeLevel;
@property (nonatomic, copy) NSString *brandIds;
@property (nonatomic, copy) NSString *lockFlag;
@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *parentIds;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createDate;





@end

