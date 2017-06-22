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
#import "WBRequest.h"

#import "MD5Tool.h"
#import "dateTimeHelper.h"
#import "NSString+Base64.h"
#import "ZFEncryptionKey.h"//ZFEncryptionKey加密排序规则
#import "NSString+JsonChange.h"//json的转换和MD5 base64加密



//图片服务器
#define  uploadImgae_Url @"http://192.168.1.106:8086/cmfile/upload"

//数据服务器
#define  ZFB_22SendMessageUrl @"http://192.168.1.106:8086/zfb/InterfaceServlet"

#define  ZFB_11SendMessageUrl @"http://192.168.1.107:8087/zfb/InterfaceServlet"




//登录注册


//发送场景短信验证码







#endif /* ZFB_Urls_h */
