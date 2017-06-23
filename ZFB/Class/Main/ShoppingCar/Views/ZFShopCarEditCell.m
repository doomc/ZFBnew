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
    NSInteger  num;
    NSString * Selected;
}
@end
@implementation ZFShopCarEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
 
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

- (IBAction)selectedGoodsAction:(UIButton *)sender {
    sender.selected = !sender.selected ;
    if (sender.selected) {
        
        [sender setImage:[UIImage imageNamed:@"select_selected"] forState:UIControlStateSelected];
    }else{
        
        [sender setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
    }
}

/**
 *  删除该商品
 */
- (IBAction)deleteCellAndModel:(id)sender {
    
    [self.shopEditDelegate DeleteTheGoodsCell:self];

}

//添加
- (IBAction)addAction:(id)sender {
    
    if (num >= 10 ) {
        NSLog(@"超出范围");
    }else{
        num = num +1;
    }
    _tf_result.text = [NSString stringWithFormat:@"%ld",(long)num];
    [self.shopEditDelegate ChangeGoodsNumberShopCarEditCell:self Number:num];
    
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
    
    [self.shopEditDelegate ChangeGoodsNumberShopCarEditCell:self Number:num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
