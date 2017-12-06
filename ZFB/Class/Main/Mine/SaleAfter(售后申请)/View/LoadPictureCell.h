//
//  LoadPictureCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LayoutBlock)(CGFloat height);

@interface LoadPictureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *loadColllectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstarintsHeight;

@property (nonatomic ,strong) NSArray * imagesUrl;
@property (nonatomic ,copy) LayoutBlock layoutBlock;

@end
