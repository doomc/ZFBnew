//
//  PayforCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PayforCell.h"

@implementation PayforCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
 
 
    self.lb_balance.hidden = YES;
    self.btn_selected.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.btn_selected.selected = selected;
    
    // Configure the view for the selected state
}

@end
