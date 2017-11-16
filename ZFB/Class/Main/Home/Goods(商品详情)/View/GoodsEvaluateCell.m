//
//  GoodsEvaluateCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "GoodsEvaluateCell.h"

@implementation GoodsEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lb_content.preferredMaxLayoutWidth = KScreenW - 30;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
