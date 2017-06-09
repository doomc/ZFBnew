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
    self.lb_Price.hidden = YES;
    self.lb_Price.text =@"¥ 199.00";
 
    
}
 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
