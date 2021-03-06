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
#import "LoginViewController.h"
#import "PPBadgeView.h"
#import "AppDelegate.h"

#import "NTESSessionUtil.h"

@interface ZFbaseTabbarViewController ()<NIMLoginManagerDelegate,NIMEventSubscribeManagerDelegate>

@property (nonatomic,assign) NSInteger  teamUnreadCount;

@property (nonatomic,assign) NSInteger  singleUnreadCount;

@end

@implementation ZFbaseTabbarViewController

+ (void)initialize {
    // 设置UITabBarItem主题
    [self setupTabBarItemTheme];
}

+ (void)setupTabBarItemTheme {
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    /**设置文字属性**/
    // 普通状态
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName : HEXCOLOR(0x333333)} forState:UIControlStateNormal];
    
    // 选中状态
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName : HEXCOLOR(0xf95a70)} forState:UIControlStateSelected];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].subscribeManager addDelegate:self];

    // 添加所有子控制器
    [self addAllViewControllers];
    
    // 创建自定义TabBar
    [self addCustomTabBar];
}

#pragma mark - 添加所有子控制器
- (void)addAllViewControllers {

    ZFHomeViewController* homeVC = [ZFHomeViewController new];
    [self addOneChildVc:homeVC title:@"首页" imageName:@"home-off" selectedImageName:@"home-on"];
    
    ZFCInterpersonalCircleViewController *msgVC = [ZFCInterpersonalCircleViewController new];
    [self addOneChildVc:msgVC title:@"消息" imageName:@"news-off" selectedImageName:@"news-on"];
 
    if ([BBUserDefault.unReadCount isEqualToString:@"0"]) {
        msgVC.tabBarItem.badgeValue = nil;

    }else{
        msgVC.tabBarItem.badgeValue = BBUserDefault.unReadCount;

    }
    
    ShareCircleViewController *shopVC = [ShareCircleViewController new];
    [self addOneChildVc:shopVC title:@"分享圈" imageName:@"share-off" selectedImageName:@"share-on"];
//    [shopVC.tabBarItem pp_addDotWithColor:[UIColor redColor]];
 
    ZFPersonalViewController *meVc = [ZFPersonalViewController new];
    [self addOneChildVc:meVc title:@"我的" imageName:@"mine" selectedImageName:@"mine_selected"];
 
}

#pragma mark - 添加一个子控制器
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)seletedImageName {
    
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

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
    if([item.title isEqualToString:@"消息"])
    {
        // 也可以判断标题,然后做自己想做的事
        if (BBUserDefault.isLogin == 1) {
            
        }else{
            
            NSLog(@"登录了");
            LoginViewController * logvc    = [ LoginViewController new];
            ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:logvc];
            [self presentViewController:nav animated:NO completion:^{
                
//                [nav.navigationBar setBarTintColor:HEXCOLOR(0xfe6d6a)];
//                [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
            }];
        }
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
