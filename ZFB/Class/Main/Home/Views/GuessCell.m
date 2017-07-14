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


-(void)setGoodlist:(Findgoodslist *)goodlist
{
    _goodlist = goodlist;
    
    NSURL * img_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_goodlist.coverImgUrl]];
    [self.guess_listView sd_setImageWithURL:img_url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.lb_goodsName.text = _goodlist.goodsName;
    self.lb_price.text = [NSString stringWithFormat:@"¥%@",_goodlist.netPurchasePrice];
    self.lb_storeName.text = _goodlist.storeName;
    self.lb_collectNum.text = [NSString stringWithFormat:@"%ld",_goodlist.goodsPv];
    self.lb_distence.text = [NSString stringWithFormat:@"%@公里", _goodlist.storeDist];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
