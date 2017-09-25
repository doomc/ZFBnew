//
//  IMSearchResultModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMSearchData,IMSearchUserinfo;
@interface IMSearchResultModel : ResponseObject

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) IMSearchData *data;

@property (nonatomic, copy) NSString *resultCode;

@end
@interface IMSearchData : ResponseObject

@property (nonatomic, strong) NSArray<IMSearchUserinfo *> *userInfo;

@end

@interface IMSearchUserinfo : ResponseObject

@property (nonatomic, copy) NSString *userImgAttachUrl;

@property (nonatomic, assign) NSInteger cmUserId;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *accid;

@property (nonatomic, assign) NSInteger sex;

@end

