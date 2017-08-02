//
//  SendServiceFootCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendServiceOrderModel.h"

@interface SendServiceFootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_orderPrice;

@property (weak, nonatomic) IBOutlet UILabel *lb_freePrice;

@property (nonatomic , strong) SendServiceStoreinfomap * storeList;

@end
