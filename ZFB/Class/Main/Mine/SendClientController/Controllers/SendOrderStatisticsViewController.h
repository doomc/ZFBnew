//
//  SendOrderStatisticsViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/2.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  配送端订单统计

#import "BaseViewController.h"

@interface SendOrderStatisticsViewController : BaseViewController


@property (nonatomic , copy) NSString * orderNum;//配送数量
@property (nonatomic , copy) NSString * dealPrice;//配送费

@property (nonatomic , copy) NSString * deliveryId;
@property (nonatomic , copy) NSString * orderStartTime;
@property (nonatomic , copy) NSString * orderEndTime;

@end
