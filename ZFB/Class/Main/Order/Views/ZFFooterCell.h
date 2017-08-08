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
#import "SendServiceOrderModel.h"
@protocol ZFFooterCellDelegate <NSObject>

///取消订单   左边按钮
-(void)cancelOrderActionbyOrderNum:(NSString *)orderNum
                       orderStatus:(NSString *)orderStatus
                        payStatus :(NSString *)payStatus
                       deliveryId :(NSString *)deliveryId
                        indexPath :(NSInteger )indexPath;
///派单 ----- 右边
-(void)sendOrdersActionOrderId:(NSString*)orderId totalPrice:(NSString *)totalPrice  indexPath :(NSInteger)indexPath;


@end
@interface ZFFooterCell : UITableViewCell

@property (nonatomic, strong) id <ZFFooterCellDelegate> footDelegate ;

@property (weak, nonatomic) IBOutlet UILabel *lb_plachorer;

@property (weak, nonatomic) IBOutlet UILabel *lb_totalPrice;

@property (weak, nonatomic) IBOutlet UIButton *cancel_button;

@property (weak, nonatomic) IBOutlet UIButton *payfor_button;

@property (nonatomic, strong) Orderlist * orderlist ;

@property (nonatomic, strong) BusinessOrderlist * businessOrder ;

@property (nonatomic, strong) SendServiceStoreinfomap * sendOrder ;



@property (nonatomic, assign) NSInteger   indexPath;//当前的下标

@property (nonatomic, copy) NSString  * orderId ;
@property (nonatomic, copy) NSString  * totalPrice ;//总价

@property (nonatomic, copy) NSString  * deliveryId ;//配送员编号
@property (nonatomic, copy) NSString  * orderNum ;//订单编号
@property (nonatomic, copy) NSString  * orderStatus ;//订单状态
@property (nonatomic, copy) NSString  * payStatus ;//支付状态


@end
