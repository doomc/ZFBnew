//
//  ZFCollectEditCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFCollectEditCell.h"

@implementation ZFCollectEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_editView.clipsToBounds = YES;
    self.img_editView.layer.borderWidth = 0.5;
    self.img_editView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
}

-(void)setGoodlist:(Cmkeepgoodslist *)goodlist
{
    _goodlist = goodlist;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@", _goodlist.storePrice];
    self.lb_title.text = [NSString stringWithFormat:@"%@", _goodlist.goodsName];
    [self.img_editView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_goodlist.coverImgUrl]] placeholderImage:[UIImage imageNamed:@""]];
    self.selecet_btn.selected = _goodlist.isCollectSelected;
}

// 商品选择的按钮回调
- (IBAction)clickSelected:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsSelected:isSelected:)])
    {
        [self.delegate goodsSelected :self isSelected:sender.selected];
        
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
