//
//  StoreDetailViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreDetailViewController : BaseViewController

/**
 门店id
 */
@property(nonatomic,copy)NSString *storeId;
//logo
@property (weak, nonatomic) IBOutlet UIImageView *storeLogo;
//背景
@property (weak, nonatomic) IBOutlet UIImageView *storeBackground;

@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
//销量和收藏
@property (weak, nonatomic) IBOutlet UILabel *lb_sale;
@property (weak, nonatomic) IBOutlet UILabel *lb_collect;
@property (weak, nonatomic) IBOutlet UIView *starView;

@end
