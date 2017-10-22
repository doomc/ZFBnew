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
//wx支付
#import "WXApi.h"
#import "WXApiManager.h"
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

//极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//高德api
const static NSString * ApiKey = @"a693affa49bd4e25c586d1cf4c97c35f";
NSString *NTESNotificationLogout = @"NTESNotificationLogout";

//推送Kit
@import PushKit;
@interface AppDelegate ()<NIMLoginManagerDelegate,PKPushRegistryDelegate,WXApiDelegate,JPUSHRegisterDelegate,NIMConversationManagerDelegate>
{
     NSInteger _jpsuhCount;
    
}
@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;
@property (nonatomic, strong) JhtGradientGuidePageVC *guidePage;

@end

@implementation AppDelegate
@synthesize isLogin;
@synthesize signMD5Key;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //引导页 和 tabar 初始化
    [self setupGuidePageView];
    
    //检查appstore更新版本
    [self CheckUpadateVersion];
    
    //注册微信支付
    [WXApi registerApp:@"wx2b173adc370b8052" enableMTA:YES];
    
    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    //高德地图
    [AMapServices sharedServices].apiKey = (NSString *)ApiKey;
    
    
    //默认一个switch开关的状态 存储在NSUserDefaults
    NSDictionary * df = @{@"switchType":@YES};
    [[NSUserDefaults standardUserDefaults]registerDefaults:df];
    
    // 网易云信IM
    [self registerPushService];//注册pushKit
    
    [self setupNIMSDK];
    
    //登录状态
    [self commonInitListenEvents];
    
    [self setupServices];
    
    [self loginNIM];
    
    [self registerAPNS];//极光推送注册APNS

    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
              NSSet<UNNotificationCategory *> *categories;
              entity.categories = categories;
            }
            else {
              NSSet<UIUserNotificationCategory *> *categories;
              entity.categories = categories;
            }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppkey
                          channel:@"Publish channel"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    return YES;
}
#pragma mark - logic impl
- (void)setupServices
{
    [[NTESNotificationCenter sharedCenter] start];
    [[NTESSubscribeManager sharedManager] start];
    
}
-(void)loginNIM{
    
    if (BBUserDefault.userPhoneNumber != nil && BBUserDefault.token !=nil) {
        [[[NIMSDK sharedSDK] loginManager] login:BBUserDefault.userPhoneNumber token: BBUserDefault.token completion:^(NSError * _Nullable error) {
            NSLog(@"网易云信 --- %@",error);

            NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
            NSLog(@"--------count  ==== %ld  ------",count);

        }];
        [[NTESServiceManager sharedManager] start];
    }
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
    
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
 
    NSLog(@"--------count  ==== %ld  ------",count);
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
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
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
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(BBUserDefault.userPhoneNumber != nil && BBUserDefault.token !=nil) {
                
                NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                
                loginData.account = BBUserDefault.userPhoneNumber;
                
                loginData.token = BBUserDefault.token;
                
                [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                
                [[NTESServiceManager sharedManager] start];
                
            }
            
        }];
        [vc addAction:retryAction];
    }
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
            NSLog(@"%@",error);
            [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        }];
    }];
    [vc addAction:logoutAction];
    
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}
#pragma mark - 注销
-(void)logout:(NSNotification*)note
{
    [self doLogout];
}

- (void)doLogout
{
    [[NTESServiceManager sharedManager] destory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //此处的baedg 的个数应该为总推送的个数
    
    NSInteger count = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
    NSInteger allCouunt = count + _jpsuhCount;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:allCouunt];
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
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
    //极光推送
    [JPUSHService registerDeviceToken:deviceToken];

    //网易云信推送
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    NSString*device = [[[[deviceToken description]stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@" "withString:@""]stringByReplacingOccurrencesOfString:@">"withString:@""];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken:  %@", device);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"receive remote notification:  %@", userInfo);
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);

//    ZFbaseTabbarViewController * tabBar = [[ZFbaseTabbarViewController alloc]initWithNibName:@"NTESSessionListViewController" bundle:nil];
//    [self.window.rootViewController presentViewController:tabBar animated:YES completion:nil];
//    tabBar.selectedIndex = 1;

    [JPUSHService handleRemoteNotification:userInfo];

    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
   
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to get apns token :%@",error);
}
/*
 1.开启后台模式
 2.调用completionHandler,告诉系统你现在是否有新的数据更新
 3.userInfo添加一个字段:"content-available" : "1" : 只要添加了该字段,接受到通知都会在后台运行
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%@", userInfo);
    
    //极光推送
    [JPUSHService handleRemoteNotification:userInfo];
    
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
    NSLog(@"receive payload %@ type %@",payload.dictionaryPayload,type);
    NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
    if ([badge isKindOfClass:[NSNumber class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    }
    
}

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type
{
    NSLog(@"registry %@ invalidate %@",registry,type);
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
     //网易云信注册 APNS
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


#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    _jpsuhCount = [badge integerValue];
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    _jpsuhCount = [badge integerValue];
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法

}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
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


#pragma mark - 检查app更新版本
-(void)CheckUpadateVersion
{

    NSString * appStoreUrl = @"https://itunes.apple.com/us/app/%E5%B1%95%E5%AF%8C%E5%AE%9D/id1291284707?mt=8";
    //网络请求App的信息（我们取Version就够了）
    NSURL *url = [NSURL URLWithString:appStoreUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            //data是有关于App所有的信息
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
                
                //请求的有数据，进行版本比较
                [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
    }];
    
    [task resume];
}
-(void)receiveData:(id)sender
{
    //获取APP自身版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *versionArray = [sender[@"version"] componentsSeparatedByString:@"."];
    
    
    if ((versionArray.count == 3) && (localArray.count == versionArray.count)) {
        
        if ([localArray[0] intValue] <  [versionArray[0] intValue]) {
            [self updateVersion];
        }else if ([localArray[0] intValue]  ==  [versionArray[0] intValue]){
            if ([localArray[1] intValue] <  [versionArray[1] intValue]) {
                [self updateVersion];
            }else if ([localArray[1] intValue] ==  [versionArray[1] intValue]){
                if ([localArray[2] intValue] <  [versionArray[2] intValue]) {
                    [self updateVersion];
                }
            }
        }
    }
}
-(void)updateVersion{

    NSString * appStoreUrl = @"https://itunes.apple.com/us/app/%E5%B1%95%E5%AF%8C%E5%AE%9D/id1291284707?mt=8";
    NSString *msg = [NSString stringWithFormat:@"又出新版本啦，快点更新吧!"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        NSURL *url = [NSURL URLWithString:appStoreUrl];
        [[UIApplication sharedApplication]openURL:url];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - 微信支付的方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url  sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功!";
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                break;
            case -2:
                payResoult = @"用户已经退出支付";
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

@end
