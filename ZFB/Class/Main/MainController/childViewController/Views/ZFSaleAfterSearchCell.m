
//
//  ZFSaleAfterSearchCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterSearchCell.h"

@implementation ZFSaleAfterSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgViewCorner.clipsToBounds = YES;
    self.bgViewCorner.layer.cornerRadius = 8;
    self.bgViewCorner.layer.borderWidth =1;
    self.bgViewCorner.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
