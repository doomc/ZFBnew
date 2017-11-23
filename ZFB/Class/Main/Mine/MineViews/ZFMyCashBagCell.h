//
//  ZFMyCashBagCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZFMyCashBagCellDelegate <NSObject>

///钱包
-(void)didClickCashBag;
///余额
-(void)didClickBalanceView;
///提成金额
-(void)didClickUnitView;
///优惠券
-(void)didClickDiscountCouponView;
///富豆
-(void)didClickFuBeanView;


@end
@interface ZFMyCashBagCell : UITableViewCell

@property (nonatomic ,assign) id <ZFMyCashBagCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *myCaseBag;

///余额
@property (weak, nonatomic) IBOutlet UILabel *lb_balance;
@property (weak, nonatomic) IBOutlet UIView *balanceView;

///不可用余额
@property (weak, nonatomic) IBOutlet UILabel *lb_unit;
@property (weak, nonatomic) IBOutlet UIView *unitView;

///优惠券
@property (weak, nonatomic) IBOutlet UILabel *lb_discountCoupon;
@property (weak, nonatomic) IBOutlet UIView * discountCouponView;

///银行卡
@property (weak, nonatomic) IBOutlet UILabel *lb_fuBean;
@property (weak, nonatomic) IBOutlet UIView * fuBeanView;


@end
