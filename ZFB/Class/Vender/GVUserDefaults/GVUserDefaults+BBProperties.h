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
@property (nonatomic,copy) NSString *userPhoneNumber;///第一次注册的手机号
@property (nonatomic,copy) NSString *userPhonePassword;///第一次注册的密码
@property (nonatomic,copy) NSString *smsCode;///有效时间30分钟
@property (nonatomic,copy) NSString *newPassWord;///修改的新密码保存
 
@property (nonatomic,copy) NSString *cmUserId;
@property (nonatomic,copy) NSString *accid;

//登录的
@property (nonatomic,copy) NSString *nickName;///默认用户昵称
@property (nonatomic,copy) NSString *userHeaderImg;///默认用户头像
@property (nonatomic,copy) NSString *userKeyMd5;///默认用户昵称
 
//云信
@property (nonatomic,copy) NSString *token;/// 网易云信的token
@property (nonatomic,copy) NSString *unReadCount;///未读消息数

//首页
@property (nonatomic,copy) NSString *latitude;///纬度
@property (nonatomic,copy) NSString *longitude;///经度

//个人中心
@property (nonatomic,copy) NSString *shopFlag;///是否是商户  1是 0 不是
@property (nonatomic,copy) NSString *deliveryFlag;///是否是配送员 1是 0不是
@property (nonatomic,copy) NSString *isSetPassword;///密码是否重置 1 修改过了，0没有修改
@property (nonatomic,copy) NSString *realNameFlag;///是否实名认证 1是 2否

//个人资料资料
@property (nonatomic,copy) NSString * uploadImgName;///个人资料头像路径
@property (nonatomic,copy) NSString * birthDay;///个人生日日期
@property (nonatomic,assign) NSInteger sexType;///性别类型 //1. 男 2.女 3保密
 

//推送的总个数   网易云信+JPush
@property (nonatomic,assign) NSInteger yunBadge;


@property (nonatomic) BOOL boolValue;
@property (nonatomic) float floatValue;

@property (nonatomic,strong) NSMutableArray *searchHistoryArray;///搜索历史数组

#pragma mark --是否是第一次启动APP程序
@property (nonatomic,assign) BOOL isNoFirstLaunch;

#pragma mark --是否已经登录
@property (nonatomic,assign) int isLogin;

#pragma mark - 判断是否收藏了_isCollect
@property (nonatomic,assign) NSInteger isCollect;

@end
