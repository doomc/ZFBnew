//
//  FeedPickerCollectionViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPImageItemModel.h"
#define FeedPickerCollectionViewCellHeight 50

@interface FeedPickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *addImgView;

@property (weak, nonatomic) IBOutlet UIButton *delete_button;

@property (strong, nonatomic) MPImageItemModel *curImageItem;

@end
