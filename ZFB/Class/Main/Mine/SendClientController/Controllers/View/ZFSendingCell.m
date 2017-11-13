//
//  ZFSendingCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendingCell.h"
@interface ZFSendingCell()


@end
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
    
    if ([self isEmptyArray:businesGoods.goods_properties]) {
        NSLog(@"这是个空数组");
        self.lb_progrop.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (BusinessOrderproperties * pro in businesGoods.goods_properties) {
            NSString * value =  pro.value;
            [mutNameArray addObject:value];
        }
        self.lb_progrop.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }

    
}
//全部订单
-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld",goods.goodsCount];
    self.lb_sendListTitle.text =  _goods.goods_name;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", goods.purchase_price];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:goods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
 
    
    if ([self isEmptyArray:goods.goods_properties]) {
        NSLog(@"这是个空数组");
        self.lb_progrop.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (OrderProper * pro in goods.goods_properties) {
            NSString * name =  pro.value;
            [mutNameArray addObject:name];
  
        }
        self.lb_progrop.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }
   
}
//配送端数据
-(void)setSendGoods:(SendServiceOrdergoodslist *)sendGoods
{
    _sendGoods = sendGoods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld",sendGoods.goodsCount];
    self.lb_sendListTitle.text =  sendGoods.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", sendGoods.purchasePrice];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:sendGoods.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
    if ([self isEmptyArray:sendGoods.goodsProperties]) {
        NSLog(@"这是个空数组");
        self.lb_progrop.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (SendServiceGoodsProperties * pro in sendGoods.goodsProperties) {
            NSString * value =  pro.value;
            [mutNameArray addObject:value];
        }
        self.lb_progrop.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }

    
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

//商家清单
-(void)setGoodlist:(BussnissGoodsInfoList *)goodlist
{
    _goodlist = goodlist;
    self.lb_num.text = [NSString stringWithFormat:@" x %@",goodlist.goodsNum];
    self.lb_sendListTitle.text =  goodlist.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%@", goodlist.storePrice];
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:goodlist.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];

    if ([self isEmptyArray:goodlist.goodsProp]) {
        NSLog(@"这是个空数组");
        self.lb_progrop.text = @"";
    }else{
        NSMutableArray * mutNameArray = [NSMutableArray array];
        for (OrderProper * pro in goodlist.goodsProp) {
            NSString * name =  pro.value;
            [mutNameArray addObject:name];
        }
        self.lb_progrop.text = [NSString stringWithFormat:@"规格:%@",[mutNameArray componentsJoinedByString:@" "]];
    }
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

#pragma mark - 判断是不是空数组
- (BOOL)isEmptyArray:(NSArray *)array
{
    return (array.count == 0 || array == nil || [array isKindOfClass:[NSNull class]]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
