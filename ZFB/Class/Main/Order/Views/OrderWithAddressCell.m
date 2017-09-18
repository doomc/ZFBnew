//
//  OrderWithAddressCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "OrderWithAddressCell.h"

@implementation OrderWithAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle       = UITableViewCellSelectionStyleNone;
    self.lb_address.preferredMaxLayoutWidth = KScreenW - 30 - 46;
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
