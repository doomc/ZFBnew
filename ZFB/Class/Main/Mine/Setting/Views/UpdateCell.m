//
//  UpdateCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/12/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "UpdateCell.h"

@implementation UpdateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDataList:(UpdateData *)dataList
{
    _dataList = dataList;
    self.lb_date.text = dataList.createTime;
    self.lb_title.text = [NSString stringWithFormat:@"展富宝 V%@",dataList.versionCode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
