//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"

#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
@interface ZFCInterpersonalCircleViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic ,strong) WKWebView *               webView ;
@property (nonatomic ,strong) WKWebViewJavascriptBridge * bridge  ;
@property(nonatomic,strong)   UITextView  * textView;

@end

@implementation ZFCInterpersonalCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    self.title = @"人际圈";
    

    //用UIWebView加载web
    _webView    = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
//    _webView.allowsBackForwardNavigationGestures = YES;
//    _webView.navigationDelegate = self;
//    [self.view addSubview:_webView];
//    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tmall.com"]]];
//    //    _webView.UIDelegate = self;
//    //    _webView.navigationDelegate = self;
//    _webView.backgroundColor = randomColor;

    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com"];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [_webView loadRequest:request];
    // 将WKWebView添加到视图
    [self.view addSubview:_webView];
    
 
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"showAlert('奏是一个弹框')" completionHandler:^(id item, NSError * _Nullable error) {
        // Block中处理是否通过了或者执行JS错误的代码
    }];

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
