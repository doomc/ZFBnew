//
//  NoEncryptionManager.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "NoEncryptionManager.h"
#import "AFNetworking.h"

@implementation NoEncryptionManager

+ (void)noEncryptionGet:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response))success progress:(void(^)(NSProgress * progeress))progress failure:(void(^)(NSError * error))failure
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
    //添加一个默认参数
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
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


+ (void)noEncryptionPost:(NSString *)url params:(NSDictionary *)params success:(void(^)(id response)) success progress:(void(^)(NSProgress * progeress))progeress failure:(void(^)(NSError * error))failure
{
    //选择请求方式
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json", @"text/json", @"text/javascript"]];

//        NSLog(@"已经加密的参数%@",parmaStr);
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progeress) {
            progeress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject != nil) {
                
//                NSString *result = [NSString convertToJsonData:responseObject];
//                NSLog(@"%@",result);
                NSLog(@"%@",responseObject);
                
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
