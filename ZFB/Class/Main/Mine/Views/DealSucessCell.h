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

 @param indexForRow 当前下标
 @param orderId 订单id
 */
-(void)shareOrderWithIndex:(NSInteger)indexForRow AndOrderId:(NSString *)orderId;


@end
@interface DealSucessCell : UITableViewCell

@property (nonatomic , assign) id <DealSucessCellDelegate> delegate;
@property (nonatomic , assign) NSInteger indexRow;

@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsCount;

/**
 晒单
 */
@property (weak, nonatomic) IBOutlet UIButton *btn_shareOrder;

@property (strong , nonatomic) Ordergoods * orderGoods;

@end
