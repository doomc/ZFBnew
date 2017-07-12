//
//  HotSearchCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *hotSearchCollectionView;

@property (nonatomic , strong) NSArray  * hotArray;

@end
