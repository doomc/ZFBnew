//
//  MineShareIncomeCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareIncomeCell.h"

@implementation MineShareIncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}


-(void)setReviewData:(ReViewData *)reviewData
{
    _reviewData = reviewData;
    _lb_time.text =reviewData.createTime;
    _lb_title.text = reviewData.title;
    _lb_reword.text = reviewData.reward;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:reviewData.goodsLogo] placeholderImage:[UIImage imageNamed:@""]];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
