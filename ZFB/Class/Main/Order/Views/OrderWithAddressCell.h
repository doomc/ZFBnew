//
//  OrderWithAddressCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderWithAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_nameAndPhone;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@end
