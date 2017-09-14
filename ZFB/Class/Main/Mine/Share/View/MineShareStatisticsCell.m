//
//  MineShareStatisticsCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "MineShareStatisticsCell.h"
@interface MineShareStatisticsCell () <UIGestureRecognizerDelegate>

@end
@implementation MineShareStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UITapGestureRecognizer * tapAll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAllView)];
    tapAll.delegate = self;
    tapAll.numberOfTapsRequired = 1;
    [_allIncomeView addGestureRecognizer:tapAll];
    
    UITapGestureRecognizer * tapGoods = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGoodsView)];
    tapGoods.delegate = self;
    tapGoods.numberOfTapsRequired = 1;
    [_goodsIncomeView addGestureRecognizer:tapGoods];
    
    UITapGestureRecognizer * taptoday = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTodayView)];
    taptoday.delegate = self;
    taptoday.numberOfTapsRequired = 1;
    [_todayIncomeView addGestureRecognizer:taptoday];

}

///点击总收入
-(void)tapAllView{
    if ([self.shareDelegate respondsToSelector:@selector(didClickAllincomeView)]) {
        [self.shareDelegate didClickAllincomeView];
    }
}

///点击商品数
-(void)tapGoodsView{
    if ([self.shareDelegate respondsToSelector:@selector(didClickgoodsNumView)]) {
        [self.shareDelegate didClickgoodsNumView];
    }
}


///点击今日收入
-(void)tapTodayView{
    if ([self.shareDelegate respondsToSelector:@selector(didClicktodayIncomeView)]) {
        [self.shareDelegate didClicktodayIncomeView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
