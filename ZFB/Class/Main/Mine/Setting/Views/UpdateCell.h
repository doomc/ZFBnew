//
//  UpdateCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateModel.h"

@interface UpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (strong, nonatomic) UpdateData * dataList;
@end
