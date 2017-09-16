//
//  MineShareContentCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewingModel.h"

@interface MineShareContentCell : UITableViewCell

@property (strong , nonatomic) ReViewData * reviewingList;//审核中....
@property (strong , nonatomic) ReViewData * reviewedData;//已审核....
@property (strong , nonatomic) ReViewData * goodsReviewData;//商品数量....

@property (weak, nonatomic) IBOutlet UIImageView *headimg;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

/**
 审核状态
 */
@property (weak, nonatomic) IBOutlet UILabel *lb_reviewStatus;

//详情
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;

///奖励金  
@property (weak, nonatomic) IBOutlet UILabel *lb_descirbe;

@end
