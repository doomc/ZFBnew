//
//  CouponCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

/** 优惠最大价格  */
@property (weak, nonatomic) IBOutlet UILabel *lb_ticketMaxPrice;

/** 减满价格  */
@property (weak, nonatomic) IBOutlet UILabel *lb_conditionOfprice;

/** 优惠券类型  */
@property (weak, nonatomic) IBOutlet UILabel *lb_CouponType;

/** 优惠券背景类型  */
@property (weak, nonatomic) IBOutlet UIImageView *img_couponType;

/** 活动时间  */
@property (weak, nonatomic) IBOutlet UILabel *lb_activeTime;

/** 点击领取  */
@property (weak, nonatomic) IBOutlet UIButton *didClickget_btn;

/** 判断 是否使用  */
@property (weak, nonatomic) IBOutlet UIImageView *img_isUsed;

/** 判断 优惠券状态 是否过期  */
@property (weak, nonatomic) IBOutlet UIImageView *img_CouponStutus;


@end
