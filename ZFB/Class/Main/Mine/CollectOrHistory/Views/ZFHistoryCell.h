//
//  ZFCollectCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/31.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
#import "HistoryFootModel.h"
@interface ZFHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_collctView;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;


@property (strong, nonatomic) Cmkeepgoodslist * goodslist;

@property (strong, nonatomic) Cmscanfoolprintslist * scanfool;



@end
