//
//  MineShareContentCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareContentCell.h"

@implementation MineShareContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

///审核中
-(void)setReviewingList:(ReViewData *)reviewingList
{
    _reviewingList = reviewingList;
    
    _lb_title.text = reviewingList.title;
    _lb_reviewStatus.text = reviewingList.status;
    _lb_descirbe.text = reviewingList.describe;
    _lb_detail.text = @"";
    [_headimg sd_setImageWithURL:[NSURL URLWithString:reviewingList.imgUrls] placeholderImage:[UIImage imageNamed:@"230x235"]];

}

///已审核
-(void)setReviewedData:(ReViewData *)reviewedData
{
    _reviewedData = reviewedData;
    
    _lb_title.text = reviewedData.goodsName;
    _lb_reviewStatus.hidden = YES;
    _lb_detail.text = @"";
    _lb_descirbe.text = [NSString stringWithFormat:@"奖励:%@元",reviewedData.reward];//鼓励金
    
    [_headimg sd_setImageWithURL:[NSURL URLWithString:reviewedData.imgUrls] placeholderImage:[UIImage imageNamed:@"230x235"]];
    
}

-(void)setGoodsReviewData:(ReViewData *)goodsReviewData
{
    _goodsReviewData = goodsReviewData;
    _lb_title.text = goodsReviewData.title;
    _lb_reviewStatus.hidden = YES;
    _lb_detail.text = @"";
    _lb_descirbe.text = goodsReviewData.describe;//描述
    [_headimg sd_setImageWithURL:[NSURL URLWithString:goodsReviewData.imgUrls] placeholderImage:[UIImage imageNamed:@"230x235"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
