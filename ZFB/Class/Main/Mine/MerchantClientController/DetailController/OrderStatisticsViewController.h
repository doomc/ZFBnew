//
//  OrderStatisticsViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  商户端订单统计

#import "BaseViewController.h"

@interface OrderStatisticsViewController : BaseViewController

@property (nonatomic , copy) NSString * orderNum;

@property (nonatomic , copy) NSString * dealPrice;

@property (nonatomic , copy) NSString * storeId;


@end
