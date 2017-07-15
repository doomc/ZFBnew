//
//  FindStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStoreListModel.h"
@interface FindStoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *store_listView;

@property (weak, nonatomic) IBOutlet UILabel *store_listTitle;

@property (weak, nonatomic) IBOutlet UILabel *lb_distence;

@property (weak, nonatomic) IBOutlet UILabel *lb_collectNum;

@property (strong,nonatomic) FindStoreGoodslist  * findgoodslist;


@end
