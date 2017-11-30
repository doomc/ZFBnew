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
    _lb_amount.text = [NSString stringWithFormat:@"¥%@",cacuList.settlement_store_amount];
    _lb_orderPrice.text = [NSString stringWithFormat:@"¥%@",cacuList.order_amount];
    _lb_orderNum.text = [NSString stringWithFormat:@"%@",cacuList.order_num];
    _lb_acountNum.text = [NSString stringWithFormat:@"%@",cacuList.settlement_num];
    _lb_orderTime.text = [NSString stringWithFormat:@"%@",cacuList.settlement_time];
}


-(void)setSendList:(Settlementlist *)sendList
{
    _sendList = sendList;
    _lb_amount.text = [NSString stringWithFormat:@"¥%@",sendList.settlement_delivery_amount];
    _lb_orderPrice.text = [NSString stringWithFormat:@"¥%@",sendList.order_amount];
    _lb_orderNum.text = [NSString stringWithFormat:@"%@",sendList.order_num];
    _lb_acountNum.text = [NSString stringWithFormat:@"%@",sendList.settlement_num];
    _lb_orderTime.text = [NSString stringWithFormat:@"%@",sendList.settlement_time];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
