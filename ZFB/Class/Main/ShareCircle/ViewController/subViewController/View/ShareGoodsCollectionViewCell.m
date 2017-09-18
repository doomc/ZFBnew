
//
//  ShareGoodsCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareGoodsCollectionViewCell.h"
#import "UIImageView+ZFCornerRadius.h"
#import "UIImage+ImageSize.h"
static const CGSize NilCacheSize ={-1,-1};
@implementation ShareGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _waterPullImageView.clipsToBounds = YES;
    _waterPullImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    _headImg.layer.masksToBounds = YES;    
    _headImg.layer.cornerRadius = 20;
}


-(void)setFullList:(ShareGoodsData *)fullList
{
    _fullList = fullList;
    // 图片
    [self.waterPullImageView sd_setImageWithURL:[NSURL URLWithString:fullList.imgUrls] placeholderImage:[UIImage imageNamed:@"nodataPlaceholder"]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:fullList.userLogo] placeholderImage:[UIImage imageNamed:@"head"]];
    self.lb_title.text = fullList.title;
    self.lb_zanNum.text = fullList.thumbs;
    self.lb_nickname.text = fullList.nickname;
    self.lb_description.text = fullList.describe;
    _isThumbsStatus = fullList.thumbsStatus;
    
    
}





@end
