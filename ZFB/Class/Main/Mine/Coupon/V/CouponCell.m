//
//  CouponCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponCell.h"
@interface CouponCell ()

//点击领取优惠券
- (IBAction)didclickGetCouponAction:(UIButton *)sender;
//点击选择
- (IBAction)didClickChoosSingleCoupon:(id)sender;

@end
@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)setCouponlist:(Couponlist *)couponlist
{
    _couponlist = couponlist;
 
    //每张优惠券的金额
    _lb_ticketMaxPrice.text  = [NSString stringWithFormat:@"%@",couponlist.eachOneAmount];
    _lb_conditionOfprice.text  = [NSString stringWithFormat:@"满%@元可用",couponlist.amountLimit];
    _couponId = [NSString stringWithFormat:@"%ld",couponlist.couponId];
    
    //活动时间
    NSString * startTime = couponlist.effectStartTime;
    NSString * endTime = couponlist.effectEndTime;
    startTime = [startTime substringToIndex:10];//截取到10之前的
    endTime = [endTime substringToIndex:10];
    NSString * mutTiem = [NSString stringWithFormat:@"活动时间:%@~%@",startTime,endTime] ;
    _lb_activeTime.text  =  mutTiem;
    
    self.select_btn.selected = couponlist.isChoosedCoupon;

    //serviceType- 优惠券服务类型  1.满减券 2.运费券
    if (couponlist.serviceType == 1) {
    }else{
    }
    
    //使用范围 1 全场通用 2 店铺券 3店铺商品券
    if (couponlist.status == 0) {    //没领取优惠券
        
        _didClickget_btn.hidden = NO;
        _img_isUsed.hidden = YES;
        _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
        //券名
        _lb_CouponType.text = [NSString stringWithFormat:@"¥%@",couponlist.eachOneAmount];
        _lb_CouponType.font = SYSTEMFONT(20);
        
    }else if (couponlist.status == 1)
    {
        _img_isUsed.hidden = YES;
        _didClickget_btn.hidden = YES;
        _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
        
        //券名
        _lb_CouponType.text = couponlist.couponName;
        _lb_CouponType.font = SYSTEMFONT(15);
        
    }else if (couponlist.status == 2)
    {
        _img_isUsed.hidden = NO;
        _img_isUsed.image = [UIImage imageNamed:@"used"];
        _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
        _didClickget_btn.hidden = YES;
        
        //券名
        _lb_CouponType.text = couponlist.couponName;
        _lb_CouponType.font = SYSTEMFONT(15);
        
    }else{
        _img_isUsed.hidden = NO;
        _img_isUsed.image = [UIImage imageNamed:@"expired"];
        _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
        _didClickget_btn.hidden = YES;
        
        //券名
        _lb_CouponType.text = couponlist.couponName;
        _lb_CouponType.font = SYSTEMFONT(15);
        _lb_CouponType.textColor = HEXCOLOR(0x333333);
        
    }
//    if (couponlist.useRange == 1) {
//        //status = 0 未领取 1 未使用 2 已使用 3 已失效
//        if (couponlist.status == 0) {
//
//            _didClickget_btn.hidden = NO;
//            _img_isUsed.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//
//
//        }else if (couponlist.status == 1)
//        {
//
//            _img_isUsed.hidden = YES;
//            _didClickget_btn.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//
//
//        }else if (couponlist.status == 2)
//        {
//            _img_isUsed.image = [UIImage imageNamed:@"used"];//已使用
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//            _didClickget_btn.hidden = YES;
//
//        }else{
//
//            _img_isUsed.image = [UIImage imageNamed:@"expired"];//已过期
//            _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
//            _didClickget_btn.hidden = YES;
//
//        }
//
//    }
//    if (couponlist.useRange == 2){
//        //status = 0 未领取 1 未使用 2 已使用 3 已失效
//        if (couponlist.status == 0) {
//
//            _didClickget_btn.hidden = NO;
//            _img_isUsed.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//
//
//        }else if (couponlist.status == 1)
//        {
//            _img_isUsed.hidden = YES;
//            _didClickget_btn.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//
//        }else if (couponlist.status == 2)
//        {
//            _img_isUsed.image = [UIImage imageNamed:@"used"];
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//            _didClickget_btn.hidden = YES;
//
//        }else{
//
//            _img_isUsed.image = [UIImage imageNamed:@"expired"];
//            _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
//            _didClickget_btn.hidden = YES;
//
//        }
//
//    }
//    if (couponlist.useRange == 3){
//        //status = 0 未领取 1 未使用 2 已使用 3 已失效
//        if (couponlist.status == 0) {
//
//            _didClickget_btn.hidden = NO;
//            _img_isUsed.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//
//
//        }else if (couponlist.status == 1)
//        {
//            _didClickget_btn.hidden = YES;
//            _img_couponType.image = [UIImage imageNamed:@"coupon_get"];
//            _img_isUsed.hidden = YES;
//
//
//        }else if (couponlist.status == 2)
//        {
//            _img_isUsed.image = [UIImage imageNamed:@"used"];
//            _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
//            _didClickget_btn.hidden = YES;
//
//
//        }else{
//            _img_isUsed.image = [UIImage imageNamed:@"expired"];
//            _img_couponType.image = [UIImage imageNamed:@"coupon_overdu"];
//            _didClickget_btn.hidden = YES;
//
//        }

 
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


//点击选中
- (IBAction)didClickChoosSingleCoupon:(UIButton *)sender {
    
    [sender setSelected:!sender.isSelected];
    
    if ([self.couponDelegate respondsToSelector:@selector(selectCouponCell:)]) {
    
        [self.couponDelegate selectCouponCell:self ];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
