//
//  EditCommetCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/30.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCommetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_creatTime;
@property (weak, nonatomic) IBOutlet UIButton *zan_btn;
@property (weak, nonatomic) IBOutlet UILabel *lb_zanNum;

@end
