//
//  PayforCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayforCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIButton *btn_selected;

@property (weak, nonatomic) IBOutlet UILabel *lb_Price;

@property (weak, nonatomic) IBOutlet UILabel *lb_balance;


@end
