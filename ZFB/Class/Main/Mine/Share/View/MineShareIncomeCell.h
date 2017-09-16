//
//  MineShareIncomeCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReviewingModel.h"

@interface MineShareIncomeCell : UITableViewCell
//总收入的
@property (strong , nonatomic) ReViewData * allReviewData;
//今日收入的
@property (strong , nonatomic) ReViewData * todayReviewData;


@property (weak, nonatomic) IBOutlet UILabel *lb_orderNum;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *lb_reword;

@end
