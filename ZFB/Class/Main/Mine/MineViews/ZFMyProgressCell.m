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
    
  
}

///待付款
- (IBAction)waitForPaybutton:(id)sender {
   
    if ([self.delegate respondsToSelector:@selector(didClickWaitForPayAction:)]) {
        
        [self.delegate didClickWaitForPayAction:sender];
    }
    
}
///已配送
- (IBAction)serviceSended:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickSendedAction:)]) {
        
        [self.delegate didClickSendedAction:sender];
    }
}
///待评价
- (IBAction)waitForEvaluate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickWaitForEvaluateAction:)]) {
        
        [self.delegate didClickWaitForEvaluateAction:sender];
    }
}
///退货
- (IBAction)bacKgoods:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickBacKgoodsAction:)]) {
        
        [self.delegate didClickBacKgoodsAction:sender];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
