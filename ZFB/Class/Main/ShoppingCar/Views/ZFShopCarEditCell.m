//
//  ZFShopCarEditCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFShopCarEditCell.h"
@interface ZFShopCarEditCell  ()
{
    NSString *Selected;
}
@end
@implementation ZFShopCarEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.ppNumberView =  [[PPNumberButton alloc]init];
    
    //    self.ppNumberView.clipsToBounds = YES;
    //    self.ppNumberView.borderColor = [UIColor grayColor];
    //    // 初始化时隐藏减按钮
    self.ppNumberView.shakeAnimation = YES;
    self.ppNumberView.delegate = self;
    
    self.ppNumberView.increaseImage = [UIImage imageNamed:@"add"];
    self.ppNumberView.decreaseImage = [UIImage imageNamed:@"reduce"];
    _ppNumberView.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        __weak typeof(self)weakself = self;
        [weakself.shopEditDelegate ChangeGoodsNumberShopCarEditCell:self Number:num];
    };
    
}
/**
 *  选中该商品
 */
-(void)Selected
{
    if ([Selected isEqualToString:@"0"]) {
        [self.shopEditDelegate SelectedConfirmCell:self];
        
    }else{
        [self.shopEditDelegate SelectedCancelCell:self];
    }
    
}
/**
 *  删除该商品
 */
-(void)DeleteGoods
{
    [self.shopEditDelegate DeleteTheGoodsCell:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
