//
//  HomeSearchResultViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeSearchResultViewController : BaseViewController
///搜索类型
@property (nonatomic , copy) NSString * searchType;
///门店或者商品
@property (nonatomic , copy) NSString * number;
///搜索类型
@property (nonatomic , copy) NSString * resultsText;
///标签id
@property (nonatomic , copy) NSString * labelId;
///商品类别
@property (nonatomic , copy) NSString * goodsType;

 
@end
