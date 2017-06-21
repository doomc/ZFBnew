//
//  AllStoreCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AllStoreCell.h"
@interface AllStoreCell ()<XHStarRateViewDelegate>

@end
@implementation AllStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

//    self.img_allStoreView.clipsToBounds = YES;
//    self.img_allStoreView.layer.borderWidth = 0.5;
//    self.img_allStoreView.layer.borderColor = HEXCOLOR(0xffcccc).CGColor;
//
//    self.starView = [[XHStarRateView alloc]initWithFrame:CGRectMake(0, 0, 120, 40) numberOfStars:5 rateStyle:WholeStar isAnination:NO delegate:self];
 
}


-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore{
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
