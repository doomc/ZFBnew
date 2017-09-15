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

@property (strong , nonatomic) ReViewData * reviewList;//审核中....
@property (strong , nonatomic) ReViewData * reviewData;//已审核....

@property (weak, nonatomic) IBOutlet UIImageView *headimg;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_reviewStatus;

@property (weak, nonatomic) IBOutlet UILabel *lb_detail;

@property (weak, nonatomic) IBOutlet UILabel *lb_descirbe;

@end
