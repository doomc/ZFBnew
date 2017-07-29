//
//  ZFFooterCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFFooterCell.h"

@implementation ZFFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cancel_button.layer.cornerRadius = 4;
    _cancel_button.clipsToBounds = YES;
    
    _payfor_button.layer.cornerRadius = 4;
    _payfor_button.clipsToBounds = YES;
    
    //默认值
    [_cancel_button setTitle:@"取消订单" forState:UIControlStateNormal];
    [_payfor_button setTitle:@"派单" forState:UIControlStateNormal];
    
    [self.cancel_button addTarget:self action:@selector(cancel_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.payfor_button addTarget:self action:@selector(payfor_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setOrderlist:(Orderlist *)orderlist
{
    _orderlist = orderlist;
    //0.未支付的初始状态 1.支付成功 -2.支付失败 3.付款发起 4.付款取消 (待付款) 5.退款成功（支付成功的）6.退款发起(支付成功) 7.退款失败(支付成功)',
    NSString * payStr ;
    if ([_orderlist.payStatus  isEqualToString:@"0"] ) {
        payStr = @"未支付";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"1"]) {
        payStr = @"支付成功";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"2"]) {
        payStr = @"支付失败";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"3"]) {
        payStr = @"待付款";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"4"]) {
        payStr = @"取消支付";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"5"]) {
        payStr = @"退款成功";
    }
    else if ([_orderlist.payStatus  isEqualToString:@"6"]) {
        payStr = @"已退款";
    }else{
        payStr = @"退款失败";

    }
    [self.cancel_button setHidden:YES];
    //去付款
    [self.payfor_button setTitle:payStr forState:UIControlStateNormal];
    
    
    //订单金额
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%@",_orderlist.orderAmount];//订单价格
    
}

///订单goodlist
-(void)setBusinessOrder:(BusinessOrderlist *)businessOrder
{
    _businessOrder = businessOrder;
    //订单金额
    self.lb_totalPrice.text = [NSString stringWithFormat:@"￥%@",businessOrder.orderAmount];//订单价格
}

///取消 所有指令
-(void)cancel_buttonAction
{
    if ([self.footDelegate respondsToSelector:@selector(cancelOrderAction)]) {
       
        [self.footDelegate cancelOrderAction];
    }
}

///派单 、、、确认支付 等所有指令
-(void)payfor_buttonAction
{
    if ([self.footDelegate respondsToSelector:@selector(sendOrdersAction)]) {
   
        [self.footDelegate sendOrdersAction];
 
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
