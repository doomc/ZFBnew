//
//  OrderPriceCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "OrderPriceCell.h"

@implementation OrderPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle   = UITableViewCellSelectionStyleNone;

}

- (IBAction)didclickDetail:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(checkDetailAction:)]) {
        [self.delegate checkDetailAction:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
