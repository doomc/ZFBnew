//
//  CouponUsedCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@class CouponUsedCell;
@protocol CouponUsedCellDelegate <NSObject>

-(void)didUnsedCouponCell:(CouponUsedCell *)cell;

@end
@interface CouponUsedCell : UITableViewCell

@property (assign ,nonatomic) id < CouponUsedCellDelegate> unUsedDelegate;

@property (weak, nonatomic) IBOutlet UIButton *select_btn;

/** 优惠最大价格  */
@property (weak, nonatomic) IBOutlet UILabel *lb_ticketMaxPrice;
/** 减满价格  */
@property (weak, nonatomic) IBOutlet UILabel *lb_conditionOfprice;
/** 优惠券名字  */
@property (weak, nonatomic) IBOutlet UILabel *lb_CouponType;
/** 优惠券背景类型  */
@property (weak, nonatomic) IBOutlet UIImageView *img_couponType;
/** 活动时间  */
@property (weak, nonatomic) IBOutlet UILabel *lb_activeTime;

/**
 已使用优惠券，左间距ContentView
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstrainWidth;
/** 判断 是否使用  */
@property (weak, nonatomic) IBOutlet UIImageView *img_isUsed;
/** 判断 优惠券状态 是否过期  */
@property (weak, nonatomic) IBOutlet UIImageView *img_CouponStutus;

@property (strong , nonatomic) Couponlist * couponlist;
@property (strong , nonatomic) NSString   * couponId;// 	优惠券唯一编号

@end
