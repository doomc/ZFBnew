//
//  ZFMyCashBagCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFMyCashBagCell.h"
@interface ZFMyCashBagCell() <UIGestureRecognizerDelegate>

@end
@implementation ZFMyCashBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // 点击账户余额
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBalanceView:)];
    tap.delegate = self;
    [self.balanceView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUnitView:)];
    tap2.delegate = self;
    [self.unitView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiscountCouponView:)];
    tap3.delegate = self;
    [self.discountCouponView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFuBeanView:)];
    tap4.delegate = self;
    [self.fuBeanView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer * tapCaseBag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCashBag:)];
    tapCaseBag.delegate = self;
    [self.fuBeanView addGestureRecognizer:tapCaseBag];
 
}
// 点击钱包
-(void)tapCashBag:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickCashBag)]) {
        [self.delegate didClickCashBag];
    }
}

// 点击账户余额
-(void)tapBalanceView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickBalanceView)]) {
        [self.delegate didClickBalanceView];
    }
}

// 点击提成金额
-(void)tapUnitView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickUnitView)]) {
        [self.delegate didClickUnitView];
    }
}

// 点击优惠券
-(void)tapDiscountCouponView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickDiscountCouponView)]) {
        [self.delegate didClickDiscountCouponView];
    }
}

// 点击富豆
-(void)tapFuBeanView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickFuBeanView)]) {
    [self.delegate didClickFuBeanView];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
