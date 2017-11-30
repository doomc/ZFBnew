//
//  SendStatisticsContentCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendStatisticsContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_sendTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendFee;
@property (weak, nonatomic) IBOutlet UILabel *lb_sendCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_stautus;

@end
