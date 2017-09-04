//
//  ZFAddressListViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

//回调到确认订单的数据
typedef void(^CallBackBlock)(NSString * PossName, NSString * PossAddress,NSString * PossPhone);

@interface ZFAddressListViewController : BaseViewController

@property (nonatomic,copy)CallBackBlock callBackBlock;


@end
