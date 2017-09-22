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

//    //TggStarEvaluationView
//    weakSelf(weakSelf);
//    //发货速度
//    _sendSpeedAppraiseView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
//        
//        weakSelf.lb_sendSpeedScore.text = [NSString stringWithFormat:@"%ld分",count];
//    }];
//    //服务态度
//    _serviceAppraiseView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
//        
//        weakSelf.lb_serviceScore.text = [NSString stringWithFormat:@"%ld分",count];
//    }];

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
