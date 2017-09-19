//
//  AddressLocationMapViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  地图选择收货地址

#import "BaseViewController.h"

typedef void(^POISearchReturnBlock)(NSString *name, CGFloat longitude, CGFloat latitude, NSString *postCode);


@interface AddressLocationMapViewController : BaseViewController

@property (nonatomic, copy) POISearchReturnBlock searchReturnBlock;
@end
