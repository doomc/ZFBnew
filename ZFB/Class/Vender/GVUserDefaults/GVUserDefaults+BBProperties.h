//
//  GVUserDefaults+BBProperties.h
//  GrowthDiary
//
//  Created by wujunyang on 16/1/5.
//  Copyright (c) 2016年 wujunyang. All rights reserved.
//

#import "GVUserDefaults.h"

#define BBUserDefault [GVUserDefaults standardUserDefaults]

@interface GVUserDefaults (BBProperties)

#pragma mark -- personinfo
@property (nonatomic,copy) NSString *userPhoneNumber;//第一次注册的手机号
@property (nonatomic,copy) NSString *userPhonePassword;//第一次注册的密码
@property (nonatomic,copy) NSString *smsCode;//有效时间30分钟
@property (nonatomic,copy) NSString *newPassWord;//修改的新密码保存

@property (nonatomic,copy) NSString *cmUserId;
@property (nonatomic,copy) NSString *nickName;//默认用户昵称
@property (nonatomic,copy) NSString *userKeyMd5;//默认用户昵称
@property (nonatomic,copy) NSString *userStatus;//登录状态 1已在线  0下线

@property (nonatomic) BOOL boolValue;
@property (nonatomic) float floatValue;


#pragma mark --是否是第一次启动APP程序
@property (nonatomic,assign) BOOL isNoFirstLaunch;

#pragma mark --是否已经登录
@property (nonatomic,assign) BOOL isLogin;
@end
