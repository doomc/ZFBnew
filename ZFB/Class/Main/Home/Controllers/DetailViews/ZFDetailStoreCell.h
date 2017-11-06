//
//  ZFDetailStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStoreModel.h"
@interface ZFDetailStoreCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_storeImageView;
@property (weak, nonatomic) IBOutlet UIView *Store_Bgview;
@property (weak, nonatomic) IBOutlet UILabel *lb_Storetitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
 
@property (strong ,nonatomic) DetailCmgoodslist * detailGoodlist;

@end
