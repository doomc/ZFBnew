//
//  QRPayHistoryCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRPayHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *lb_money;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailMoney;
@end
