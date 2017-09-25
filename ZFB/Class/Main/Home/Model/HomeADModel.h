//
//  HomeADModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADdata,Cmadvertimglist;
@interface HomeADModel : ResponseObject

 
@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) ADdata *data;


 
@end
@interface ADdata : ResponseObject

@property (nonatomic, strong) NSArray<Cmadvertimglist *> *cmAdvertImgList;

@end

@interface Cmadvertimglist : ResponseObject

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *imgCode;

@property (nonatomic, assign) NSInteger goodId;

@property (nonatomic, copy) NSString *imgTitle;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *redirectUrl;

@property (nonatomic, copy) NSString *imgDesc;

@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, assign) BOOL isDel;

@property (nonatomic, copy) NSString *createTime;

@end

