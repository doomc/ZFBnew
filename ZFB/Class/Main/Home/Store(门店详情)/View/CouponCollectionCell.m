//
//  CouponCollectionCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponCollectionCell.h"

@implementation CouponCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setCouponList:(Couponlist *)couponList
{
    _couponList =couponList;

    NSString * RMB = @"¥";
    self.lb_maxMoney.text = [NSString stringWithFormat:@"%@",couponList.eachOneAmount];
    self.lb_useRange.text = [NSString stringWithFormat:@"满%@元可用",couponList.amountLimit];
    
 
}


@end
