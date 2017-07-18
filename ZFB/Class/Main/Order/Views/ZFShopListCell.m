//
//  ZFShopListCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopListCell.h"

@implementation ZFShopListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_shopView.clipsToBounds = YES;
    self.img_shopView.layer.borderWidth = 0.5;
    self.img_shopView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
