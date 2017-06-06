//
//  ZFCollectCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFHistoryCell.h"

@implementation ZFHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.img_collctView.clipsToBounds = YES;
    self.img_collctView.layer.borderWidth = 0.5;
    self.img_collctView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end