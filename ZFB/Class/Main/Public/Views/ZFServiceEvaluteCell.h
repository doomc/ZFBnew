//
//  ZFServiceEvaluteCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@protocol ZFServiceEvaluteCellDelegate <NSObject>

//提交
-(void)didClickCommit;

//送货速度
-(void)getSendSpeedScore:(NSString *)speedScore;


@end

@interface ZFServiceEvaluteCell : UITableViewCell <XHStarRateViewDelegate>

@property (assign, nonatomic)  id <ZFServiceEvaluteCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *sendSpeedAppraiseView;

@property (weak, nonatomic) IBOutlet UIView *serviceAppraiseView;

@property (weak, nonatomic) IBOutlet UILabel *lb_sendSpeedScore;

@property (weak, nonatomic) IBOutlet UILabel *lb_serviceScore;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end
