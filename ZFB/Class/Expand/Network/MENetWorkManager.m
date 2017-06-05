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
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json", @"text/json", @"text/javascript"]];


    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
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


//1.设置请求头
+(AFHTTPSessionManager*) sessionManager
{
    AFHTTPSessionManager* sessinManager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    sessinManager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    // 设置请求头
    [sessinManager.requestSerializer setValue:@"" forHTTPHeaderField:@"xxx"];
    [sessinManager.requestSerializer setValue:@"" forHTTPHeaderField:@"xxxx"];
    // 时间戳
    NSString *timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    [sessinManager.requestSerializer setValue:timeInterval forHTTPHeaderField:@"r"];
 
    
    sessinManager.requestSerializer.timeoutInterval=5.0;
    
    return sessinManager;
}

//发送请求
+(void)downUpImageSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager* sessionManager= [self sessionManager];
    NSString* path=@"xxxxxx";
    NSMutableDictionary* param=[NSMutableDictionary dictionary];
    param[@"xxxx"]=@"";
    
    [sessionManager POST:path parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /***** 在这里直接添加上传的图片 *****/
        UIImage *image = [UIImage imageNamed:@"image_test"];
        NSData *data = UIImagePNGRepresentation(image);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 获取上传进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        if ([JSON[@"code"] integerValue] != 0) { // 返回 code 值不为 0
            NSError* error=[[NSError alloc] initWithDomain:JSON[@"msg"] code:[JSON[@"code"] integerValue] userInfo:@{@"msg" : JSON[@"msg"]}];
            failure(error);
            return ;
        }
        NSLog(@"上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        failure(error);
    }];
}

@end
