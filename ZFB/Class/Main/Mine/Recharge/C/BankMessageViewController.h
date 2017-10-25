//
//  BankMessageViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface BankMessageViewController : BaseViewController


@property (nonatomic , copy) NSString  * baseBankName;//银行卡名字
@property (nonatomic , copy) NSString  * baseBankLogUrl;//银行卡logo
@property (nonatomic , copy) NSString  * bankCredType;//银行卡类型 1 储蓄卡 2信用卡

@property (nonatomic , copy) NSString  * bankCredNum;//银行卡号
@property (nonatomic , copy) NSString  * bankCredHolder;//银行卡持有人姓名
@property (nonatomic , copy) NSString  * baseBankId;//银行卡id


@end
