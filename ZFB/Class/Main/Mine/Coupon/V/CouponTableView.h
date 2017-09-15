//
//  CouponTableView.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponTableViewDelegate <NSObject>
@required
/**
 *  关闭弹框
 */
-(void)didClickCloseCouponView;


//获取当前的优惠券
-(void)selectCouponWithIndex:(NSInteger)indexRow withResult:(NSString *)result;

@end
@interface CouponTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (assign , nonatomic) id <CouponTableViewDelegate> popDelegate;

@property (strong , nonatomic) NSMutableArray * couponesList;

/**
 选择的优惠券抛到控制器中
 */
@property (copy   , nonatomic) NSString * couponeMessage;


@end
