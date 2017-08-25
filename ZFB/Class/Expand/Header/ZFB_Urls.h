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


//单聊
#define  IMsingle_baseUrl @"http://192.168.1.113:8087/im/user"
//群聊
#define  IMGroup_baseUrl @"http://192.168.1.113:8087/group"




//图片服务器
#define  uploadImgae_Url @"http://192.168.1.106:8086/cmfile/upload"
//数据服务器
#define  cqdUrl @"http://192.168.1.107:8087/zfb/InterfaceServlet"


#pragma mark -------------正式服务器--------------------

#define  zfb_baseUrl @"http://14.29.47.144:8087/zfb/InterfaceServlet"


 
#pragma mark -------------测试服务器数--------------------

//#define  zfb_baseUrl @"http://192.168.1.113:8087/zfb/InterfaceServlet"
#define PayResulrUrl @"http://192.168.1.115:8080/cashier_zavfpay/cashier/gateway.do"//支付页面地址
//#define notify_url   @"http://192.168.1.104:8087/notify/order/getOrderNotify"//支付异步回调地址
//#define return_url   @"http://localhost:8080/return"//支付同步回调地址





#endif /* ZFB_Urls_h */
