//
//  ZFSettingRowCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFSettingRowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UITextField *tf_contentTextfiled;

@property (weak, nonatomic) IBOutlet UILabel *lb_detailTitle;

@property (copy, nonatomic) NSString * nickName;


@end
