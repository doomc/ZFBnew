//
//  ZFB_Urls.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#ifndef ZFB_Urls_h
#define ZFB_Urls_h

#import "MENetWorkManager.h"//加密网络请求
#import "NoEncryptionManager.h"//非加密网络请求

#import "MD5Tool.h"
#import "dateTimeHelper.h"
#import "NSString+Base64.h"
#import "ZFEncryptionKey.h"//ZFEncryptionKey加密排序规则
#import "NSString+JsonChange.h"//json的转换和MD5 base64加密


#pragma mark ------------- OSSUrl 阿里云图片服务器-------------
#define aliOSS_baseUrl @"http://zavfb.oss-cn-shenzhen.aliyuncs.com/"

#pragma mark ------------- 线上测试服务器--------------------
////基类
//#define  zfb_baseUrl @"https://app.api.zavfb.com/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"https://app.api.zavfb.com/im/user"
////群聊
//#define  IMGroup_baseUrl @"https://app.api.zavfb.com/group"

#pragma mark ------------- xd测试服务器数--------------------
////基类
//#define  zfb_baseUrl @"http://192.168.1.103:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.103:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.103:8087/group"

#pragma mark ------------- tfy测试服务器数--------------------
////baseURL
//#define  zfb_baseUrl @"http://192.168.1.222:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.222:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.222:8087/group"


#pragma mark ------------- 测试服务器数--------------------
//baseURL
#define  zfb_baseUrl @"http://192.168.1.113:8087/zfb/InterfaceServlet"
//单聊
#define  IMsingle_baseUrl @"http://192.168.1.113:8087/im/user"
//群聊
#define  IMGroup_baseUrl @"http://192.168.1.113:8087/group"

#pragma mark ------------- --------------------
////baseURL
//#define  zfb_baseUrl @"http://192.168.1.166:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.166:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.166:8087/group"


#pragma mark -------------支付服务 -------------------
//测试支付地址
//#define paySign_baseUrl @"http://192.168.1.115:8080"
//正式支付地址
#define paySign_baseUrl  @"https://pay.zavfb.com"


#endif /* ZFB_Urls_h */
