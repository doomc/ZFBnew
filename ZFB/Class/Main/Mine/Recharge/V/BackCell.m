
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
    self.backName.text = [NSString stringWithFormat:@"%@",bankList.bank_name];
    //后4位
    NSString *lastfourCardno = [bankList.bank_num  substringFromIndex:bankList.bank_num.length - 4];
    self.backNo.text = [NSString stringWithFormat:@"尾号(%@)",lastfourCardno];
    [self.backImg sd_setImageWithURL:[NSURL URLWithString:bankList.bank_img] placeholderImage:[UIImage imageNamed:@"head"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
