//
//  SupportBankCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SupportBankCell.h"

@implementation SupportBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
-(void)setBankList:(Base_Bank_List *)bankList
{
    _bankList = bankList;
    [_bankIMG sd_setImageWithURL:[NSURL URLWithString:bankList.base_bank_log_url] placeholderImage:[UIImage imageNamed:@""]];
    _bankName.text = bankList.base_bank_name;
 
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
