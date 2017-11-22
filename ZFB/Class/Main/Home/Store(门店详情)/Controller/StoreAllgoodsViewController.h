//
//  StoreAllgoodsViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"

@interface StoreAllgoodsViewController : BaseViewController

@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);

@property ( nonatomic , strong ) UICollectionView  * AcollectionView;

@property ( nonatomic , copy ) NSString *storeId;

@end
