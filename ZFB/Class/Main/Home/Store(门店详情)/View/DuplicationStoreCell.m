//
//  DuplicationStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DuplicationStoreCell.h"
 @interface DuplicationStoreCell()
 
@end
@implementation DuplicationStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.masksToBounds = YES;
//    self.bgView.layer.cornerRadius = 3;
    
}
- (IBAction)selectedCollection:(UIButton*)sender {
    
 
}
-(void)setGoodslist:(GoodsExtendList *)goodslist
{
    _goodslist = goodslist;
    _lb_price.text = [NSString stringWithFormat:@"¥%@",goodslist.netPurchasePrice];
    _lb_title.text =  goodslist.goodsName;
    _lb_colltionNum.text = [NSString stringWithFormat:@"%@",goodslist.collcetNumber];
    [_contentIMG sd_setImageWithURL:[NSURL URLWithString:goodslist.coverImgUrl] placeholderImage: [UIImage imageNamed:@"300x300"]];
}

-(void)setAnewGoods:(StoreRecommentGoodsList *)anewGoods
{
    _anewGoods = anewGoods;
    _lb_price.text = [NSString stringWithFormat:@"¥%@",anewGoods.netPurchasePrice];
    _lb_title.text =  anewGoods.goodsName;
    _lb_colltionNum.text = [NSString stringWithFormat:@"%@",anewGoods.collcetNumber];
    [_contentIMG sd_setImageWithURL:[NSURL URLWithString:anewGoods.coverImgUrl] placeholderImage: [UIImage imageNamed:@"300x300"]];
}
//搜索无结果，精选列表模型
-(void)setGoodsList:(SearchFindgoodslist *)goodsList
{
    _goodsList= goodsList;
    _lb_price.text = [NSString stringWithFormat:@"¥%@",goodsList.priceTostr];
    _lb_title.text =  goodsList.goodsName;
    [_collect_btn setHidden: YES];
    _lb_colltionNum.text = [NSString stringWithFormat:@"已售%ld件 ",goodsList.goodsSales];
    [_contentIMG sd_setImageWithURL:[NSURL URLWithString:goodsList.coverImgUrl] placeholderImage: [UIImage imageNamed:@"300x300"]];
    
  
}
@end
