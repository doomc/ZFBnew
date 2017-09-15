//
//  ShareNewGoodsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐

#import "ShareNewGoodsCell.h"
#import "UIImageView+ZFCornerRadius.h"

@implementation ShareNewGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
 
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

-(void)setRecommend:(Recommentlist *)recommend
{
    _recommend = recommend;
    
    _lb_zanNum.text = [NSString stringWithFormat:@"%ld",recommend.thumbs];
    _lb_buyNum.text = [NSString stringWithFormat:@"%ld",recommend.saleCount];

    _lb_goodsName.text = recommend.title;
    _lb_description.text = recommend.describe;
    
    //0未点赞 1已点赞
    _isThumbed = [NSString stringWithFormat:@"%ld",recommend.isThumbed];
    [_contentImgView sd_setImageWithURL:[NSURL URLWithString:recommend.goodsImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
