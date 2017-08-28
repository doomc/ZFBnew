//
//  IMSearchResultCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "IMSearchResultCell.h"

@implementation IMSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//添加好友
- (IBAction)addFriendsAction:(id)sender {
    
    NSLog(@" cell current ===== %ld ",_rowIndex);
    
    if ([self.delegate respondsToSelector:@selector(addFridendWithIndexPathRow:)]) {
        [self.delegate addFridendWithIndexPathRow:_rowIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
