//
//  ZFEvaluateGoodsViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/8/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ZFEvaluateGoodsViewController : BaseViewController

/**
 可能会用到OrderID 没有接口暂时
 */
@property (nonatomic , copy) NSString * orderId;
@property (nonatomic , copy) NSString * goodId;

@end
