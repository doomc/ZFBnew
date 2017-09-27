//
//  BusinessSendAccountCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaculaterModel.h"

@interface BusinessSendAccountCell : UITableViewCell

///结算单号
@property (weak, nonatomic) IBOutlet UILabel *lb_acountNum;
///订单号
@property (weak, nonatomic) IBOutlet UILabel *lb_orderNum;
///结算时间
@property (weak, nonatomic) IBOutlet UILabel *lb_orderTime;
///结算金额
@property (weak, nonatomic) IBOutlet UILabel *lb_amount;
///订单金额
@property (weak, nonatomic) IBOutlet UILabel *lb_orderPrice;

@property (strong, nonatomic)  Settlementlist * cacuList;//商户端
@property (strong, nonatomic)  Settlementlist * sendList;//配送端


@end
