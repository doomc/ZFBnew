//
//  StoreListModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

 
@class Storeinfolist,Findgoodslist;
@interface HomeStoreListModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic, strong) Storeinfolist *storeInfoList;



@end

@interface Storeinfolist : ResponseObject

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray<Findgoodslist *> *findGoodsList;

@end

@interface Findgoodslist : ResponseObject

@property (nonatomic, copy) NSString *auditDesc;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, copy) NSString *facilities;

@property (nonatomic, assign) NSInteger storeStatus;

@property (nonatomic, copy) NSString *storeContact;

@property (nonatomic, copy) NSString *storeDist;

@property (nonatomic, assign) NSInteger payType;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *contactPhone;

@property (nonatomic, assign) NSInteger likeNum;

@property (nonatomic, copy) NSString *attachUrl;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) NSInteger auditStatus;

@property (nonatomic, assign) NSInteger storePid;

@property (nonatomic, assign) NSInteger areaId;

@property (nonatomic, assign) NSInteger delFlag;

@property (nonatomic, copy) NSString *servicePeomise;

@property (nonatomic, assign) NSInteger auditUserId;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger starLevel;

@property (nonatomic, copy) NSString *storeDesc;

@property (nonatomic, assign) NSInteger storekeeperUserId;

@property (nonatomic, assign) NSInteger storeAdminUserId;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *serviceType;

@property (nonatomic, copy) NSString *businessType;

@property (nonatomic, copy) NSString *brandStory;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger  collectCount;


@end

