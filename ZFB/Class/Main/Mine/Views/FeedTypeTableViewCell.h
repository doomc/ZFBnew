//
//  FeedTypeTableViewCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/4.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;

@property (strong,nonatomic) NSMutableArray * nameArray;

@end
