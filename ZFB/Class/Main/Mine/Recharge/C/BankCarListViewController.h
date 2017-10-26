//
//  BankCarListViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"
#import "BankCardListModel.h"

@interface BankCarListViewController : BaseViewController

typedef void (^BankBlock)(BankList *  banklist);

@property (copy, nonatomic) BankBlock bankBlock;


@end
