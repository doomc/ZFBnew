//
//  BaseTabbarController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "BaseTabbarController.h"

#import "ZFHomeViewController.h"
#import "ZFPersonalViewController.h"
#import "ZFCInterpersonalCircleViewController.h"
#import "ZFShoppingCarViewController.h"

#import "BaseNavigationController.h"
#import "UIImage+Extension.h"
@interface BaseTabbarController ()

@end

@implementation BaseTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubViewsControllers];
    [self customTabbarItem];
}

-(void)addSubViewsControllers{
    
    NSArray *classControllers = @[@"ZFHomeViewController",
                                  @"ZFCInterpersonalCircleViewController",
                                  @"ZFShoppingCarViewController",
                                  @"ZFPersonalViewController"];
    NSMutableArray *conArr = [NSMutableArray array];
   
    for (int i = 0; i < classControllers.count; i ++) {
      
        Class cts = NSClassFromString(classControllers[i]);
      
        UIViewController *vc = [[cts alloc] init];
       
        BaseNavigationController *naVC = [[BaseNavigationController alloc]
                                          initWithRootViewController:vc];
        [conArr addObject:naVC];
    }
    self.viewControllers = conArr;
}

-(void)customTabbarItem{
    
    NSArray *titles = @[@"零售商",@"人际圈",@"购物车",@"我的"];
    
    NSArray *normalImages = @[@"shopkeeper",
                              @"circle",
                              @"shoppingCar",
                              @"mine"];
    
    NSArray *selectImages = @[@"shopkeeper_selected",
                              @"circle_selected",
                              @"shoppingCar_selected",
                              @"mine_selected"];
    
    for (int i = 0; i < titles.count; i++) {
       
        UIViewController *vc = self.viewControllers[i];
        
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
       
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:selectImage];
    }

    //设置TabBar的颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.tintColor =  HEXCOLOR(0xfe6d6a);
    
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSLog(@"item name = %@", item.title);

    if([item.title isEqualToString:@"我的"])
    {
        // 也可以判断标题,然后做自己想做的事
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
