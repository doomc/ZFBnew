//
//  QRPayMoneyViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface QRPayMoneyViewController : BaseViewController

///二维码
@property (weak, nonatomic) IBOutlet UIImageView *sacnCodeView;

///选择其他支付方式
@property (weak, nonatomic) IBOutlet UIButton *selectOtherPayMethod;

///付款记录
@property (weak, nonatomic) IBOutlet UIButton *payhistoryButton;


@end
