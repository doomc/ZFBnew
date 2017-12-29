//
//  UpdateModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateData;
@interface UpdateModel : NSObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray<UpdateData *> *data;

@end

@interface UpdateData : ResponseObject

@property (nonatomic, assign) NSInteger  vsId;

@property (nonatomic, copy) NSString * versionCode;

@property (nonatomic, copy) NSString * versionDesc;

@property (nonatomic, copy) NSString * createTime;

@end
