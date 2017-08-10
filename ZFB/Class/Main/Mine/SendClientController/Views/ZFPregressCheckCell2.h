//
//  ZFPregressCheckCell2.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckModel.h"

@interface ZFPregressCheckCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_serviceNum;

@property (weak, nonatomic) IBOutlet UILabel *lb_applyTime;

@property (strong, nonatomic) CheckList * list;

@end
