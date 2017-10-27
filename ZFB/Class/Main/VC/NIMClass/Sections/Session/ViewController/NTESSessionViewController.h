//
//  NTESSessionViewController.h
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NIMSessionViewController.h"

@interface NTESSessionViewController : NIMSessionViewController

@property (nonatomic,assign) BOOL disableCommandTyping;  //需要在导航条上显示“正在输入”

@property (nonatomic,assign) BOOL disableOnlineState;  //需要在导航条上显示在线状态

@property (nonatomic,assign) BOOL isVipStore;  //判断是不是店铺

@property (nonatomic,copy) NSString * storeId;

@property (nonatomic,copy) NSString * storeName;

@end
