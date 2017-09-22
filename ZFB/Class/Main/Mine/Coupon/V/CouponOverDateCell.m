//
//  CouponOverDateCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponOverDateCell.h"

@implementation CouponOverDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _buttonWidthConstrainWidth.constant = 0;

}


-(void)setCouponlist:(Couponlist *)couponlist
{
    _couponlist = couponlist;
    
    //券名
    _lb_CouponType.text = couponlist.couponName;
    
    //每张优惠券的金额
    _lb_ticketMaxPrice.text  = [NSString stringWithFormat:@"%ld",couponlist.eachOneAmount];
    _lb_conditionOfprice.text  = [NSString stringWithFormat:@"满%@元可用",couponlist.amountLimit];
    _couponId = [NSString stringWithFormat:@"%ld",couponlist.couponId];
    
    //serviceType- 优惠券服务类型  1.满减券 2.运费券
    if (couponlist.serviceType == 1) {
        
    }else{
        
    }
    
    //couponKind优惠券种类   1.平台优惠券 2店铺优惠券 3单品优惠券
    //背景图  red是平台券，orange是店铺券 ,绿色商品券,灰色是不可用和过期券
    if (couponlist.couponKind == 1) {
        
        //status = 0 未领取 1 未使用 2 已使用 3 已失效
        if (couponlist.status == 0) {
            
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            
        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
        }
        
    }else if (couponlist.couponKind == 2)
    {
        //status = 0 未领取 1 未使用 2 已使用 3 已失效
        if (couponlist.status == 0) {
            
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            
        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
        }
        
    }else{
        
        //status = 0 未领取 1 未使用 2 已使用 3 已失效
        if (couponlist.status == 0) {
            
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            
        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
        }

    }
    
    _img_couponType.image = [UIImage imageNamed:@"couponGray"];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
