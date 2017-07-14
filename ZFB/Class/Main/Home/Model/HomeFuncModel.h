//
//  HomeFuncModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YypeData,CMgoodstypelist,Createdate,Updatedate;

@interface HomeFuncModel : NSObject

@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, copy) NSString *resultMsg;
@property (nonatomic, strong) YypeData *data;


@end
@interface YypeData : NSObject

@property (nonatomic, strong) NSArray <CMgoodstypelist *> *CmGoodsTypeList;


@end

@interface CMgoodstypelist : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

//@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *delFlag;

@property (nonatomic, assign) NSInteger parentId;

@property (nonatomic, copy) NSString *updateBy;



@property (nonatomic, strong) Createdate *createDate;

@property (nonatomic, assign) NSInteger typeLevel;

@property (nonatomic, copy) NSString *parentIds;



@property (nonatomic, strong) Updatedate *updateDate;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *createBy;

@end


@interface Createdate : NSObject

@property (nonatomic, assign) long long time;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger date;

@property (nonatomic, assign) NSInteger hours;

@property (nonatomic, assign) NSInteger seconds;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger timezoneOffset;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger minutes;

@end

@interface Updatedate : NSObject

@property (nonatomic, assign) long long time;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger date;

@property (nonatomic, assign) NSInteger hours;

@property (nonatomic, assign) NSInteger seconds;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger timezoneOffset;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger minutes;



@end

