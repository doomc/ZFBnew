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
    
}


/**
 点击取消

 @param sender cancel
 */
- (IBAction)didClickCancleAction:(id)sender {

}


/**
 批量删除

 @param sender   deleteAll
 */
- (IBAction)didClickAll:(id)sender {
    
}

@end
