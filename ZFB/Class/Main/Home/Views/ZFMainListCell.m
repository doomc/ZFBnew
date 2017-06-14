//
//  ZFMainListCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMainListCell.h"

@implementation ZFMainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.Classify_btn addTarget:self action:@selector(Classify_btnActionTarget:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)Classify_btnActionTarget:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickAllClassAction:)]) {
        [self.delegate didClickAllClassAction:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
