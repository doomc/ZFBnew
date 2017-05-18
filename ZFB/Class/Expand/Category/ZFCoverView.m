//
//  ZFCoverView.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCoverView.h"

@implementation ZFCoverView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    /*创建灰色背景*/
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    [bgView addGestureRecognizer:tapGesture];
    
    /*创建显示View*/
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width - 40, 180);
    _contentView.backgroundColor=[UIColor whiteColor];
    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
}

#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];
}

-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

// 这里加载在了window上
-(void)showCoverView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
