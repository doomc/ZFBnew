//
//  FindStoreCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListModel.h"

@interface FindStoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *store_listView;

@property (weak, nonatomic) IBOutlet UILabel *store_listTitle;

@property (weak, nonatomic) IBOutlet UILabel *lb_distence;

@property (weak, nonatomic) IBOutlet UILabel *lb_collectNum;

@property (nonatomic , strong) StoreListModel * storeList;

@end
