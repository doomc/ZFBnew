//
//  ZFOrderDetailGoosContentCell.h
//  ZFB
//
//  Created by 熊维东 on 2017/5/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailOrderModel.h"
@interface ZFOrderDetailGoosContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_orderDetailView;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UILabel *lb_count;

@property (nonatomic , strong) DetailGoodslist * goodlist;

@end
