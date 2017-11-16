//
//  ZFTitleAndChooseListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFTitleAndChooseListCell.h"

@implementation ZFTitleAndChooseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle              = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
