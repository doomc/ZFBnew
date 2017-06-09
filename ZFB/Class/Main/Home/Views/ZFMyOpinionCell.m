//
//  ZFMyOpinionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyOpinionCell.h"

@implementation ZFMyOpinionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //多行必须写
    [self.lb_title setPreferredMaxLayoutWidth:(KScreenW - 40)];
//    
//    if ([self.lb_status.text isEqualToString:@"未查看"]) {
//        self.lb_status.textColor = HEXCOLOR(0xfe6d6a);
//    }
//    else{
//        self.lb_status.textColor = HEXCOLOR(0x363636);
//  
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
