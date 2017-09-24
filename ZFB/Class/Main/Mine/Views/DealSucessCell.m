//
//  DealSucessCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  交易完成Cell

#import "DealSucessCell.h"
@interface DealSucessCell ()
{
    NSString * _orderId;
    
}
@end
@implementation DealSucessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btn_shareOrder.layer.cornerRadius = 4;
    self.btn_shareOrder.clipsToBounds      = YES;
    
    self.btn_shareComment.layer.cornerRadius = 4;
    self.btn_shareComment.clipsToBounds      = YES;
}

-(void)setOrderGoods:(Ordergoods *)orderGoods
{
    _orderGoods = orderGoods;
    
    self.lb_price.text = [NSString stringWithFormat:@"￥%@",orderGoods.purchase_price];//商品价格
    self.lb_title.text = orderGoods.goods_name;
    self.lb_goodsCount.text = [NSString stringWithFormat:@"x%ld",orderGoods.goodsCount];
    _orderId = orderGoods.order_id;
    
}
//晒单
- (IBAction)shareOrderAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(shareOrderWithIndexPath:AndOrderId:)]) {

        [self.delegate shareOrderWithIndexPath:_indexPath AndOrderId:_orderId];
    }

}
//共享
- (IBAction)commentShareAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didclickShareToFriendWithIndexPath:AndOrderId:)]) {
        [self.delegate didclickShareToFriendWithIndexPath:_indexPath AndOrderId:_orderId];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
