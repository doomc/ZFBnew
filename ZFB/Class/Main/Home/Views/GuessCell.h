//
//  GuessCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGuessModel.h"

@interface GuessCell : UITableViewCell
/** 视图URL */
@property (weak, nonatomic) IBOutlet UIImageView *guess_listView
;
/** 商品名字 */
@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;

/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *lb_price;

/** 网购价格 */
@property (weak, nonatomic) IBOutlet UILabel *lb_netPurchasePrice;

/** 门店名称 */
@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;

@property (weak, nonatomic) IBOutlet UILabel *lb_distence;

@property (weak, nonatomic) IBOutlet UILabel *lb_collectNum;

@property (nonatomic  , strong) Guessgoodslist * goodlist;


@end
