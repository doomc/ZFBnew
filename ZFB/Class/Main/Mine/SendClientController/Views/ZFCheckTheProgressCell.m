//
//  ZFCheckTheProgressCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCheckTheProgressCell.h"

@implementation ZFCheckTheProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.checkProgress_btn addTarget:self action:@selector(actionTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkProgress_btn.clipsToBounds = YES;
    self.checkProgress_btn.layer.cornerRadius = 3;
}
-(void)actionTarget:(UIButton*)sender{
    
    if (   [self.deldegate respondsToSelector:@selector(progressWithCheckout)]) {
        [self.deldegate progressWithCheckout];
        
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
