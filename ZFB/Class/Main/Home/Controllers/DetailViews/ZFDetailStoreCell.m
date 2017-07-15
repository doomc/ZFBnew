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
    
    self.Store_Bgview.clipsToBounds = YES;
    self.Store_Bgview.layer.cornerRadius = 2;
    self.Store_Bgview.layer.borderWidth = 0.5;
    self.Store_Bgview.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
    
}
 
-(void)setDetailGoodlist:(DetailCmgoodslist *)detailGoodlist
{
    _detailGoodlist = detailGoodlist;
    
    self.lb_Storetitle.text = _detailGoodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"价格:¥%@",_detailGoodlist.storePrice];
    [self.img_storeImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",_detailGoodlist.coverImgUrl]] placeholderImage:nil];
    
    
}
@end
