//
//  DetailAcountHeaderCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/9.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailAcountHeaderCell.h"

@implementation DetailAcountHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end