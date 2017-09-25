//
//  AppDelegate.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "AppDelegate.h"
#import "ZFbaseTabbarViewController.h"
#import "XLSlideMenu.h"
#import "RightNavPopViewController.h"//查询订单时间
//云信
#import "NTESClientUtil.h"
#import "NTESSessionUtil.h"
#import "ZFBCustomConfig.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESNotificationCenter.h"
#import "NTESSubscribeManager.h"
#import "NTESSessionListViewController.h"
//高德
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SYSafeCategory.h"//安全操作
#import "JhtGradientGuidePageVC.h"

//高德api
const static NSString * ApiKey = @"a693affa49bd4e25c586d1cf4c97c35f";
NSString *NTESNotificationLogout = @"NTESNotificationLogout";

//推送Kit
@import PushKit;
@interface AppDelegate ()<NIMLoginManagerDelegate,PKPushRegistryDelegate>

@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;
@property (nonatomic, strong) JhtGradientGuidePageVC *guidePage;

@end

@implementation AppDelegate
@synthesize isLogin;
@synthesize signMD5Key;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self setupGuidePageView];

    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    //高德地图
    [AMapServices sharedServices].apiKey = (NSString *)ApiKey;
    
 
    //默认一个switch开关的状态 存储在NSUserDefaults
    NSDictionary * df = @{@"switchType":@YES};
    [[NSUserDefaults standardUserDefaults]registerDefaults:df];
    
    
    //登录状态默认
    //    BBUserDefault.isLogin = 1;
    
    // 网易云信IM
    [self registerPushService];//注册pushKit
    
    [self registerAPNS];//注册APNS
    
    [self setupNIMSDK];
    
    //登录状态
    [self commonInitListenEvents];
    
    [self setupServices];
    
    return YES;
}
#pragma mark - 设置导航栏抽屉
-(void)navSetting
{

}
#pragma mark - logic impl
- (void)setupServices
{
    [[NTESNotificationCenter sharedCenter] start];
    [[NTESSubscribeManager sharedManager] start];

}


- (void)setupNIMSDK
{
    //在注册 NIMSDK appKey 之前先进行配置信息的注册，如是否使用新路径,是否要忽略某些通知，是否需要多端同步未读数
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = [[ZFBCustomConfig sharedConfig] appKey];
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = [[ZFBCustomConfig sharedConfig] apnsCername];
    option.pkCername        = [[ZFBCustomConfig sharedConfig] pkCername];
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    

}
- (void)commonInitListenEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

#pragma NIMLoginManagerDelegate   下线通知
-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
//    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
}
- (void)onAutoLoginFailed:(NSError *)error
{
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    DDLogInfo(@"onAutoLoginFailed %zd",error.code);
    [self showAutoLoginErrorAlert:error];
}

#pragma mark - 登录错误回调
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    NSString *message = [NTESSessionUtil formatAutoLoginMessage:error];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                 
                                                                NSString *account =  BBUserDefault.userPhoneNumber;
                                                                NSString *token =  BBUserDefault.token;
                                                                if ([account length] && [token length])
                                                                {
                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                                                                    loginData.account = account;
                                                                    loginData.token = token;
                                                                    
                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                                                                }
                                                            }];
        [vc addAction:retryAction];
    }
    
    
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                                                             }];
                                                         }];
    [vc addAction:logoutAction];
    
    [self.window.rootViewController presentViewController:vc
                                                 animated:YES
                                               completion:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];

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


#pragma mark - 获取唯一token
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    DDLogInfo(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", deviceToken);
    NSString*device = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@" "withString:@""]stringByReplacingOccurrencesOfString:@">"withString:@""];
    
 
    NSLog(@"%@",device);//0b80f4df845ba13378cd0868a8db45e4c56439fff09ec9e45e40abd480c6efbf
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DDLogInfo(@"receive remote notification:  %@", userInfo);
    ZFbaseTabbarViewController * tabBar = [[ZFbaseTabbarViewController alloc]initWithNibName:@"NTESSessionListViewController" bundle:nil];
    [self.window.rootViewController presentViewController:tabBar animated:YES completion:nil];
    tabBar.selectedIndex = 1;

}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DDLogError(@"fail to get apns token :%@",error);
}
/*
 1.开启后台模式
 2.调用completionHandler,告诉系统你现在是否有新的数据更新
 3.userInfo添加一个字段:"content-available" : "1" : 只要添加了该字段,接受到通知都会在后台运行
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
        [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    DDLogInfo(@"receive payload %@ type %@",payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
    
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    DDLogInfo(@"registry %@ invalidate %@",registry,type);
}

#pragma mark - misc
- (void)registerPushService
{
    //apns
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    //pushkit
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
}

- (void)registerAPNS
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |      UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
 
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    
}


//guide引导页
-(void)setupGuidePageView
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ZFbaseTabbarViewController *tabbarVC = [[ZFbaseTabbarViewController alloc] init];
    
    //会崩溃
//    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:tabbarVC];
//    RightNavPopViewController * menuVC = [RightNavPopViewController new];
//    //设置左右菜单
//    slideMenu.rightViewController = menuVC;
//    self.window.rootViewController = slideMenu;
    
    [self.window makeKeyAndVisible];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *isFirst = [defaults objectForKey:firstKey];
    if (!isFirst.length) {
      
        NSArray * images = @[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 100) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) - 30 - 50, 100, 30)];
        
        [enterButton setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];
        self.guidePage = [[JhtGradientGuidePageVC alloc] initWithGuideImageNames:images withLastRootViewController:tabbarVC];
        self.guidePage.enterButton = enterButton;
        
        // 添加《跳过》按钮
        self.guidePage.isNeedSkipButton = YES;
        self.window.rootViewController = self.guidePage;
        
        __weak AppDelegate *weakSelf = self;
        self.guidePage.didClickedEnter = ^() {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            NSString *isFirst = [defaults objectForKey:firstKey];
            if (!isFirst) {
                [defaults setObject:@"notFirst" forKey:firstKey];
                [defaults synchronize];
            }
            
            weakSelf.guidePage = nil;
        };
    } else {
        self.window.rootViewController = tabbarVC;
    }



}


@end
