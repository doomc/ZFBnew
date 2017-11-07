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
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.share_btn.hidden = YES;
    self.share_btn.layer.cornerRadius = 4;
    self.share_btn.layer.masksToBounds = YES;

    self.sunnyOrder_btn.hidden = YES;
    self.sunnyOrder_btn.layer.cornerRadius = 4;
    self.sunnyOrder_btn.layer.masksToBounds = YES;
}
//商户端数据
-(void)setBusinesGoods:(BusinessOrdergoods *)businesGoods
{
    _businesGoods = businesGoods;
    self.lb_num.text = [NSString stringWithFormat:@" x %ld",businesGoods.goodsCount];
    self.lb_sendListTitle.text =  businesGoods.goods_name;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", businesGoods.purchase_price];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:businesGoods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
    
}
//全部订单
-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld",goods.goodsCount];
    self.lb_sendListTitle.text =  _goods.goods_name;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", goods.purchase_price];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
}
//配送端数据
-(void)setSendGoods:(SendServiceOrdergoodslist *)sendGoods
{
    _sendGoods = sendGoods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld",sendGoods.goodsCount];
    self.lb_sendListTitle.text =  sendGoods.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", sendGoods.purchasePrice];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:sendGoods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
}
//申请退回
-(void)setProgressModel:(List *)progressModel
{
    _progressModel = progressModel;

    self.lb_num.text = [NSString stringWithFormat:@" x %ld",progressModel.goodsCount];
    self.lb_sendListTitle.text =  progressModel.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", progressModel.refund];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:progressModel.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
}


#pragma - mark 点击共享
- (IBAction)didShareAction:(id)sender {

    if ([self.delegate respondsToSelector:@selector(didclickShareToFriendWithIndexPath:AndOrderId:)]) {
        [self.delegate didclickShareToFriendWithIndexPath:_indexpath AndOrderId:@""];
    }
}
#pragma - mark 点击晒单
- (IBAction)didSunnyAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(shareOrderWithIndexPath:AndOrderId:)]) {
        [self.delegate shareOrderWithIndexPath:_indexpath AndOrderId:@""];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
