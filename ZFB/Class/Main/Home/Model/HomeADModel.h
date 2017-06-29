//
//  HomeADModel.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeADModel : ResponseObject

/** 图片id*/
@property (nonatomic, copy) NSString * pid;//(id)

/** 图片名称 */
@property (nonatomic, copy) NSString * imgTitle;

/** 商品id */
@property (nonatomic, copy) NSString * goodId;

/** 跳转地址 */
@property (nonatomic, copy) NSString * redirectUrl;

/** 图片地址*/
@property (nonatomic, copy) NSString * imgUrl;

/** 返回 0 成功、1失败 */
@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, strong) HomeADModel * cmAdvertImgList;/* 自我模型类型 */

@end
