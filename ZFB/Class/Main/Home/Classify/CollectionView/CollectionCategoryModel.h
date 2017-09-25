//
//  CategoryModel.h
//  Linkage
//
//  Created by xwd on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassData,Nexttypelist;

@interface CollectionCategoryModel : ResponseObject


@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) ClassData *data;

@property (nonatomic, copy) NSString *resultCode;


@end
@interface ClassData : ResponseObject

@property (nonatomic, strong) NSArray<Nexttypelist *> *nextTypeList;

@end

@interface Nexttypelist : ResponseObject

@property (nonatomic, copy) NSString *createBy;

@property (nonatomic, assign) NSInteger goodId;

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

