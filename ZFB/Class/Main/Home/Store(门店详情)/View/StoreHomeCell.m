//
//  StoreHomeCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "StoreHomeCell.h"

@implementation StoreHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

-(void)setGoodslist:(GoodsExtendList *)goodslist
{
    _goodslist = goodslist;
    _lb_title.text = goodslist.goodsName;
    _lb_salePrice.text =  [NSString stringWithFormat:@"¥%@",goodslist.netPurchasePrice];
   
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:goodslist.storePrice attributes:attribtDic];
    _lb_storePrice.attributedText = attribtStr;
    
    [_img  sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage:nil];
    _currentGoodId = [NSString stringWithFormat:@"%ld",goodslist.goodsId];
}
//立即购买
- (IBAction)buyAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickwitchOneBuyIndexPath:AndGoodId:)]) {
        [self.delegate didClickwitchOneBuyIndexPath:_indexPath AndGoodId:_currentGoodId];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
