//
//  NoEncryptionManager.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoEncryptionManager : NSObject

/**
 *  get request
 *
 *  @param url      url
 *  @param params   参数
 *  @param success  成功回调
 *  @param progress 进度
 *  @param failure  失败回调
 */
+ (void)noEncryptionGet:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response))success progress:(void(^)(NSProgress * progeress))progress failure:(void(^)(NSError * error))failure;

/**
 *  post request
 *
 *  @param url       url
 *  @param params    参数
 *  @param success   成功回调
 *  @param progeress 进度
 *  @param failure   失败回调
 */
+ (void)noEncryptionPost:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response)) success progress:(void(^)(NSProgress * progeress))progeress failure:(void(^)(NSError * error))failure;


@end
