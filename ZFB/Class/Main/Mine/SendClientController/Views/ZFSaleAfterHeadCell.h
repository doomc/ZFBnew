//
//  ZFSaleAfterHeadCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"

@interface ZFSaleAfterHeadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_orderCode;
@property (weak, nonatomic) IBOutlet UILabel *creatOrdertime;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (strong, nonatomic) Orderlist * orderlist;

@end
