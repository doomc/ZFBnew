//
//  LogisticsProgressCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "LogisticsProgressCell.h"

@implementation LogisticsProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lb_infoMessage.preferredMaxLayoutWidth = KScreenW -160;//（左右最大间距）
}

-(void)setList:(LogisticsList *)list
{
    _list = list;
    self.lb_infoMessage.text = list.text;
    self.lb_date.text = list.time;

}
-(void)setChecklist:(CheckList *)checklist
{
    _checklist = checklist;
    self.lb_infoMessage.text = checklist.message;
    self.lb_date.text = checklist.time;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
