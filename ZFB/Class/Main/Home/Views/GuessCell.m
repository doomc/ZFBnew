//
//  GuessCell.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "GuessCell.h"
#import "UIImageView+ZFCornerRadius.h"
@implementation GuessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.guess_listView.clipsToBounds = YES;
//    [self.guess_listView CreateImageViewWithFrame:self.frame andBackground:[UIColor redColor].CGColor andRadius:10];
  
    self.guess_listView.layer.borderWidth = 0.5;
    self.guess_listView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
}

//搜索有结果的模型
-(void)setResultgGoodslist:(ResultFindgoodslist *)resultgGoodslist{
    _resultgGoodslist = resultgGoodslist;
    
    NSURL * img_url = [NSURL URLWithString:resultgGoodslist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = resultgGoodslist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",resultgGoodslist.netPurchasePrice];
    self.lb_storeName.text = resultgGoodslist.storeName;

}
//搜索无结果，精选列表模型
-(void)setSgoodlist:(SearchFindgoodslist *)sgoodlist
{
    _sgoodlist = sgoodlist;
    
    NSURL * img_url = [NSURL URLWithString:sgoodlist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = sgoodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",sgoodlist.netPurchasePrice];
    self.lb_storeName.text = sgoodlist.storeName;

}
//猜你喜欢模型
-(void)setGoodlist:(Guessgoodslist *)goodlist
{
    _goodlist = goodlist;
    
    NSURL * img_url = [NSURL URLWithString:_goodlist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = _goodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%.2f",_goodlist.storePrice];
    self.lb_storeName.text = _goodlist.storeName;
    self.lb_collectNum.text = [NSString stringWithFormat:@"%ld",_goodlist.goodsPv];
    CGFloat dictence  = _goodlist.storeDist/1000;
    self.lb_distence.text = [NSString stringWithFormat:@"%.2f公里",dictence ];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
