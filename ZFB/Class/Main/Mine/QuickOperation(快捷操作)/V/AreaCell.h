//
//  AreaCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"

@interface AreaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_addressName;

@property (nonatomic ,strong) AreaData * provinceList;

@end
