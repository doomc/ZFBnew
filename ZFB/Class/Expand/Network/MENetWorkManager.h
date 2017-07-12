//
//  MENetWorkManager.h
//  UIViewExtension
//
//  Created by jinghua on 16/3/12.
//  Copyright © 2016年 Sugar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MENetWorkManager : NSObject
/**
 *  post request
 *
 *  @param url      url
 *  @param params   参数
 *  @param success  成功回调
 *  @param progress 进度
 *  @param failure  失败回调
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response))success progress:(void(^)(NSProgress * progeress))progress failure:(void(^)(NSError * error))failure;

/**
 *  post request
 *
 *  @param url       url
 *  @param params    参数
 *  @param success   成功回调
 *  @param progeress 进度
 *  @param failure   失败回调
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response)) success progress:(void(^)(NSProgress * progeress))progeress failure:(void(^)(NSError * error))failure;



@end
