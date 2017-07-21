

//
//  ZFSaleAfterContentCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSaleAfterContentCell.h"

@implementation ZFSaleAfterContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.saleAfter_btn addTarget:self action:@selector(saleAfter_btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

///申请售后
-(void)saleAfter_btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(salesAfterDetailPage)]) {
        [self.delegate salesAfterDetailPage];
    }
}
//set
-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_goodcount.text = [NSString stringWithFormat:@"数量x%@%@",_goods.goodsCount, _goods.goodsUnit];
    self.lb_title.text =  _goods.goods_name;
    
    [self.img_saleAfter sd_setImageWithURL:[NSURL URLWithString:_goods.coverImgUrl] placeholderImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
