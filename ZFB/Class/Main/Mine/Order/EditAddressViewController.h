//
//  EditAddressViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/6/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  编辑收货地址

#import "BaseViewController.h"


@interface EditAddressViewController : BaseViewController
@property (nonatomic ,copy)NSString * defaultFlag;// 1 是默认,2 否
@property (nonatomic ,copy)NSString * postAddressId;//回显id



@end
