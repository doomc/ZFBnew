//
//  HotCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_hotImgView;

/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
