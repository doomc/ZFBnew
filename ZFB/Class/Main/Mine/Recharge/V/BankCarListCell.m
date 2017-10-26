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
    self.bankName.text = banklist.bank_name;
    [self.bankIMG sd_setImageWithURL:[NSURL URLWithString:banklist.bank_img] placeholderImage:nil];
    
    NSString * origincardNo = banklist.bank_num;
    NSString *firstCardNo = [origincardNo  substringToIndex:origincardNo.length-4];
    //后四位数字
    NSString *lastfourCardno = [origincardNo  substringFromIndex:origincardNo.length - 4];
    //银行卡号 前4位
    self.cardNum.text = firstCardNo;
    //后四位
    self.lb_tailNumber.text = lastfourCardno;
    if ([banklist.bank_type isEqualToString:@"1"]) {//1 为借记卡 2信用卡
        self.bankType.text = @"储蓄卡";
    }else{
        self.bankType.text = @"信用卡";

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
