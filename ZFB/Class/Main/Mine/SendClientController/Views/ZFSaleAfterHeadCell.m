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
    self.lb_orderCode.text = _orderlist.orderCode;
    //13位时间戳
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_orderlist.createTime doubleValue] / 1000];
//    self.creatOrdertime.text = [dateTimeHelper TimeToLocationStr:date];
    self.lb_status.text =_orderlist.orderStatusName;
    self.creatOrdertime.text = _orderlist.createTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
