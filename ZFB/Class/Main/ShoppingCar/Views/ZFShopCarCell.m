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
    
 
}

-(void)setShopCarModel:(ShoppingCarModel *)shopCarModel
{
    
 
    
//    self.shopcarList = shopcarList;
//    self.lb_title.text = shopcarList.goodsName;
//    self.lb_price.text = shopcarList.storePrice;
//    //    shopCell.lb_result.text = shopList.goodsCount;
//    [self.img_shopCar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shopcarList.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
}




// 增加商品或者减少商品
- (IBAction)addAction:(id)sender {
    
    if (num >= 10 ) {
        NSLog(@"超出范围");
    }else{
        num = num +1;
    }
    _tf_result.text = [NSString stringWithFormat:@"%ld",(long)num];
    [self.selectDelegate ChangeGoodsNumberCell:self Number:num];
    
}
/**
 减少
 @param sender reduceAction
 */
- (IBAction)reduceAction:(id)sender {
    
    if ((num - 1) <= 0 || num == 0) {
        NSLog(@"超出范围");
        
    }else{
        
        num  = num -1;
    }
    _tf_result.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    [self.selectDelegate ChangeGoodsNumberCell:self Number:num];
    
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
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(productSelected:isSelected:)])
    {
        [self.selectDelegate productSelected:self isSelected:!sender.selected];
    }
}


#pragma mark  - 头部视图事件
// 点击section头部选择按钮回调
- (IBAction)chooseSectionSelected:(id)sender {
    
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(shopStoreSelected:)]) {
        
        [self.selectDelegate shopStoreSelected:self.sectionIndex];
    }
}
// 进入店铺
- (IBAction)enterStoreAction:(id)sender {
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(enterStoreDetailwithStoreId:)]) {
        
        [self.selectDelegate shopStoreSelected:self.sectionIndex];
    }
}

// 头部编辑按钮回调
- (IBAction)clickEditing:(id)sender {
    if (self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(shopCarEditingSelected:)]) {
        [self.selectDelegate shopCarEditingSelected:self.sectionIndex];
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
