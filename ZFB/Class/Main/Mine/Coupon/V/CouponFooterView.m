//
//  CouponFooterView.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponFooterView.h"

@implementation CouponFooterView

-(instancetype)initWithCouponFooterViewFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}
/**
 全选
 
 @param sender sender

 */
- (IBAction)didClickChooseAction:(id)sender {
    NSLog(@"点击全选");
    if ([self.delegate respondsToSelector:@selector(didClickSelectAll:)]) {
        [self.delegate didClickSelectAll:sender];
    }
}


/**
 点击取消

 @param sender cancel
 */
- (IBAction)didClickCancleAction:(id)sender {
    //点击取消选择
    NSLog(@"点击取消选择----隐藏按钮");
 
    if ([self.delegate respondsToSelector:@selector(didClickCancle)]) {
        [self.delegate didClickCancle];
    }
}


/**
 批量删除

 @param sender   deleteAll
 */
- (IBAction)didClickAll:(id)sender {
    //删除
    NSLog(@"点击删除");

    if ([self.delegate respondsToSelector:@selector(didClickDeleteSelectCouponCell)]) {
        [self.delegate didClickDeleteSelectCouponCell];
    }
}

@end
