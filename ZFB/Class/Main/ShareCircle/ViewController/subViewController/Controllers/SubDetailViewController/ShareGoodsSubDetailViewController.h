//
//  ShareGoodsSubDetailViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareGoodsSubDetailViewController : BaseViewController

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
/** 描述 */
@property (weak, nonatomic) IBOutlet UILabel *lb_describe;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end
