//
//  ZFSettingCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

 
@interface ZFSettingCell : UITableViewCell

///清除缓存
-(void)clearingCache;
///获取大小
-(float)readCacheSize;


/* 头icon*/
@property (weak, nonatomic) IBOutlet UIImageView *img_iconView;

/**尾icon */
@property (weak, nonatomic) IBOutlet UIImageView *img_detailIcon;

/** 前缀 */
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

/** 后缀详情 */
@property (weak, nonatomic) IBOutlet UILabel *lb_detailTitle;

//获取当前缓存
@property (nonatomic,copy) NSString * currenCacheSize;

@end
