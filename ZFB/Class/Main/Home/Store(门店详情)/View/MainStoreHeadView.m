//
//  MainStoreHeadView.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/21.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MainStoreHeadView.h"

@implementation MainStoreHeadView

-(instancetype)initWithHeaderViewFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MainStoreHeadView" owner:self options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}


@end
