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
@interface ZFMainPayforViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

 @property (nonatomic,copy ) NSString * paySign;//获取签名

@property (nonatomic ,strong) WKWebView *               webView ;
@property (nonatomic ,strong) WebViewJavascriptBridge * bridge  ;

@property (nonatomic ,copy)  NSString * signString;
@property (nonatomic ,strong) WKNavigation *backNavigation;
@property (nonatomic ,strong) UIProgressView *pressView;

@end

@implementation ZFMainPayforViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeWebCache];//清除缓存
 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _orderjsonString = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";
    
    self.view.backgroundColor = HEXCOLOR(0xffcccc);
    

    
    [self getPaypaySignAccessTokenUrl];
    

}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"NativeMethod"];
    
}
#pragma mark - WKNavigationDelegate
 // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__FUNCTION__);
}

// 内容开始返回时调用(view的过渡动画可在此方法中加载)
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__FUNCTION__);
}
// 页面加载完成时调用(view的过渡动画的移除可在此方法中进行)
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__FUNCTION__);
    

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark WKNavigation 当web视图需要响应身份验证跳转时调用
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler{
}
#pragma mark 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
#pragma mark 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //需执行decisionHandler的block。
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}


#pragma mark - 获取支付paySign值，进行传值到支付参数222222
-(void)getPaypaySignAccessTokenUrl
{
    [SVProgressHUD show];
    NSDictionary * orderdic =[NSString dictionaryWithJsonString:_orderjsonString];//json转字典
    NSArray * orderlist = orderdic[@"orderList"];
    NSString * listJsonString  =[NSString arrayToJSONString:orderlist];
    
#warning -- 此账号为测试时账号  正式时 需要修改成正式账号
    
    NSLog(@"=======%@_access_token",_access_token);
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"123" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:[NSDictionary dictionaryWithDictionary:params]success:^(id response) {
        
        _paySign = response[@"paySign"];
       
        [self getGoodsCostPayResulrUrlL];
 
        [SVProgressHUD dismissWithDelay:3];

    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    [SVProgressHUD dismissWithDelay:2];

}


#pragma mark -  PayResulrUrl支付页面地址
-(void)getGoodsCostPayResulrUrlL
{
    NSDictionary * orderdic =[NSString dictionaryWithJsonString:_orderjsonString];//json转字典
    NSArray * orderlist = orderdic[@"orderList"];
    NSString * listJsonString  =[NSString arrayToJSONString:orderlist];
 
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
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
    
    _webView   = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, KScreenW, KScreenH)];
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    // 将WKWebView添加到视图
    [self.view addSubview:_webView];
    
    //2.根据会话对象创建task   //PayResulrUrl  @"http://192.168.1.188:8080/cashier/gateway.do"
    NSURL *url = [NSURL URLWithString:PayResulrUrl];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  
    //4.修改请求方法为POST
    [request setHTTPMethod:@"POST"];

    //5.设置请求体
    [request setHTTPBody:[_signString dataUsingEncoding:NSUTF8StringEncoding]];

 
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"-===222222222====%@",dict);
        
        NSLog(@"-===33333333====%@",response);
        
        NSLog(@"-===44444444====%@",error);
        
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self.webView loadRequest:request];
        NSLog(@"%@",htmlStr);
//        [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:PayResulrUrl]];
 
    }];
 
    [dataTask resume];
    
}



//清除缓存
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

/** 清理缓存的方法，这个方法会清除缓存类型为HTML类型的文件*/
- (void)clearCache
{
    /* 取得Library文件夹的位置*/
    NSString *libraryDir =NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    
//    HLog(@"路径==%@,fileList%@",webKitFolderInCachesfs,fileList);
    /* 遍历文件组成的数组*/
    for(NSString * fileName in fileList){
        /* 定位每个文件的位置*/
        NSString * path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        /* 将文件转换为NSData类型的数据*/
        NSData * fileData = [NSData dataWithContentsOfFile:path];
        /* 如果FileData的长度大于2，说明FileData不为空*/
        if(fileData.length >2){
            /* 创建两个用于显示文件类型的变量*/
            int char1 =0;
            int char2 =0;
    
            [fileData getBytes:&char1 range:NSMakeRange(0,1)];
            [fileData getBytes:&char2 range:NSMakeRange(1,1)];
            /* 拼接两个变量*/
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            /* 如果该文件前四个字符是6033，说明是Html文件，删除掉本地的缓存*/
            if([numStr isEqualToString:@"6033"]){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs, fileName]error:&error];
                continue;
            }
            
        }
    }
}

@end
