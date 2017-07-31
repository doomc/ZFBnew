//
//  AddressLocationMapViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/7/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  地图选择收货地址

#import "BaseViewController.h"
// 一会要传的值为NSString类型
typedef void (^newBlock)(NSString *);
typedef void(^BlockWithlongitude)(NSString *);//经度
typedef void(^BlockWithlatitude)(NSString *);//纬度
typedef void(^BlockWithpossid)(NSString *);//邮编


@interface AddressLocationMapViewController : BaseViewController
// 声明block属性
@property (nonatomic, copy) newBlock block;
@property (nonatomic, copy) BlockWithlatitude latitudeBlock;
@property (nonatomic, copy) BlockWithlongitude longitudeBlock;
@property (nonatomic, copy) BlockWithpossid possidBlock;

// 声明block方法
- (void)addressName:(newBlock)block;

@end
