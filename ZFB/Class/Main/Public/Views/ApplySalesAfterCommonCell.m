//
//  ApplySalesAfterCommonCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ApplySalesAfterCommonCell.h"

@implementation ApplySalesAfterCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.commonBack_btn.layer.borderWidth = 0.5;
    self.commonBack_btn.layer.cornerRadius = 2;
    self.commonBack_btn.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
    
    UIFont *font =[UIFont systemFontOfSize:12];
    CGSize size = [self.commonBack_btn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat btb_width = size.width;
    self.commonBack_btn.frame = CGRectMake(0, 0, btb_width, 20);
    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
