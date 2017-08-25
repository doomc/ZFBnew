//
//  ZFBCustomConfig.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFBCustomConfig.h"
@interface ZFBCustomConfig ()


@end
@implementation ZFBCustomConfig

+ (instancetype)sharedConfig
{
    static ZFBCustomConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZFBCustomConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey = @"6bd36bd4bfadba812aff256259316848";
        _apnsCername = @"DevelopmentPushCer";
        _pkCername = @"DPushKitCer";
        
        _redPacketConfig = [[NTESRedPacketConfig alloc] init];
    }
    return self;
}

@end



@implementation NTESRedPacketConfig

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _useOnlineEnv = YES;
        _aliPaySchemeUrl = @"alipay052969";
        _weChatSchemeUrl = @"wx2a5538052969956e";
    }
    return self;
}

@end
