//
//  SendServiceTitleCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendServiceTitleCell.h"

@implementation SendServiceTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setStorlist:(SendServiceStoreinfomap *)storlist
{
    _storlist = storlist;
    
    self.lb_title.text = storlist.createTime;

 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
