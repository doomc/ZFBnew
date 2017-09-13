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



@end
@interface CouponTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (assign , nonatomic) id <CouponTableViewDelegate> popDelegate;


@end
