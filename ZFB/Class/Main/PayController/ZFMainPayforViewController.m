//
//  ZFMainPayforViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  支付页面

#import "ZFMainPayforViewController.h"
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>
@interface ZFMainPayforViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,copy ) NSString * access_token;//获取token
@property (nonatomic,copy ) NSString * paySign;//获取签名
@property (nonatomic,copy)  NSString * datetime;

@property (nonatomic ,strong) WKWebView *               webView ;
@property (nonatomic ,strong) WebViewJavascriptBridge * bridge  ;
@property (nonatomic ,copy) NSString * signString;

@end

@implementation ZFMainPayforViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self removeWebCache];//清除缓存
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";
    
    //用UIWebView加载web
    _webView    = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, KScreenW, KScreenH)];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
 
    _webView.backgroundColor = randomColor;
    
    //设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    
    // 初始化*WebViewJavascriptBridge*实例,设置代理,进行桥接
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    [self getPayAccessTokenUrl];
}


#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
     [self getPayAccessTokenUrl];//获取token
    
    NSLog(@"didStartProvisionalNavigation");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"22222222");
    NSLog(@"didCommitNavigation");

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"33333333");
    NSLog(@"didFinishNavigation");

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"444444444");
    
}


#pragma mark - 获取支付accessToken值，通过accessToken值获取支付签名
-(void)getPayAccessTokenUrl
{
#warning -- 此账号为测试时账号  正式时 需要修改成正式账号
    NSDictionary * param = @{
                             
                             @"account": @"18602343931",
                             @"pass"   : @"123456",
                            
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/getPayAccessToken",zfb_baseUrl] params:param success:^(id response) {
        
        NSDate * date = [NSDate date];
        _datetime =  [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54
        _access_token = response[@"accessToken"];
        
        NSLog(@"=======%@_access_token",_access_token);
        [self getPaypaySignAccessTokenUrl];
    
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


#pragma mark - 获取支付paySign值，进行传值到支付参数
-(void)getPaypaySignAccessTokenUrl
{
    NSArray * orderlist = _orderListdic[@"orderList"];
    
#warning -- 此账号为测试时账号  正式时 需要修改成正式账号
    
    NSLog(@"=======%@_access_token",_access_token);
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:orderlist forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"123" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:[NSDictionary dictionaryWithDictionary:params]success:^(id response) {
        
        _paySign = response[@"paySign"];
                       
        [self getGoodsCostPayResulrUrlL];
        

 
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


#pragma mark -  PayResulrUrl支付页面地址
-(void)getGoodsCostPayResulrUrlL
{
 
    NSArray * orderlist = _orderListdic[@"orderList"];

    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:orderlist forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    [params setValue:_paySign forKey:@"sign"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    
    NSArray *keyArray = [[NSDictionary dictionaryWithDictionary:params] allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                          {
                              return [obj1 compare:obj2 options:NSNumericSearch];
                          }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        
        [valueArray addObject:[params objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        
        [signArray addObject:keyValueStr];
        
    }
    
    _signString =[NSString stringWithFormat:@"%@",[signArray componentsJoinedByString:@"&"]];
    
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PayResulrUrl]];
    
 
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
  
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PayResulrUrl]]];

    
    //5.设置请求体
    request.HTTPBody = [_signString dataUsingEncoding:NSUTF8StringEncoding];
    
//     request.HTTPBody =  [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
 
}



- (void)removeWebCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes= [NSSet setWithArray:@[
                                                       WKWebsiteDataTypeDiskCache,
                                                       //WKWebsiteDataTypeOfflineWebApplication
                                                       WKWebsiteDataTypeMemoryCache,
                                                       //WKWebsiteDataTypeLocal
                                                       WKWebsiteDataTypeCookies,
                                                       //WKWebsiteDataTypeSessionStorage,
                                                       //WKWebsiteDataTypeIndexedDBDatabases,
                                                       //WKWebsiteDataTypeWebSQLDatabases
                                                       ]];
        
        // All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    } else {
        //先删除cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

@end
