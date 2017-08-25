//
//  ZFBCustomConfig.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NTESRedPacketConfig;

@interface ZFBCustomConfig : NSObject

//此处 apiURL 为网易云信 Demo 应用服务器地址，更换 appkey 后，请更新为应用自己的服务器接口地址，并提供相关接口服
+ (instancetype)sharedConfig;

@property (nonatomic,copy)    NSString    *appKey;
@property (nonatomic,copy)    NSString    *apnsCername;
@property (nonatomic,copy)    NSString    *pkCername;
@property (nonatomic,strong)  NTESRedPacketConfig *redPacketConfig;
@end


@interface NTESRedPacketConfig : NSObject

@property (nonatomic,assign)  BOOL  useOnlineEnv;

@property (nonatomic,strong)  NSString *aliPaySchemeUrl;

@property (nonatomic,strong)  NSString *weChatSchemeUrl;

@end
