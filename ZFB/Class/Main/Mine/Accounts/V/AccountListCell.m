
//
//  AccountListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AccountListCell.h"

@implementation AccountListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 20;
    
    self.lb_title.preferredMaxLayoutWidth = KScreenW - 40 -100 -20;
}

-(void)setCashlist:(Cashflowlist *)cashlist
{
    _cashlist = cashlist;
    
    _lb_title.text  = cashlist.transfer_description;
    _lb_time.text  = cashlist.create_time ;
    if (cashlist.flow_pay_type == 0) {//流水支付类型 0支出 1 收入
        _lb_price.text = [NSString stringWithFormat:@" -%.2f",cashlist.transaction_amount];

    }else{
        _lb_price.text = [NSString stringWithFormat:@" +%.2f",cashlist.transaction_amount];
    }
    [_headImg sd_setImageWithURL:[NSURL URLWithString:cashlist.logo_url] placeholderImage:[UIImage imageNamed:@"head"]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
