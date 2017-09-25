
//
//  ShareGoodsCollectionViewCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ShareGoodsCollectionViewCell.h"
#import "UIImageView+ZFCornerRadius.h"
#import "UIView+YYAdd.h"

@interface ShareGoodsCollectionViewCell ()<UIGestureRecognizerDelegate>

@end
@implementation ShareGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _waterPullImageView.clipsToBounds = YES;
    _waterPullImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContenImgView)];
    tap.delegate = self;
    _waterPullImageView.userInteractionEnabled = YES;
    [_waterPullImageView addGestureRecognizer:tap];
}


-(void)setFullList:(ShareGoodsData *)fullList
{
    _fullList = fullList;
    // 图片
    [self.waterPullImageView sd_setImageWithURL:[NSURL URLWithString:fullList.imgUrls] placeholderImage:[UIImage imageNamed:@"240x260"]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:fullList.userLogo] placeholderImage:[UIImage imageNamed:@"head"]];
    self.lb_title.text = fullList.title;
    self.lb_zanNum.text = fullList.thumbs;
    self.lb_nickname.text = fullList.nickname;
    self.lb_description.text = fullList.describe;
    _isThumbsStatus = fullList.thumbsStatus;
  
    if ([_isThumbsStatus  isEqualToString:@"0"]) {
        
        [_zan_btn setImage:[UIImage imageNamed:@"sharezan_selected"] forState:UIControlStateNormal];
        
    }else{
        [_zan_btn setImage:[UIImage imageNamed:@"sharezan_normal"] forState:UIControlStateNormal];
        
    }
    
}

//点击图片
-(void)tapContenImgView
{
    if ([self.shareDelegate respondsToSelector:@selector(didClickgGoodsImageViewAtIndexItem:)]) {
        [self.shareDelegate didClickgGoodsImageViewAtIndexItem:_indexItem];
    }
}
//点赞
- (IBAction)didClickZanAcion:(id)sender {

    if ([self.shareDelegate respondsToSelector:@selector(didClickZanAtIndexItem:AndisThumbsStatus:)]) {
        [self.shareDelegate didClickZanAtIndexItem:_indexItem AndisThumbsStatus:_isThumbsStatus];
    }
}


@end
