//
//  CouponCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //按钮
    _didClickget_btn.layer.cornerRadius = 4;
    _didClickget_btn.layer.masksToBounds = YES;
    _didClickget_btn.layer.borderWidth = 1;
    _didClickget_btn.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    
    //背景图
    
    //快过期
    
    //已使用
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
