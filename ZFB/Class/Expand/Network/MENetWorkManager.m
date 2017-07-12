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

+(void)post:(NSString *)url params:(NSDictionary *)params
                           success:(void (^)(id response))success
                          progress:(void (^)(NSProgress * progeress))progeress
                           failure:(void (^)(NSError * error))failure {
   
    //参数加密规则
    ZFEncryptionKey  * keydic = [ZFEncryptionKey new];
    NSDictionary * parma = [keydic signStringWithParam:params];
    NSLog(@"已经加密的参数%@",parma);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     //{"data":"eyJjbVVzZXJJZCI6IjMifQ==","sign":"980d8b6bb533375f0559786b2ae039ca","signType":"MD5","svcName":"getUserInfo","transactionTime":"20170706163611","userId":"2","transactionId":"20170706163611"}
//
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
    [manager POST:url parameters:parma progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progeress) {
            progeress(uploadProgress);
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


@end
