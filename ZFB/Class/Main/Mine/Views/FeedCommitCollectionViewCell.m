//
//  FeedCommitCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedCommitCollectionViewCell.h"

@implementation FeedCommitCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.cornerRadius = 2;
    self.bgView.layer.borderColor = HEXCOLOR(0xdedede).CGColor;
    self.bgView.clipsToBounds = YES;

}

@end
