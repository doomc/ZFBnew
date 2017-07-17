//
//  ZFAllOrderViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/25.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ZFAllOrderViewController : BaseViewController

@property(nonatomic ,assign) OrderType orderType;

@property(nonatomic ,copy) NSString * buttonTitle;

#pragma mark - 网络请求必传的参数
@property (nonatomic ,copy) NSString *  payStatus     ;//支付状态
@property (nonatomic ,copy) NSString *  orderStatus ;//订单状态


@end
