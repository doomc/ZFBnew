//
//  LogisticsProgressCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsModel.h"
#import "CheckModel.h"

@interface LogisticsProgressCell : UITableViewCell

//日期
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
 
//按钮状态
@property (weak, nonatomic) IBOutlet UIButton *status_btn;

//描述
@property (weak, nonatomic) IBOutlet UILabel *lb_infoMessage;
@property (weak, nonatomic) IBOutlet UILabel *line_up;
@property (weak, nonatomic) IBOutlet UILabel *line_down;

@property (strong, nonatomic) LogisticsList * list;//物流
@property (strong, nonatomic) CheckList * checklist;//进度查询

@end
