//
//  ZFAppySalesReturnCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAppySalesReturnCell.h"

@implementation ZFAppySalesReturnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    self.img_saleAfterListView.clipsToBounds = YES;
    self.img_saleAfterListView.layer.borderWidth = 0.5;
    self.img_saleAfterListView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
