//
//  ZFSendingCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSendingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_sendListTitle;
@property (weak, nonatomic) IBOutlet UIImageView *img_SenlistView;
@property (weak, nonatomic) IBOutlet UILabel *lb_Price;
@property (weak, nonatomic) IBOutlet UILabel *lb_num;
@property (weak, nonatomic) IBOutlet UILabel *lb_detailTime;

@end
