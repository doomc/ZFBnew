//
//  AddBackButtonCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AddBackButtonCell.h"

@implementation AddBackButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addBackBtn.layer.masksToBounds = YES;
    self.addBackBtn.layer.borderWidth = 0.5;
    self.addBackBtn.layer.borderColor = HEXCOLOR(0xf95a70).CGColor;
    self.addBackBtn.layer.cornerRadius = 3;
    
    
    self.sureWithdrawBtn.layer.masksToBounds = YES;
    self.sureWithdrawBtn.layer.borderWidth = 0.5;
    self.sureWithdrawBtn.layer.borderColor = HEXCOLOR(0xf95a70).CGColor;
    self.sureWithdrawBtn.layer.cornerRadius = 3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

//添加银行卡
- (IBAction)addBankCard:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickAddBankCard)]) {
        [self.delegate didClickAddBankCard];
    }
}
//确认提现
- (IBAction)sureCashWithDraw:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickcashWithdraw)]) {
        [self.delegate didClickcashWithdraw];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
