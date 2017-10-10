//
//  PayFootCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PayFootCell.h"

@implementation PayFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _paySure_btn.layer.masksToBounds = YES;
    _paySure_btn.layer.cornerRadius = 4;

}
//确认支付
- (IBAction)didClickChoosePaymethod:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSurePay)]) {
        [self.delegate didClickSurePay];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
