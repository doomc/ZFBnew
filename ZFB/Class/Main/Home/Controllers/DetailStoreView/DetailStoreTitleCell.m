//
//  DetailStoreTitleCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailStoreTitleCell.h"
@interface DetailStoreTitleCell ()<UIGestureRecognizerDelegate>

@end
@implementation DetailStoreTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCalling)];
    tap.delegate = self;
    self.callImageView.userInteractionEnabled = YES;
    [self.callImageView addGestureRecognizer:tap];
    
    
}

-(void)tapCalling
{
    if ([self.delegate respondsToSelector:@selector(callingBack)]) {
        [self.delegate callingBack];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
