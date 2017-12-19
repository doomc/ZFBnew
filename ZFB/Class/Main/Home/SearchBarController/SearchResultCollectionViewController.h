//
//  SearchResultCollectionViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/12/15.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultCollectionViewController : BaseViewController

@property (nonatomic,assign) NSInteger searchType;//0 商品 1 门店
///标签id
@property (nonatomic , copy) NSString * labelId;
 

@property (nonatomic , copy) NSString * searchText ;//搜索内容



@end
