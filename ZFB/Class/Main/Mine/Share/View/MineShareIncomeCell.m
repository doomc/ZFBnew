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

//总收入模型
-(void)setAllReviewData:(ReViewData *)allReviewData
{
    _allReviewData = allReviewData;
    _lb_orderNum.text = allReviewData.orderNum;
    _lb_time.text = allReviewData.createTime;
    _lb_title.text = allReviewData.goodsName;
    _lb_reword.text = [NSString stringWithFormat:@"奖励:%@元",allReviewData.reward];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:allReviewData.goodsLogo] placeholderImage:[UIImage imageNamed:@""]];
    
}
 
//今日收入的
-(void)setTodayReviewData:(ReViewData *)todayReviewData
{
    _todayReviewData = todayReviewData;
    _lb_orderNum.text = todayReviewData.orderNum;
    _lb_time.text = todayReviewData.createTime;
    _lb_title.text = todayReviewData.goodsName;
    _lb_reword.text = [NSString stringWithFormat:@"商品金额:%@元  奖励:%@元",todayReviewData.price,todayReviewData.reward];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:todayReviewData.goodsLogo] placeholderImage:[UIImage imageNamed:@""]];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
