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
