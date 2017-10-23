//
//  BankCarListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BankCarListCell.h"

@implementation BankCarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setBanklist:(BankList *)banklist{
    _banklist = banklist;
    _bankName.text = banklist.bank_name;
    [_bankIMG sd_setImageWithURL:[NSURL URLWithString:banklist.bank_img] placeholderImage:nil];
    _cardNum.text = banklist.bank_num;
    if ([banklist.bank_type isEqualToString:@"1"]) {//1 为借记卡 。。。。暂时不清楚
        _bankType.text = @"借记卡";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
