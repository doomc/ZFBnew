//
//  ShareCommendModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recommentlist;

@interface ShareCommendModel : NSObject

@property (nonatomic, strong) NSArray<Recommentlist *> *recommentList;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *resultMsg;

@end
@interface Recommentlist : NSObject

@property (nonatomic, assign) NSInteger thumbs;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger saleCount;

@property (nonatomic, copy) NSString *goodsImgUrl;

@property (nonatomic, assign) NSInteger recommentId;

@property (nonatomic, copy) NSString *describe;

@end

