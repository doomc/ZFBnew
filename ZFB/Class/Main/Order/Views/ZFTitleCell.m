//
//  ZFTitleCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFTitleCell.h"

@implementation ZFTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//商户端的头部
-(void)setBusinessOrder:(BusinessOrderlist *)businessOrder
{
    _businessOrder = businessOrder;

    self.lb_nameOrTime.text = businessOrder.createTime;
    self.lb_storeName.text = businessOrder.storeName;
    [self.statusButton setTitle:businessOrder.orderStatusName forState:UIControlStateNormal];
    
}
// 订单列表
-(void)setOrderlist:(Orderlist *)orderlist
{
    _orderlist = orderlist;
    
    if (orderlist.payType == 0) {
        self.lb_payMethod.text = @"线下订单";
    }else{
        self.lb_payMethod.text = @"";
    }
    self.lb_nameOrTime.text = orderlist.createTime;
    self.lb_storeName.text = orderlist.storeName;
    [self.statusButton setTitle:orderlist.orderStatusName forState:UIControlStateNormal];

    
}


 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
