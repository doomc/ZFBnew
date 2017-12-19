//
//  SearchStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/19.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStoreListModel.h"

@interface SearchStoreCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_allStoreView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_distance;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (strong, nonatomic) Findgoodslist *  storelist;


@end
