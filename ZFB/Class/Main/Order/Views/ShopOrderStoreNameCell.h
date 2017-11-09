//
//  ShopOrderStoreNameCell.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/29.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussnissListModel.h"
@interface ShopOrderStoreNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_storeName;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property (strong, nonatomic)  BussnissUserStoreList * storeList;//商家清单


@end
