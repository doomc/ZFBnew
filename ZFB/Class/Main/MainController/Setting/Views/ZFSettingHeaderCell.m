//
//  ZFSettingHeaderCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSettingHeaderCell.h"
@implementation ZFSettingHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.img_headView.clipsToBounds = YES;
    self.img_headView.layer.cornerRadius = 14;
    
    self.img_headView.layer.borderWidth = 0.5;
    self.img_headView.layer.borderColor = HEXCOLOR(0xffffff).CGColor;
    [self.img_headView setImage:[UIImage  circleImage:@"setting_headView"]];
    [self.img_headView.image circleImage];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
