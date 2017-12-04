//
//  ZFDetailOrderViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface ZFDetailOrderViewController : BaseViewController

@property (nonatomic,copy) NSString * cmOrderid;
@property (nonatomic,copy) NSString * storeId;
@property (nonatomic,copy) NSString * goodsId;
@property (nonatomic,copy) NSString * imageUrl;

@property (nonatomic,assign) NSInteger  isUserType; // 3 是用户 1 是商户 2 是配送

@end
