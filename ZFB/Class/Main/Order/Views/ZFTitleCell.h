//
//  ZFTitleCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
#import "BusinessOrderModel.h"


@interface ZFTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_nameOrTime;

@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;

@property (strong, nonatomic)  Orderlist * orderlist;//全部订单

@property (strong, nonatomic)  BusinessOrderlist * businessOrder;//商户端订单



@end
