//
//  ShareNewGoodsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  新品推荐

#import "ShareNewGoodsCell.h"
#import "UIImageView+ZFCornerRadius.h"
@interface ShareNewGoodsCell ()<UIGestureRecognizerDelegate>


@end
@implementation ShareNewGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lb_tags.preferredMaxLayoutWidth = KScreenW - 30;
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didPicture:)];
    tap.delegate = self;
    _contentImgView.userInteractionEnabled = YES;
    [_contentImgView addGestureRecognizer:tap];
}

-(void)setRecommend:(Recommentlist *)recommend
{
    _recommend = recommend;
    
    _lb_zanNum.text = [NSString stringWithFormat:@"%ld",recommend.thumbs];
    _lb_buyNum.text = [NSString stringWithFormat:@"%ld",recommend.saleCount];

    _lb_goodsName.text = recommend.title;
    _lb_tags.text = recommend.describe;
    [_contentImgView sd_setImageWithURL:[NSURL URLWithString:recommend.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"720x330"]];

    //0未点赞 1已点赞
    _isThumbed = [NSString stringWithFormat:@"%ld",recommend.isThumbed];
    if ([_isThumbed  isEqualToString:@"1"]) {
        
        [_zan_btn setImage:[UIImage imageNamed:@"sharezan_selected"] forState:UIControlStateNormal];

    }else{
        [_zan_btn setImage:[UIImage imageNamed:@"sharezan_normal"] forState:UIControlStateNormal];

    }
    
}
- (IBAction)didClickZan:(id)sender {
    
     if ([self.delegate respondsToSelector:@selector(didClickZanAtIndex:)]) {
        [self.delegate didClickZanAtIndex:_indexRow];
    }
}

-(void)didPicture:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didClickPictureDetailAtIndex:)]) {
        [self.delegate didClickPictureDetailAtIndex:_indexRow];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
