//
//  ZFSureOrderViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  确认订单

#import "BaseViewController.h"

@interface ZFSureOrderViewController : BaseViewController

//jsonstr
@property (nonatomic,copy) NSString * jsonString;


@property (nonatomic,strong) NSMutableArray * userGoodsInfoJSON;

@property (nonatomic,copy) NSString * cartItemId;//购物车id



@end
