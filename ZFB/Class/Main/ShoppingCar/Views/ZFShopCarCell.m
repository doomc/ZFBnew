//
//  ZFShopCarCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopCarCell.h"
@interface ZFShopCarCell ()
{
    NSInteger num;
}
@end
@implementation ZFShopCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_shopCar.clipsToBounds = YES;
    self.img_shopCar.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.img_shopCar.layer.borderWidth = 0.5;
    
    self.tf_result.userInteractionEnabled = NO;
    
 }

-(void)setGoodlist:(ShopGoodslist *)goodlist
{
    _goodlist = goodlist;
    //拿到商品的数量在加减
}

 

#pragma mark  - 编辑视图 和公共事件
//点击删除商品
- (IBAction)deleteGoodsAction:(id)sender {
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(deleteRabishClick:)]) {
        [self.selectDelegate deleteRabishClick:self];
    }
}

// 商品选择的按钮回调
- (IBAction)clickSelected:(UIButton *)sender {
  
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(goodsSelected:isSelected:)])
    {
        [self.selectDelegate goodsSelected :self isSelected:!sender.selected];

    }

}


//加减运算
- (IBAction)addOrReduce:(UIButton *)sender
{
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(addOrReduceCount:tag:)]) {
        [self.selectDelegate addOrReduceCount:self tag:sender.tag];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
