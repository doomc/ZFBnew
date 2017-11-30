//
//  SendStatisticsTitleCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SendStatisticsTitleView.h"

@implementation SendStatisticsTitleView

-(instancetype)initWithHeadViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"SendStatisticsTitleView" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

@end
