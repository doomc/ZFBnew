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
#define  aliOSS_baseUrl @"http://zavfb.oss-cn-shenzhen.aliyuncs.com/"

#pragma mark ------------- 正式服务器--------------------
//baseURL
#define  zfb_baseUrl @"http://14.29.47.144:8087/zfb/InterfaceServlet"
//单聊
#define  IMsingle_baseUrl @"http://14.29.47.144:8087/im/user"
//群聊
#define  IMGroup_baseUrl @"http://14.29.47.144:8087/group"


#pragma mark ------------- CQD测试服务器数--------------------
////baseURL
//#define  zfb_baseUrl @"http://192.168.1.107:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.107:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.107:8087/group"

#pragma mark ------------- tfy测试服务器数--------------------
////baseURL
//#define  zfb_baseUrl @"http://192.168.1.222:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.222:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.222:8087/group"


//#pragma mark ------------- 测试服务器数--------------------
////baseURL
//#define  zfb_baseUrl @"http://192.168.1.113:8087/zfb/InterfaceServlet"
////单聊
//#define  IMsingle_baseUrl @"http://192.168.1.113:8087/im/user"
////群聊
//#define  IMGroup_baseUrl @"http://192.168.1.113:8087/group"

#pragma mark -------------支付服务 -------------------

#define PayResulrUrl @"http://192.168.1.115:8080/cashier_zavfpay/cashier/gateway.do"//支付页面地址
//#define notify_url   @"http://192.168.1.104:8087/notify/order/getOrderNotify"//支付异步回调地址
//#define return_url   @"http://localhost:8080/return"//支付同步回调地址




#endif /* ZFB_Urls_h */
