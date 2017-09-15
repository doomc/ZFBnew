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

-(void)setReviewList:(ReViewData *)reviewList
{
    _reviewList = reviewList;
    
    _lb_title.text = reviewList.title;
    _lb_reviewStatus.text = reviewList.status;
    _lb_descirbe.text = reviewList.describe;

    if ([reviewList.status isEqualToString:@"审核中"]) {
        _lb_title.textColor = HEXCOLOR(0xfe6d6a);
    }
    [_headimg sd_setImageWithURL:[NSURL URLWithString:reviewList.imgUrls] placeholderImage:[UIImage imageNamed:@""]];

}
-(void)setReviewData:(ReViewData *)reviewData
{
    _reviewData = reviewData;
    
    _lb_title.text = reviewData.title;
    _lb_reviewStatus.hidden = YES;
    _lb_descirbe.text = reviewData.reward;//鼓励金
    
    [_headimg sd_setImageWithURL:[NSURL URLWithString:reviewData.imgUrl] placeholderImage:[UIImage imageNamed:@""]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
