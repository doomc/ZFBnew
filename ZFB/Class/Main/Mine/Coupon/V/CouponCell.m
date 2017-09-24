//
//  CouponCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponCell.h"
@interface CouponCell ()
 
- (IBAction)didclickGetCouponAction:(UIButton *)sender;

@end
@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //按钮
    _didClickget_btn.layer.cornerRadius = 4;
    _didClickget_btn.layer.masksToBounds = YES;
    _didClickget_btn.layer.borderWidth = 1;
    _didClickget_btn.layer.borderColor = HEXCOLOR(0xfe6d6a).CGColor;
   
#warning  ------------暂时没有做编辑删除 为了隐藏button
    _buttonWidthConstraint.constant = 0.0;
    
}

-(void)setCouponlist:(Couponlist *)couponlist
{
    _couponlist = couponlist;
    
    //券名
    _lb_CouponType.text = couponlist.couponName;
    
    //每张优惠券的金额
    _lb_ticketMaxPrice.text  = [NSString stringWithFormat:@"%.2f",couponlist.eachOneAmount];
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
            
            _img_couponType.image = [UIImage imageNamed:@"couponRed"];
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];

        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponRed"];
            _didClickget_btn.hidden = YES;

        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGray"];
            _didClickget_btn.hidden = YES;

        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGray"];
            _didClickget_btn.hidden = YES;

        }

    }else if (couponlist.couponKind == 2)
    {
        //status = 0 未领取 1 未使用 2 已使用 3 已失效
        if (couponlist.status == 0) {
            
            _img_couponType.image = [UIImage imageNamed:@"couponOrange"];
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
            
        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponOrange"];
            _didClickget_btn.hidden = YES;

        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGray"];
            _didClickget_btn.hidden = YES;

            
        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGray"];
            _didClickget_btn.hidden = YES;

        }

    }else{
        
        //status = 0 未领取 1 未使用 2 已使用 3 已失效
        if (couponlist.status == 0) {
            
            _img_couponType.image = [UIImage imageNamed:@"couponGreen"];
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            
        }else if (couponlist.status == 1)
        {
            [_img_isUsed setHidden:YES];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGreen"];
            _didClickget_btn.hidden = YES;

        }else if (couponlist.status == 2)
        {
            _img_isUsed.image = [UIImage imageNamed:@"used"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGreen"];
            _didClickget_btn.hidden = YES;

            
        }else{
            _img_isUsed.image = [UIImage imageNamed:@"overtime"];
            [_img_CouponStutus setHidden:YES];
            _img_couponType.image = [UIImage imageNamed:@"couponGreen"];
            _didClickget_btn.hidden = YES;

        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/**
 点击领取优惠券

 @param sender  didClickget_btn
 */
- (IBAction)didclickGetCouponAction:(UIButton *)sender {
 
    NSLog(@"CouponCell 的_couponId ==== %@",_couponId);
    if ([self.couponDelegate respondsToSelector:@selector(didClickGetCouponWithIndexRow:AndCouponId:)]) {
        [self.couponDelegate didClickGetCouponWithIndexRow:_indexRow AndCouponId:_couponId];
    }
    
}
@end
