//
//  GuessCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGuessModel.h"
#import "SearchNoResultModel.h"
#import "SearchResultModel.h"
@interface GuessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *zan_Image;

@property (weak, nonatomic) IBOutlet UIImageView *loca_img;

/** 视图URL */
@property (weak, nonatomic) IBOutlet UIImageView *guess_listView;
/** 商品名字 */
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
/** 门店名称 */
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;

//距离
@property (weak, nonatomic) IBOutlet UILabel *lb_distence;
//收藏个数
@property (weak, nonatomic) IBOutlet UILabel *lb_collectNum;

@property (nonatomic  , strong) Guessgoodslist * goodlist;

@property (nonatomic  , strong) SearchFindgoodslist * sgoodlist;//搜索无结果哟的推荐模型

@property (nonatomic  , strong) ResultFindgoodslist * resultgGoodslist;//搜索有结果



@end
