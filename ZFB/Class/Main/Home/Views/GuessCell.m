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
    self.guess_listView.layer.cornerRadius = 2;
    self.guess_listView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  
    self.lb_storeName.preferredMaxLayoutWidth = KScreenW - 25 - 15 - 115 - 110 /375.0* KScreenW;
}

//搜索有结果的模型
-(void)setResultgGoodslist:(ResultFindgoodslist *)resultgGoodslist{
    _resultgGoodslist = resultgGoodslist;
    
    NSURL * img_url = [NSURL URLWithString:resultgGoodslist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = resultgGoodslist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",resultgGoodslist.priceTostr];
    self.lb_storeName.text = resultgGoodslist.storeName;

}
//搜索无结果，精选列表模型
-(void)setSgoodlist:(SearchFindgoodslist *)sgoodlist
{
    _sgoodlist = sgoodlist;
    
    NSURL * img_url = [NSURL URLWithString:sgoodlist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = sgoodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",sgoodlist.priceTostr];
    self.lb_storeName.text = sgoodlist.storeName;

}
//猜你喜欢模型
-(void)setGoodlist:(Guessgoodslist *)goodlist
{
    _goodlist = goodlist;
    
    NSURL * img_url = [NSURL URLWithString:_goodlist.coverImgUrl ];
    [self.guess_listView sd_setImageWithURL:img_url placeholderImage:nil];
    
    self.lb_goodsName.text = _goodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",_goodlist.priceTostr];
    self.lb_storeName.text = _goodlist.storeName;
    self.lb_collectNum.text = [NSString stringWithFormat:@"%ld",_goodlist.goodsPv];
    self.lb_distence.text = [NSString stringWithFormat:@"%@公里",_goodlist.storeDist ];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
