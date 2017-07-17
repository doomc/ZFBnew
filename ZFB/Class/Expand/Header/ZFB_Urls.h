//
//  ZFB_Urls.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#ifndef ZFB_Urls_h
#define ZFB_Urls_h

#import "MENetWorkManager.h"//网络请求

#import "MD5Tool.h"
#import "dateTimeHelper.h"
#import "NSString+Base64.h"
#import "ZFEncryptionKey.h"//ZFEncryptionKey加密排序规则
#import "NSString+JsonChange.h"//json的转换和MD5 base64加密


//baseUrl
#define  zfb_baseUrl @"http://192.168.1.104:8087/zfb/InterfaceServlet"

//图片服务器
#define  uploadImgae_Url @"http://192.168.1.106:8086/cmfile/upload"

//数据服务器
#define  ZFB_22SendMessageUrl @"http://192.168.1.106:8087/zfb/InterfaceServlet"
//
#define  ZFB_11SendMessageUrl @"http://192.168.1.107:8087/zfb/InterfaceServlet"

#define  zfb_url @"http://192.168.1.113:8087/zfb/InterfaceServlet"



#pragma mark -------------测试服务器数--------------------
//#define  zfb_baseUrl @"http://192.168.1.113:8087/zfb/InterfaceServlet"





#endif /* ZFB_Urls_h */
