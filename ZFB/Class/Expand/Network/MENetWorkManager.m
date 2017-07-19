//
//  MENetWorkManager.m
//  UIViewExtension
//
//  Created by jinghua on 16/3/12.
//  Copyright © 2016年 Sugar. All rights reserved.
//

#import "MENetWorkManager.h"
#import "AFNetworking.h"

@implementation MENetWorkManager

+(void)get:(NSString *)url params:(NSDictionary *)params
                          success:(void (^)(id response))success
                         progress:(void (^)(NSProgress * progeress))progress
                          failure:(void (^)(NSError * error))failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    //参数加密规则
    ZFEncryptionKey  * keydic = [ZFEncryptionKey new];
    NSDictionary * parmaDic = [keydic signStringWithParamdic:params];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
    //添加一个默认参数
 
    [manager GET:url parameters:parmaDic progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}


+(void)post:(NSString *)url params:(NSDictionary *)params
                            success:(void (^)(id response))success
                            progress:(void (^)(NSProgress * progeress))progeress
                            failure:(void (^)(NSError * error))failure {
    
    //参数加密规则
    ZFEncryptionKey  * keydic = [ZFEncryptionKey new];
    NSDictionary * parmaStr = [keydic signStringWithParamdic:params];
    
    //选择请求方式
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json", @"text/json", @"text/javascript"]];
    
//    NSLog(@"已经加密的参数%@",parmaStr);
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:parmaStr progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progeress) {
            progeress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject != nil) {

                NSString *result = [NSString convertToJsonData:responseObject];
                NSLog(@"%@",result);
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
