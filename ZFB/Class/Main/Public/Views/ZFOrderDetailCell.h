//
//  ZFOrderDetailCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFOrderDetailCell : UITableViewCell

/**
 标题名
 */
@property (weak, nonatomic) IBOutlet UILabel *lb_detailtitle;


/**
  标题尾部名称
 */
@property (weak, nonatomic) IBOutlet UILabel *lb_detaileFootTitle;
 
@end
