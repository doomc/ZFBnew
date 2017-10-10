//
//  DetailAccountViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailAccountViewController : BaseViewController

@property (nonatomic , copy) NSString * flowId;

/**
 支付类型	1 转账 2 退款 3 充值 4 订单 5 提现 6佣金
 */
@property (nonatomic , copy) NSString * pay_type;


@end
