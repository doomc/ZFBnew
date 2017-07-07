//
//  ZFSettingCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZFSettingCellDelete <NSObject>


///清除缓存
-(void)clearingCache;


@end
@interface ZFSettingCell : UITableViewCell

@property (assign ,nonatomic) id <ZFSettingCellDelete> delegate;
/* 头icon*/
@property (weak, nonatomic) IBOutlet UIImageView *img_iconView;

/**尾icon */
@property (weak, nonatomic) IBOutlet UIImageView *img_detailIcon;

/** 前缀 */
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

/** 后缀详情 */
@property (weak, nonatomic) IBOutlet UILabel *lb_detailTitle;


@end
