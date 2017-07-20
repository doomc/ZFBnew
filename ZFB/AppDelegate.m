//
//  AppDelegate.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "BaseTabbarController.h"
#import "ZFbaseTabbarViewController.h"


#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AppDelegate+Location.h"
#import "SYSafeCategory.h"
const static NSString *ApiKey = @"a693affa49bd4e25c586d1cf4c97c35f";

@interface AppDelegate ()
@property(nonatomic,strong)CLLocation *  currentLocation;
@property(nonatomic,copy)CLLocation *  currentCity;
@end

@implementation AppDelegate
@synthesize isLogin;
@synthesize signMD5Key;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ZFbaseTabbarViewController *tabbarVC = [[ZFbaseTabbarViewController alloc] init];
    self.window.rootViewController = tabbarVC;
    [self.window makeKeyAndVisible];
    
    //高德地图
    [AMapServices sharedServices].apiKey = (NSString *)ApiKey;
    
 
    //默认一个switch开关的状态 存储在NSUserDefaults
    NSDictionary * df = @{@"switchType":@YES};
    [[NSUserDefaults standardUserDefaults]registerDefaults:df];
    
    //登录状态默认
 
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
