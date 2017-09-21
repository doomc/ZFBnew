//
//  DetailWebViewCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/8/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailWebViewCell.h" 
@interface DetailWebViewCell ()<UIWebViewDelegate>


@end
@implementation DetailWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _labelhtml = [[UILabel alloc]init];
    [self.contentView addSubview:_labelhtml];
}

 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
