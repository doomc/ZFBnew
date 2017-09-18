//
//  ZFAddressListViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

//回调到确认订单的数据
typedef void(^CallBackOrderBlock)(NSString * PossName, NSString * PossAddress,NSString * PossPhone,NSString * PossAddressId);

@interface ZFAddressListViewController : BaseViewController

@property (nonatomic,copy) CallBackOrderBlock orderBackBlock;


@end
