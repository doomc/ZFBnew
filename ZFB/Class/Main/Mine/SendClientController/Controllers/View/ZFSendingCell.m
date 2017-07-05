//
//  ZFSendingCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSendingCell.h"

@implementation ZFSendingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.img_SenlistView.clipsToBounds = YES;
    self.img_SenlistView.layer.borderWidth = 0.5;
    self.img_SenlistView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;

 
}

-(void)setGoods:(Ordergoods *)goods
{
    _goods = goods;
    
    self.lb_num.text = [NSString stringWithFormat:@"x %ld%@",_goods.goodsCount, _goods.goodsUnit];
    self.lb_sendListTitle.text =  _goods.goodsName;
    self.lb_Price.text =[NSString stringWithFormat:@"¥%ld", goods.originalPrice];
    self.lb_detailTime.text = @"";
    [self.img_SenlistView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goods.coverImgUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
-(void)setList:(Orderlist *)list
{
    _list = list;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
