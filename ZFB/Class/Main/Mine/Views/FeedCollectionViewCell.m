//
//  FeedCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "FeedCollectionViewCell.h"

@implementation FeedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.feedImgeView.clipsToBounds = YES;
    self.feedImgeView.layer.borderColor =HEXCOLOR(0xfecccc).CGColor;
    self.feedImgeView.layer.borderWidth = 0.5;
}

@end
