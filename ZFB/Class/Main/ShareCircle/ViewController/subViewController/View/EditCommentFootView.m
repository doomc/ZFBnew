//
//  EditCommentFootView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "EditCommentFootView.h"

@implementation EditCommentFootView

-(instancetype)initWithFootViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EditCommentFootView" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

@end
