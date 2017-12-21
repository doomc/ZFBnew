//
//  ZFCollectCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFHistoryCell.h"

@implementation ZFHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
//商品列表
-(void)setGoodslist:(Cmkeepgoodslist *)goodslist
{
    _goodslist = goodslist;
    
    self.lb_price.text = [NSString stringWithFormat:@"¥%.2f", goodslist.storePrice];
    self.lb_title.text = [NSString stringWithFormat:@"%@", goodslist.goodName];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];

}
//门店列表
-(void)setStoreslist:(Cmkeepgoodslist *)storeslist
{
    _storeslist = storeslist;
    self.lb_title.text = [NSString stringWithFormat:@"%@", storeslist.goodName];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:storeslist.storeUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
}
//足记列表
-(void)setScanfool:(Cmscanfoolprintslist *)scanfool
{
    _scanfool = scanfool;
    self.lb_title.text = _scanfool.goodName;
    self.lb_price.text =[NSString stringWithFormat:@"¥%.2f",_scanfool.storePrice];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:_scanfool.coverImgUrl] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
