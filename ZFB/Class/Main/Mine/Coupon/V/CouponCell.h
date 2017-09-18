//
//  CouponCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@protocol CouponCellDelegate <NSObject>
@optional
/**
 点击领取优惠券

 @param indexRow 当前下标
 */
-(void)didClickGetCouponWithIndexRow :(NSInteger)indexRow AndCouponId:(NSString *)couponId;


@end
@interface CouponCell : UITableViewCell

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

/** 点击领取  */
@property (weak, nonatomic) IBOutlet UIButton *didClickget_btn;

/** 判断 是否使用  */
@property (weak, nonatomic) IBOutlet UIImageView *img_isUsed;

/** 判断 优惠券状态 是否过期  */
@property (weak, nonatomic) IBOutlet UIImageView *img_CouponStutus;

@property (assign , nonatomic) id <CouponCellDelegate> couponDelegate;

//当前下标
@property (assign , nonatomic) NSInteger indexRow;
@property (strong , nonatomic) Couponlist * couponlist;
@property (strong , nonatomic) NSString   * couponId;// 	优惠券唯一编号
@property (strong , nonatomic) NSString   * message;// 	需要传出去当前选中的优惠券

@end
