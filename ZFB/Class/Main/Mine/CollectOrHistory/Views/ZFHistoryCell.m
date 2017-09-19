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

    self.img_collctView.clipsToBounds = YES;
    self.img_collctView.layer.borderWidth = 0.5;
    self.img_collctView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}
//商品列表
-(void)setGoodslist:(Cmkeepgoodslist *)goodslist
{
    _goodslist = goodslist;
    
    self.lb_price.text = [NSString stringWithFormat:@"¥%.2f", goodslist.storePrice];
    self.lb_title.text = [NSString stringWithFormat:@"%@", goodslist.goodName];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];

}
//门店列表
-(void)setStoreslist:(Cmkeepgoodslist *)storeslist
{
    _storeslist = storeslist;
    self.lb_title.text = [NSString stringWithFormat:@"%@", storeslist.goodName];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:storeslist.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    //starLevel  星星等级
    //初始化五星好评控件
    self.starView.needIntValue = NO;//是否整数显示，默认整数显示
    self.starView.canTouch     = NO;//是否可以点击，默认为NO
    CGFloat number           = [storeslist.starLevel floatValue];
    self.starView.scoreNum     = [NSNumber numberWithFloat:number ];//星星显示个数
    self.starView.normalColorChain(RGBA(244, 244, 244, 1));
    self.starView.highlightColorChian(HEXCOLOR(0xfe6d6a));
    
}
//足记列表
-(void)setScanfool:(Cmscanfoolprintslist *)scanfool
{
    _scanfool = scanfool;
    self.lb_title.text = _scanfool.goodName;
    self.lb_price.text =[NSString stringWithFormat:@"¥%.2f",_scanfool.storePrice];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:_scanfool.coverImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
