//
//  ClassLeftListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassListData,CmgoodsClasstypelist;
@interface ClassLeftListModel : NSObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) ClassListData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface ClassListData : NSObject

@property (nonatomic, strong) NSArray<CmgoodsClasstypelist *> *CmGoodsTypeList;

@end

@interface CmgoodsClasstypelist : NSObject

@property (nonatomic, copy) NSString *createBy;

@property (nonatomic, assign) NSInteger  typeId;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *updateBy;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *lockFlag;

@property (nonatomic, assign) NSInteger typeLevel;

@property (nonatomic, copy) NSString *parentIds;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger parentId;

@end

