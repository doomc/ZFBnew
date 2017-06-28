//
//  ZFAddOfListCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFAddOfListCell.h"

@implementation ZFAddOfListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.defaultButton.clipsToBounds = YES;
    self.defaultButton.layer.cornerRadius = 2;
    
}
///点击编辑
- (IBAction)didEdit:(id)sender {

    if ([self.delegate respondsToSelector:@selector(editAction:)]) {
        [self.delegate editAction:self.index];
    }
}
///点击删除
- (IBAction)didDelete:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAction:)]) {
        [self.delegate deleteAction:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
