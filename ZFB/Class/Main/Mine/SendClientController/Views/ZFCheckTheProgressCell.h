//
//  ZFCheckTheProgressCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/26.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderProgress.h"
@protocol ZFCheckTheProgressCellDelegate <NSObject>

/**
 *  进度查询
 */
-(void)progressWithCheckoutIndexPath:(NSInteger)indexpath;

@end
@interface ZFCheckTheProgressCell : UITableViewCell

@property (assign ,nonatomic)id <ZFCheckTheProgressCellDelegate> deldegate;

@property (nonatomic , strong) List * progressList;
@property (nonatomic , assign) NSInteger  indexpath;

@property (weak, nonatomic) IBOutlet UIButton *checkProgress_btn;
@property (weak, nonatomic) IBOutlet UILabel *lb_serviceNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_checkStatus;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_applelyTime;
@property (weak, nonatomic) IBOutlet UIImageView *img_progressView;

@end
