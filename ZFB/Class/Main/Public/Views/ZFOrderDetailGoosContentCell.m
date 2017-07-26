//
//  ZFOrderDetailGoosContentCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFOrderDetailGoosContentCell.h"

@implementation ZFOrderDetailGoosContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img_orderDetailView.clipsToBounds = YES;
    self.img_orderDetailView.layer.borderWidth = 0.5;
    self.img_orderDetailView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
}

-(void)setGoodlist:(DetailGoodslist *)goodlist
{
    _goodlist =  goodlist;
    
    self.lb_title.text = _goodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"%@",_goodlist.storePrice];
    self.lb_count.text = [NSString stringWithFormat:@"x %@",_goodlist.goodsCount];
    [self.img_orderDetailView sd_setImageWithURL:[NSURL URLWithString:_goodlist.coverImgUrl] placeholderImage:nil];
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
