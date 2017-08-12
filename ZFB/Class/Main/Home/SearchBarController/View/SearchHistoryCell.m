//
//  SearchHistoryCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/8/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchHistoryCell.h"

@implementation SearchHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

///删除历史记录
- (IBAction)deleteAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(deleteSingleDataRow:)]) {
        [self.delegate deleteSingleDataRow:_row];
    }
}
@end
