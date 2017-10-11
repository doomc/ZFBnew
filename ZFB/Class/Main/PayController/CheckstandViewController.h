//
//  CheckstandViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface CheckstandViewController : BaseViewController

@property (nonatomic , copy) NSString * BalancePaySign;//余额签名
@property (nonatomic , copy) NSString * WXPaySign;//微信签名
@property (nonatomic , copy) NSString * amount;//实付金额
@property (nonatomic , copy) NSString * zavfpay_num;//微信商户订单
@property (nonatomic , copy) NSString * notifyUrl;//微信回调地址
@property (nonatomic , copy) NSDictionary * signDic;//发起签名请求

@end