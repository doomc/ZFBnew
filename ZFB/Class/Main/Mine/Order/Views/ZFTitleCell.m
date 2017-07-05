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

-(void)setOrderlist:(Orderlist *)orderlist
{
    _orderlist = orderlist;
    
    self.lb_storeName.text =_orderlist.storeName;
    
    //13位时间戳
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_orderlist.createTime doubleValue] / 1000];
    self.lb_nameOrTime.text = [dateTimeHelper TimeToLocationStr:date];
    
    [self.statusButton setTitle:[NSString stringWithFormat:@"订单状态%ld",_orderlist.orderStatus] forState:UIControlStateNormal];
    self.lb_storeName.text = _orderlist.storeName;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
