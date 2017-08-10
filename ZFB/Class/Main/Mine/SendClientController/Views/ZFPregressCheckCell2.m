//
//  ZFPregressCheckCell2.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFPregressCheckCell2.h"

@implementation ZFPregressCheckCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setList:(CheckList *)list
{
    _list = list;
    self.lb_serviceNum.text = list.message;
    self.lb_applyTime.text = [NSString stringWithFormat:@"申请时间:%@",list.time];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
