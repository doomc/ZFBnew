//
//  ShareNewGoodsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐

#import "ShareNewGoodsCell.h"
#import "UIImageView+ZFCornerRadius.h"
@implementation ShareNewGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImage.clipsToBounds = YES;
    [self.headImage CreateImageViewWithFrame:_headImage.frame andBackground:nil andRadius:_headImage.width/2];
    
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
