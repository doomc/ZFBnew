//
//  SkuHeaderReusableView.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "SkuHeaderReusableView.h"

@implementation SkuHeaderReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _lb_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _lb_title.font = [UIFont systemFontOfSize:14];
        _lb_title.textColor = HEXCOLOR(0x363636);
        [self addSubview:_lb_title];
    }
    return  self;
}


@end
