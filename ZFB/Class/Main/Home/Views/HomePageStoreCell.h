//
//  HomePageStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStoreListModel.h"
#import "XHStarRateView.h"

@interface HomePageStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lb_collect;
@property (weak, nonatomic) IBOutlet UILabel *lb_distence;

@property (strong, nonatomic) XHStarRateView * xh_starView;
@property (strong,nonatomic) Findgoodslist  * findgoodslist;

@end
