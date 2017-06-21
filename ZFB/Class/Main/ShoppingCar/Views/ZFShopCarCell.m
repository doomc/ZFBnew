//
//  ZFShopCarCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopCarCell.h"
@interface ZFShopCarCell ()<PPNumberButtonDelegate>
{
    NSInteger _num;
}
@end
@implementation ZFShopCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_shopCar.clipsToBounds = YES;
    self.img_shopCar.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    self.img_shopCar.layer.borderWidth = 0.5;
    
    //select_selected.png
//    self.chooseBtn.selected = !self.chooseBtn.selected;
    [self.chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    
  
}



-(void)chooseBtnAction:(UIButton * )sender
{
    sender.selected = !sender.selected ;
    
    if (sender.selected) {
      
        [self.chooseBtn setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
    }
    else{
       
        [self.chooseBtn setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    }
    
}
-(void)setShopModel:(ShoppingCarModel *)shopModel
{
    _shopModel = shopModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
