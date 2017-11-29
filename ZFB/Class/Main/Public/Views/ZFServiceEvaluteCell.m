//
//  ZFServiceEvaluteCell.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFServiceEvaluteCell.h"

@implementation ZFServiceEvaluteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.commitBtn.layer.cornerRadius = 4;
    self.commitBtn.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

   
    
    //服务态度
    XHStarRateView * sendView = [[XHStarRateView alloc]initWithFrame:self.sendSpeedAppraiseView.frame numberOfStars:5 rateStyle:WholeStar isAnination:YES delegate:self WithtouchEnable:YES littleStar:@"0"];//da星星
    [self addSubview:sendView];
    sendView.delegate = self;
}



/**
 送货速度
  */
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    _lb_sendSpeedScore.text = [NSString stringWithFormat:@"%.f分",currentScore];

    if ([self.delegate respondsToSelector:@selector(getSendSpeedScore:)]) {
        [self.delegate getSendSpeedScore:[NSString stringWithFormat:@"%.f",currentScore]];
    }
    
}
///提交
- (IBAction)didClickCommitAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCommit)]) {
        [self.delegate didClickCommit];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
