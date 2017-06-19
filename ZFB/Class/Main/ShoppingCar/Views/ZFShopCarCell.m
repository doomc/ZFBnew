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

    
    //设置边框颜色
//    self.ppNumberView.clipsToBounds = YES;
//    self.ppNumberView.borderColor = [UIColor grayColor];
//    // 初始化时隐藏减按钮
    self.ppNumberView.shakeAnimation = YES;
    self.ppNumberView.delegate = self;
//    // 设置最小值
//    self.ppNumberView.minValue = 2;
//    // 设置最大值
//    self.ppNumberView.maxValue = 10;
    self.ppNumberView.increaseImage = [UIImage imageNamed:@"add"];
    self.ppNumberView.decreaseImage = [UIImage imageNamed:@"reduce"];

 }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentView endEditing:YES];
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
