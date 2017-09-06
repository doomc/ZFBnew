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
#import "ZFDetailOrderViewController.h"
#import "ZFAllOrderViewController.h"
#import "ZFBaseNavigationViewController.h"
@interface ZFMainPayforViewController ()<UIWebViewDelegate>

@property (nonatomic,copy ) NSString * paySign;//获取签名

//@property (nonatomic ,strong) WKWebView *               wkwebView ;
@property (nonatomic ,strong) UIWebView *               webView ;
@property (nonatomic ,strong) WebViewJavascriptBridge * bridge   ;

@property (nonatomic ,copy  ) NSString       *signString;
@property (nonatomic ,strong) UIProgressView *pressView;
@property (nonatomic ,strong) NSDictionary *  payDic;

@end

@implementation ZFMainPayforViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"收银台";
    [self clearCache];//清除缓存
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ( [self.webView isLoading] ) {
        
        [self.webView stopLoading];
    }
    self.webView.delegate = nil;
    // disconnect the delegate as the webview is hidden
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _orderListArray = nil;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HEXCOLOR(0xffcccc);
    
    [self getPaypaySignAccessTokenUrl];
    
    [self.view addSubview:self.webView];
    
}


-(UIWebView *)webView
{
    if (!_webView ) {
        _webView                 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, KScreenW, KScreenH)];
        _webView.delegate        = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scalesPageToFit = YES;
        
    }
    return _webView;
}
//代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    /**返回YES，进行加载。通过UIWebViewNavigationType可以得到请求发起的原因
     如果为webView添加了delegate对象并实现该接口，那么在webView加载任何一个frame之前都会delegate对象的该方法，该方法的返回值用以控制是否允许加载目标链接页面的内容，返回YES将直接加载内容，NO则反之。并且UIWebViewNavigationType枚举，定义了页面中用户行为的分类，包括
     
     UIWebViewNavigationTypeLinkClicked，用户触击了一个链接。
     UIWebViewNavigationTypeFormSubmitted，用户提交了一个表单。
     UIWebViewNavigationTypeBackForward，用户触击前进或返回按钮。
     UIWebViewNavigationTypeReload，用户触击重新加载的按钮。
     UIWebViewNavigationTypeFormResubmitted，用户重复提交表单
     UIWebViewNavigationTypeOther，发生其它行为。
     */
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载，可以加上风火轮（也叫菊花）
    [SVProgressHUD show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //完成加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString * backUrl = @"http://192.168.1.115:8080/cashier_zavfpay/standard/goback.html";//返回地址
    NSString * currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    if ([backUrl isEqualToString:currentURL]) {
        
        NSLog(@"全部跳转到订单列表");
        ZFAllOrderViewController * allVC  = [[ZFAllOrderViewController alloc]init];
 
        ZFBaseNavigationViewController * nav = [[ZFBaseNavigationViewController alloc]initWithRootViewController:allVC];
        [self presentViewController:nav animated:NO completion:^{
            
            [nav.navigationBar setBarTintColor:HEXCOLOR(0xffcccc)];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xffffff),NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
        }];
    }
    [SVProgressHUD dismiss];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"加载失败了");

    //加载出错
    [SVProgressHUD dismiss];
    
}




#pragma mark - 获取支付paySign值，进行传值到支付参数222222
-(void)getPaypaySignAccessTokenUrl
{
    [SVProgressHUD show];
    NSString * listJsonString  =  [NSString arrayToJSONString:_orderListArray];
    listJsonString = [listJsonString stringByReplacingOccurrencesOfString:@"\\"withString:@""];
#warning -- 此账号为测试时账号  正式时 需要修改成正式账号
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:[NSDictionary dictionaryWithDictionary:params] success:^(id response) {
        
        _paySign = response[@"paySign"];

        [SVProgressHUD dismissWithCompletion:^{
           
            [self getGoodsCostPayResulrUrlL];

        }];
        
    } progress:^(NSProgress *progeress) {
        
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


#pragma mark -  PayResulrUrl支付页面地址
-(void)getGoodsCostPayResulrUrlL
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
   
    NSString * listJsonString  =[NSString arrayToJSONString:_orderListArray];
    listJsonString=[listJsonString stringByReplacingOccurrencesOfString:@"\\"withString:@""];
    
    [params setValue:_paySign forKey:@"sign"];//回传参数：商户可自定义该参数，在支付回调后带回
    [params setValue:_access_token forKey:@"access_token"];
    [params setValue:@"18602343931" forKey:@"account"];
    [params setValue:_datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:_notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:_return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    NSDictionary * dic  = [NSDictionary dictionaryWithDictionary:params];
    NSArray *keyArray  = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
    
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
    
    _signString = [NSString stringWithFormat:@"%@", [signArray componentsJoinedByString:@"&"]];
    NSLog(@"_signString========%@",_signString);

    //5.设置请求体
    NSString * texturl = @"http://192.168.1.188:8080/cashier/gateway.do";//_gateWay_url
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:texturl]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [_signString dataUsingEncoding: NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    
}

/** 清理缓存的方法，这个方法会清除缓存类型为HTML类型的文件*/
- (void)clearCache
{
    /* 取得Library文件夹的位置*/
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList          = [[NSArray alloc] init];
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
            int char1 = 0;
            int char2 = 0;
            
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
