
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
#import "NSString+EnCode.h"
@interface ShareGoodsCollectionViewCell ()<UIGestureRecognizerDelegate>

@end
@implementation ShareGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    
    _waterPullImageView.clipsToBounds = YES;
    _waterPullImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = 15;
    
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
    self.lb_nickname.text  = fullList.userNickname;
    self.lb_title.text = fullList.title;
    self.lb_zanNum.text = fullList.thumbs;
    self.lb_description.text = [fullList.describe decodedString];
    self.lb_evaNum.text = fullList.commentNum;
    _isThumbsStatus = fullList.thumbsStatus;
  
    if ([_isThumbsStatus  isEqualToString:@"0"]) {
        
        [_zan_btn setImage:[UIImage imageNamed:@"praise_on"] forState:UIControlStateNormal];
        
    }else{
        [_zan_btn setImage:[UIImage imageNamed:@"praise_off"] forState:UIControlStateNormal];
        
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
//评级查看评论
- (IBAction)didCommentAction:(id)sender {
    
    if ([self.shareDelegate respondsToSelector:@selector(didClickCheckCommentAtIndexItem:)]) {
        [self.shareDelegate didClickCheckCommentAtIndexItem:_indexItem ];
    }
}


@end
