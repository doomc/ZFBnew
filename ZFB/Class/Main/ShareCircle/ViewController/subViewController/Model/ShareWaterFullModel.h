//
//  ShareWaterFullModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShareGoodsData;
@interface ShareWaterFullModel : NSObject

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *resultMsg;

@property (nonatomic, strong) NSArray <ShareGoodsData *> *data;

@end

@interface ShareGoodsData : NSObject

/** 宽度  */
@property (nonatomic, assign) CGFloat width;
/** 高度  */
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *thumbs;//点赞数

@property (nonatomic, copy) NSString *share_num;//分享编号

@property (nonatomic, copy) NSString *userLogo;//图片URL

@property (nonatomic, copy) NSString *shareId;//分享id

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *thumbsStatus;//点赞状态	0点赞 1.未点赞

@property (nonatomic, copy) NSString *imgUrl;

@end
