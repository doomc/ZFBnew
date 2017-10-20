//
//  AboutUsView.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AboutUsView.h"

@implementation AboutUsView

-(instancetype)initWithAboutFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
        }
    return self;
}


@end
