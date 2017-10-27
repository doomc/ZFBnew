//
//  DetailMsgCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailMsgCell.h"

@implementation DetailMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setDateList:(DateList *)dateList
{
    _dateList = dateList ;
    self.lb_title.text = dateList.title;
    self.lb_content.text = [NSString stringWithFormat:@"%@",dateList.content];
    self.lb_time.text = dateList.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
