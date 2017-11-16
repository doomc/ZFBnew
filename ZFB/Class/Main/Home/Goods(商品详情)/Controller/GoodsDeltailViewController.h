//
//  GoodsDeltailViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsDeltailViewController : BaseViewController

@property (nonatomic , copy) NSString *goodsId;
@property (nonatomic , copy) NSString *headerImage;

@property (nonatomic , copy) NSString *shareNum;//分享购买才传入的参数
@property (nonatomic , copy) NSString *shareId;//分享购买才传入的参数

@property (nonatomic , copy) NSString * store_address;//商户地址

@end
