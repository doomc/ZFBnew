//
//  SearchHasDataCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"
@interface SearchHasDataCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_Price;
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;

@property (nonatomic ,strong) ResultFindgoodslist *goodList;


@end
