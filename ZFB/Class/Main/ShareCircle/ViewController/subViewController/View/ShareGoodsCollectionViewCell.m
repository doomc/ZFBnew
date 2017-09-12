
//
//  ShareGoodsCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareGoodsCollectionViewCell.h"

@implementation ShareGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setFullModel:(ShareWaterFullModel *)fullModel
{
    _fullModel  = fullModel;
    
    // 图片
    [self.waterPullImageView sd_setImageWithURL:[NSURL URLWithString:fullModel.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:fullModel.img] placeholderImage:[UIImage imageNamed:@"head"]];
    
    self.lb_title.text = fullModel.price;
    self.lb_zanNum.text = fullModel.price;
    self.lb_nickname.text = fullModel.price;
    self.lb_description.text = fullModel.price;
    
    
 
}
@end
