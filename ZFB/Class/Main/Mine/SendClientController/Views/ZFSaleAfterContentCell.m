

//
//  ZFSaleAfterContentCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterContentCell.h"

@implementation ZFSaleAfterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.saleAfter_btn addTarget:self action:@selector(saleAfter_btnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)saleAfter_btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(salesAfterDetailPage)]) {
        [self.delegate salesAfterDetailPage];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
