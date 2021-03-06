//
//  DealSucessCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/9/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"

@protocol DealSucessCellDelegate <NSObject>


/**
 晒单代理

 @param indexPath 当前下标
 @param orderId 订单id
 */
-(void)shareOrderWithIndexPath:(NSIndexPath *)indexPath AndOrderId:(NSString *)orderId;


/**
 共享到自己的朋友圈

 @param indexPath 当前index
 @param orderId 当前id
 */
-(void)didclickShareToFriendWithIndexPath:(NSIndexPath *)indexPath AndOrderId:(NSString *)orderId;


@end
@interface DealSucessCell : UITableViewCell

@property (nonatomic , assign) id <DealSucessCellDelegate> delegate;
@property (nonatomic , assign) NSInteger indexRow;
@property (nonatomic , strong) NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsCount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingLayoutWidth;


/**
 晒单
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_shareOrder;


/**
 共享
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_shareComment;

@property (strong , nonatomic) Ordergoods * orderGoods;

@end
