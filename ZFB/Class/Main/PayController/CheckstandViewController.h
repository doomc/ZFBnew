//
//  CheckstandViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface CheckstandViewController : BaseViewController

@property (nonatomic , copy) NSString * paySign;//获取到签名
@property (nonatomic , copy) NSString * amount;//实付金额
@property (nonatomic , copy) NSString * zavfpay_num;//微信商户订单
@property (nonatomic , copy) NSString * notifyUrl;//微信回调地址

@end
