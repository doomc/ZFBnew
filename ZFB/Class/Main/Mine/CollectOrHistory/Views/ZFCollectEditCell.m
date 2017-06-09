//
//  ZFCollectEditCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCollectEditCell.h"

@implementation ZFCollectEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_editView.clipsToBounds = YES;
    self.img_editView.layer.borderWidth = 0.5;
    self.img_editView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
