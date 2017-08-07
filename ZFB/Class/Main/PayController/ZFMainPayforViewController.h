//
//  ZFMainPayforViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  结算列表 ，选择支付方式

#import "BaseViewController.h"

@interface ZFMainPayforViewController : BaseViewController

@property (nonatomic,copy ) NSString  * datetime;
@property (nonatomic,copy ) NSString  * access_token;
@property (nonatomic,strong )NSArray  * orderListArray;

//支付的回调地址
@property (nonatomic,copy ) NSString  * notify_url;
@property (nonatomic,copy ) NSString  * return_url;
@property (nonatomic,copy ) NSString  * gateWay_url;






@end
