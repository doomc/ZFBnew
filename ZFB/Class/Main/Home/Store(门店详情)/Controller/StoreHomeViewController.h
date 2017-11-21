//
//  StoreHomeViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/11/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseViewController.h"
@protocol JohnScrollViewDelegate<NSObject>

@optional
- (void)johnScrollViewDidScroll:(CGFloat)scrollY;

@end

@interface StoreHomeViewController : BaseViewController

@property (nonatomic,copy) void(^DidScrollBlock)(CGFloat scrollY);

@property ( nonatomic , copy ) NSString *storeId;

@property ( nonatomic , strong ) UITableView  * tableView;

@property (nonatomic,weak) id<JohnScrollViewDelegate>delegate;

@end
