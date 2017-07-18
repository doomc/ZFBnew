//
//  ZFFooterCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
@interface ZFFooterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_plachorer;

@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;

@property (weak, nonatomic) IBOutlet UIButton *cancel_button;

@property (weak, nonatomic) IBOutlet UIButton *payfor_button;

@property (nonatomic, strong) Orderlist * orderlist ;

@end
