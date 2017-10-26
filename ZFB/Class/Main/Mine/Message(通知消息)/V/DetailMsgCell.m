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
-(void)setPushList:(PushMessageList *)pushList{
    _pushList = pushList ;
    self.lb_title.text = pushList.title;
    self.lb_content.text = [NSString stringWithFormat:@"%@",pushList.content];
    self.lb_time.text = pushList.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
