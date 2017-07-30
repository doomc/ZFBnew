//
//  ZFFooterCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
#import "BusinessOrderModel.h"

@protocol ZFFooterCellDelegate <NSObject>

///取消订单
-(void)cancelOrderAction;

///派单
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice;


@end
@interface ZFFooterCell : UITableViewCell

@property (nonatomic, strong) id <ZFFooterCellDelegate> footDelegate ;

@property (weak, nonatomic) IBOutlet UILabel *lb_plachorer;

@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;

@property (weak, nonatomic) IBOutlet UIButton *cancel_button;

@property (weak, nonatomic) IBOutlet UIButton *payfor_button;

@property (nonatomic, strong) Orderlist * orderlist ;

@property (nonatomic, strong) BusinessOrderlist * businessOrder ;

@property (nonatomic, copy) NSString  * orderId ;

@property (nonatomic, copy) NSString  * totalPrice ;//总价


@end
