//
//  BaseNavigationController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //setBarTintColor >ios 7
    //IOS7之前，setTintColor
//    [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    
    //隐藏按钮文字
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}forState:UIControlStateNormal];
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        
        if (isIOS7) {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
        } else {
            [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
        }
        
    }
    
    //导航栏
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 30, 30);
    [setBtn setBackgroundImage:[UIImage imageNamed:@"navback_white"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(popToBack) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

- (void)popToBack{
    
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}






@end
