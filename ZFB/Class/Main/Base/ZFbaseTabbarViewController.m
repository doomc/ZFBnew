//
//  ZFbaseTabbarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/6.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFbaseTabbarViewController.h"
#import "ZFBaseNavigationViewController.h"
#import "ZFHomeViewController.h"
#import "ZFShoppingCarViewController.h"
#import "ZFPersonalViewController.h"
#import "ZFCInterpersonalCircleViewController.h"//消息总控制器
#import "ShareCircleViewController.h" //分享圈

@interface ZFbaseTabbarViewController ()

@end

@implementation ZFbaseTabbarViewController

+ (void)initialize {
    
    // 设置UITabBarItem主题
    [self setupTabBarItemTheme];
    
    // 设置UITabBar主题
    [self setupTabBarTheme];
}

+ (void)setupTabBarItemTheme {
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /**设置文字属性**/
    // 普通状态
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName : HEXCOLOR(0xa7a7a7)} forState:UIControlStateNormal];
    
    // 选中状态
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName : HEXCOLOR(0xfe6d6a)} forState:UIControlStateSelected];
    

}

+ (void)setupTabBarTheme {
    
    //    UITabBar *tabBar = [UITabBar appearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self addAllViewControllers];
    
    // 创建自定义TabBar
    [self addCustomTabBar];
}

#pragma mark - 添加所有子控制器
- (void)addAllViewControllers {

    
    ZFHomeViewController* homeVC = [ZFHomeViewController new];
    [self addOneChildVc:homeVC title:@"新零售" imageName:@"shopkeeper" selectedImageName:@"shopkeeper_selected"];
    
    ZFCInterpersonalCircleViewController *circleVC = [ZFCInterpersonalCircleViewController new];
    [self addOneChildVc:circleVC title:@"消息" imageName:@"circle" selectedImageName:@"circle_selected"];
    
    ShareCircleViewController *shopVC = [ShareCircleViewController new];
    [self addOneChildVc:shopVC title:@"分享圈" imageName:@"shoppingCar" selectedImageName:@"shoppingCar_selected"];
    
    ZFPersonalViewController *meVc = [ZFPersonalViewController new];
    [self addOneChildVc:meVc title:@"我的" imageName:@"mine" selectedImageName:@"mine_selected"];
    
}

#pragma mark - 添加一个子控制器
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)seletedImageName {
    
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont fontWithName:title size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName, [UIFont fontWithName:title size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    //将NavigationController给包含进来。
    [self addChildViewController:[[ZFBaseNavigationViewController alloc] initWithRootViewController:childVc]];
}

#pragma mark - 自定义TabBar
- (void)addCustomTabBar {
    
    //设置TabBar的颜色
    self.tabBar.backgroundColor =[UIColor whiteColor];
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSLog(@"item name = %@", item.title);
    
    if([item.title isEqualToString:@"我的"])
    {
        // 也可以判断标题,然后做自己想做的事
    }
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
