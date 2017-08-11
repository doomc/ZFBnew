//
//  ZFSaleAfterHeadCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterHeadCell.h"

@implementation ZFSaleAfterHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setOrderlist:(Orderlist *)orderlist
{
    _orderlist = orderlist;
    
    self.lb_orderCode.text = [NSString stringWithFormat:@"订单编号:%@", _orderlist.orderCode];
    self.creatOrdertime.text = [NSString stringWithFormat:@"下单时间:%@", _orderlist.createTime];
    self.lb_status.text =_orderlist.orderStatusName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
