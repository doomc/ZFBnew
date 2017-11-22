//
//  LogisticsProgressCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsModel.h"

@interface LogisticsProgressCell : UITableViewCell

//日期
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
//时间
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
//按钮状态
@property (weak, nonatomic) IBOutlet UIButton *status_btn;
//取件状态
@property (weak, nonatomic) IBOutlet UILabel *lb_orderStatus;
//描述
@property (weak, nonatomic) IBOutlet UILabel *lb_infoMessage;
@property (weak, nonatomic) IBOutlet UILabel *line_up;
@property (weak, nonatomic) IBOutlet UILabel *line_down;

@property (strong, nonatomic) LogisticsList * list;

@end
