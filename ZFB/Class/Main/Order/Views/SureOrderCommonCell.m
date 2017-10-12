//
//  SureOrderCommonCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SureOrderCommonCell.h"

@implementation SureOrderCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.canUsedCouponNum.layer.masksToBounds = YES;
    self.canUsedCouponNum.layer.cornerRadius = 2;
    self.canUsedCouponNum.layer.borderWidth = 0.5;
    self.canUsedCouponNum.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
