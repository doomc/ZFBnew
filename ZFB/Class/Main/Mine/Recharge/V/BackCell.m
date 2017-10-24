
//
//  BackCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BackCell.h"

@implementation BackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
}
-(void)setBankList:(BankList *)bankList
{
    _bankList = bankList;
    NSString * bankType = bankList.bank_type;// 银行卡类型
    
    self.backName.text = [NSString stringWithFormat:@"%@",bankList.bank_name];
    self.backNo.text = [NSString stringWithFormat:@"尾号%@",bankList.bank_num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
