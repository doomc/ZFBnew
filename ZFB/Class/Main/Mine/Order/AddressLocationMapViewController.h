//
//  AddressLocationMapViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  选择收货地址

#import "BaseViewController.h"
// 一会要传的值为NSString类型
typedef void (^newBlock)(NSString *);


@interface AddressLocationMapViewController : BaseViewController
// 声明block属性
@property (nonatomic, copy) newBlock block;

// 声明block方法
- (void)addressName:(newBlock)block;


@end
