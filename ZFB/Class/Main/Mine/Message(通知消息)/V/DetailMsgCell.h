//
//  DetailMsgCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/10/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonMessageModel.h"

@interface DetailMsgCell : UITableViewCell
@property (nonatomic ,strong) DateList * dateList;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
