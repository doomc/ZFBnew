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
    
    //select_selected.png
//    self.chooseBtn.selected = !self.chooseBtn.selected;
    [self.chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    
  
}
//全选
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

//添加
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
