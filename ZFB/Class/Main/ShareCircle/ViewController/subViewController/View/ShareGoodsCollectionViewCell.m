
//
//  ShareGoodsCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareGoodsCollectionViewCell.h"
#import "UIImageView+ZFCornerRadius.h"
@implementation ShareGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _waterPullImageView.clipsToBounds = YES;
    _waterPullImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    _headImg.layer.masksToBounds = YES;    
    _headImg.layer.cornerRadius = 22;
}


-(void)setFullList:(ShareGoodsData *)fullList
{
    _fullList = fullList;
    // 图片
    [self.waterPullImageView sd_setImageWithURL:[NSURL URLWithString:fullList.imgUrl] placeholderImage:[UIImage imageNamed:@""]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:fullList.userLogo] placeholderImage:[UIImage imageNamed:@"head"]];
    self.lb_title.text = fullList.title;
    self.lb_zanNum.text = fullList.thumbs;
    self.lb_nickname.text = fullList.nickname;
    self.lb_description.text = fullList.describe;
    _isThumbsStatus = fullList.thumbsStatus;
    
    CGFloat itemH = fullList.height * self.width / fullList.width;
    _waterPullImageView.frame = CGRectMake(0, 0, self.frame.size.width, itemH);
    
    _lb_title.frame=CGRectMake(10, _waterPullImageView.bottom+10, self.frame.size.width-20, 20);


}

@end
