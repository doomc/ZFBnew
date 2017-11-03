//
//  ProvinceVC.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/3.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddressBlock)(NSString * areaId ,NSString * address);

@interface ProvinceVC : BaseViewController

@property (nonatomic ,copy) AddressBlock  addressBlock;

@end
