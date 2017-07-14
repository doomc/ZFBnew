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
    
    
    self.img_collctView.clipsToBounds = YES;
    self.img_collctView.layer.borderWidth = 0.5;
    self.img_collctView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}
-(void)setGoodslist:(Cmkeepgoodslist *)goodslist
{
    _goodslist = goodslist;
    
    self.lb_price.text = [NSString stringWithFormat:@"¥%ld", _goodslist.storePrice];
    self.lb_title.text = [NSString stringWithFormat:@"%@", _goodslist.goodName];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_goodslist.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];

}

-(void)setScanfool:(Cmscanfoolprintslist *)scanfool
{
    _scanfool = scanfool;
    self.lb_title.text = _scanfool.goodName;
    self.lb_price.text =[NSString stringWithFormat:@"¥%ld",_scanfool.storePrice];
    [self.img_collctView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_scanfool.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
