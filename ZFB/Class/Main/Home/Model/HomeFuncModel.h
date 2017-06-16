//
//  HomeFuncModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeFuncModel : NSObject
/** 商品id*/
@property (nonatomic, copy) NSString * pid;//(id)

/** 商品分类名称 */
@property (nonatomic, copy) NSString * name;

/** 图标url地址 */
@property (nonatomic, copy) NSString * iconUrl;


/** 返回 0 成功、1失败 */
@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, strong) HomeFuncModel * cmAdvertImgList;/* 自我模型类型 */

@end
