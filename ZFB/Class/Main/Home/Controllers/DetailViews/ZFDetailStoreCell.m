//
//  ZFDetailStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFDetailStoreCell.h"

@implementation ZFDetailStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
 
}
 
-(void)setDetailGoodlist:(DetailCmgoodslist *)detailGoodlist
{
    _detailGoodlist = detailGoodlist;
    
    self.lb_Storetitle.text = _detailGoodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",_detailGoodlist.netPurchasePrice];
    NSURL * url  =[ NSURL URLWithString:detailGoodlist.coverImgUrl];
    [self.img_storeImageView sd_setImageWithURL: url placeholderImage:nil];

}
@end
