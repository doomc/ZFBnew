
//
//  ApplySalesUploadCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ApplySalesUploadCell.h"

@implementation ApplySalesUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.enter_btn addTarget:self action:@selector(sureReturanWays:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sureReturanWays:(UIButton *)sender
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
