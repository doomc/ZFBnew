//
//  ZFbaseTabbarViewController.h
//  ZFB
//
//  Created by  展富宝  on 2017/6/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFbaseTabbarViewController : UITabBarController

@property (nonatomic, assign) BOOL isToLogin;

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end
