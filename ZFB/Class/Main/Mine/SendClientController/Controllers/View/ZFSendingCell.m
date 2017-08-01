//
//  ZFSendingCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendingCell.h"

@implementation ZFSendingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_SenlistView.clipsToBounds = YES;
    self.img_SenlistView.layer.borderWidth = 0.5;
    self.img_SenlistView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;

 
}
//商户端数据
-(void)setBusinesGoods:(BusinessOrdergoods *)businesGoods
{
    _businesGoods = businesGoods;
    self.lb_num.text = [NSString stringWithFormat:@"x %@ %@",businesGoods.goodsCount, businesGoods.goodsUnit];
    self.lb_sendListTitle.text =  businesGoods.goods_name;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", businesGoods.original_price];
    self.lb_detailTime.text = @"";
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:businesGoods.coverImgUrl] placeholderImage:nil];
    
}
//全部订单
-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %@ %@",goods.goodsCount, goods.goodsUnit];
    self.lb_sendListTitle.text =  _goods.goods_name;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", goods.original_price];
    self.lb_detailTime.text = @"";
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:nil];
}
//配送端数据
-(void)setSendGoods:(SendServiceOrdergoodslist *)sendGoods
{
    _sendGoods = sendGoods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld %@",sendGoods.goodsCount, sendGoods.goodsUnit];
    self.lb_sendListTitle.text =  sendGoods.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%ld", sendGoods.originalPrice];
    self.lb_detailTime.text = @"";
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:sendGoods.coverImgUrl] placeholderImage:nil];
    
}
-(void)setList:(Orderlist *)list
{
    _list = list;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
