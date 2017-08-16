//
//  HomeSearchResultViewController.h
//  ZFB
//
//  Created by 熊维东 on 2017/7/10.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeSearchResultViewController : BaseViewController

@property (nonatomic , copy) NSString * searchType;//门店或者商品
@property (nonatomic , copy) NSString * number;
@property (nonatomic , copy) NSString * resultsText;///搜索类型
@property (nonatomic , copy) NSString * labelId;///标签id

@end
