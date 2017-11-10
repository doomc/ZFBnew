//
//  ZFFooterCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFFooterCell.h"
@interface ZFFooterCell ()
{
    NSString * orderIdNormal ;
    NSString * deliveryIdNormal ;
    NSString * orderNumNormal ;
    NSString * orderAllPrice ;
    NSString * orderDetail ;
    NSString * orderStoreName ;
    
}
@end
@implementation ZFFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cancel_button.layer.cornerRadius = 4;
    _cancel_button.clipsToBounds      = YES;
    
    _payfor_button.layer.cornerRadius = 4;
    _payfor_button.clipsToBounds      = YES;
    
    [self.cancel_button addTarget:self action:@selector(cancel_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.payfor_button addTarget:self action:@selector(payfor_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _lb_hjkey.hidden = YES;
}
//设置待确认退回
-(void)setProgressModel:(List *)progressModel
{
    _progressModel = progressModel;
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%@",progressModel.refund];//退回的价格

}
//全部订单
-(void)setOrderlist:(Orderlist *)orderlist
{
    _orderlist = orderlist;
    
    //订单金额
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%@",orderlist.orderAmount];//订单价格
    orderNumNormal          = orderlist.orderCode;
    orderIdNormal           = orderlist.order_id;
    deliveryIdNormal        = orderlist.deliveryId;
    orderDetail             = orderlist.orderDetail;
    orderStoreName          = orderlist.storeName;
    _lb_hjkey.text = orderlist.partRefund;
}

///服务端订单goodlist
-(void)setBusinessOrder:(BusinessOrderlist *)businessOrder
{
    _businessOrder = businessOrder;
    //订单金额
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%@",businessOrder.orderAmount];//订单价格
    _payStatus              = businessOrder.payStatus;
    _orderStatus            = businessOrder.orderStatus;
    _orderNum               = businessOrder.orderCode;
    _deliveryId             = businessOrder.deliveryId;
    
    //通过传值把这个id传出去
    _orderId    = businessOrder.order_id;
    _totalPrice = businessOrder.orderAmount;//总价
}

//配送端订单
-(void)setSendOrder:(SendServiceStoreinfomap *)sendOrder
{
    _sendOrder              = sendOrder;
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%.2f",sendOrder.orderAmmount];//订单价格
    
}
///取消 所有指令
-(void)cancel_buttonAction
{
    NSLog(@"innerSection-============%ld", _section);
    if ([self.footDelegate respondsToSelector:@selector(cancelOrderActionbyOrderNum:orderStatus:payStatus:deliveryId:indexPath:)]) {
        
        [self.footDelegate  cancelOrderActionbyOrderNum:_orderNum orderStatus:_orderStatus payStatus:_payStatus deliveryId:_deliveryId indexPath:_section];
    }
    
}

///派单 、、、确认支付 等所有指令
-(void)payfor_buttonAction
{
    NSLog(@"parInnerSection-============%ld", _section);
    if ([self.footDelegate respondsToSelector:@selector(sendOrdersActionOrderId:totalPrice:indexPath:)]) {
        [self.footDelegate sendOrdersActionOrderId:_orderId totalPrice:_totalPrice indexPath:_section];
    }
    
    if ([self.footDelegate respondsToSelector:@selector(allOrdersActionOfindexPath:)]) {
        [self.footDelegate allOrdersActionOfindexPath:_section];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
