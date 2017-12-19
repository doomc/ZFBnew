//
//  DuplicationStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailHomeModel.h"
#import "StoreNewRecommentModel.h"
#import "SearchNoResultModel.h"

@interface DuplicationStoreCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentIMG;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_colltionNum;
@property (weak, nonatomic) IBOutlet UIButton *collect_btn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) GoodsExtendList * goodslist;
@property (strong, nonatomic) StoreRecommentGoodsList * anewGoods;
@property (strong, nonatomic) SearchFindgoodslist * goodsList;//搜索无结果哟的推荐模型

@end
