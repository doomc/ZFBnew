//
//  BusinessSendAccountCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BusinessSendAccountCell.h"

@implementation BusinessSendAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setCacuList:(Settlementlist *)cacuList
{
    _cacuList = cacuList;
    _lb_amount.text = [NSString stringWithFormat:@"结算金额:  ¥%.f",cacuList.settlement_store_amount];
    _lb_orderPrice.text = [NSString stringWithFormat:@"订单金额:  ¥%.f",cacuList.order_amount];
    _lb_orderNum.text = [NSString stringWithFormat:@"订单号:  %@",cacuList.order_num];
    _lb_acountNum.text = [NSString stringWithFormat:@"结算编号:  %@",cacuList.settlement_num];
    _lb_orderTime.text = [NSString stringWithFormat:@"结算时间:  %@",cacuList.settlement_time];
}


-(void)setSendList:(Settlementlist *)sendList
{
    _sendList = sendList;
    _lb_amount.text = [NSString stringWithFormat:@"结算金额:  ¥%.f",sendList.settlement_delivery_amount];
    _lb_orderPrice.text = [NSString stringWithFormat:@"订单金额:  ¥%.f",sendList.order_amount];
    _lb_orderNum.text = [NSString stringWithFormat:@"订单号:  %@",sendList.order_num];
    _lb_acountNum.text = [NSString stringWithFormat:@"结算编号:  %@",sendList.settlement_num];
    _lb_orderTime.text = [NSString stringWithFormat:@"结算时间:  %@",sendList.settlement_time];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
