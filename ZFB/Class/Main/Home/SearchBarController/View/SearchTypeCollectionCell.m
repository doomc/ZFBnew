//
//  SearchTypeCollectionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/7/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SearchTypeCollectionCell.h"

@implementation SearchTypeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgview.clipsToBounds  = YES;
    self.bgview.layer.cornerRadius = 4;
}

@end
