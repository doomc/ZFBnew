//
//  ZFMyProgressCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyProgressCell.h"

@implementation ZFMyProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.bacKgoods_btn addTarget:self action:@selector(bacKgoods_btnAction:)  forControlEvents:UIControlEventTouchUpInside];
}

-(void)bacKgoods_btnAction:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(pushToSaleAfterview)]) {
        
        [self.delegate pushToSaleAfterview];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
