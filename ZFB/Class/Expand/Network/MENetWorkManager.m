//
//  MENetWorkManager.m
//  UIViewExtension
//
//  Created by jinghua on 16/3/12.
//  Copyright © 2016年 Sugar. All rights reserved.
//

#import "MENetWorkManager.h"

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
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[MENetWorkManager customSecurityPolicy]];
    
    manager.responseSerializer= [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json", @"text/json", @"text/javascript"]];

    [manager POST:url parameters:parmaStr progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progeress) {
            progeress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if (responseObject != nil) {
                
                NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"resultCode"]];
                if ([resultCode isEqualToString:@"3"]) {
                    BBUserDefault.isLogin = 0;
                    BBUserDefault.cmUserId = @"";
                }
                
                
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

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"app.api.zavfb.com" ofType:@"cer"];//证书的路径
    NSData * certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}


@end
