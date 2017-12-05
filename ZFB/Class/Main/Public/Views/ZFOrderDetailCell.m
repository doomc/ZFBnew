//
//  ZFOrderDetailCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFOrderDetailCell.h"

@implementation ZFOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle       = UITableViewCellSelectionStyleNone;
    self.lb_detaileFootTitle.preferredMaxLayoutWidth = KScreenW - 15 - 20 -80;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
