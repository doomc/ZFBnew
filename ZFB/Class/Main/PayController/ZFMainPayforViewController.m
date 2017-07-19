//
//  ZFMainPayforViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  支付页面

#import "ZFMainPayforViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ZFMainPayforViewController ()<UIWebViewDelegate>

@property(nonatomic ,strong)UIWebView *webView ;
@property(nonatomic ,strong)WebViewJavascriptBridge * bridge ;


@end

@implementation ZFMainPayforViewController
-(void)viewWillAppear:(BOOL)animated
{
    //用UIWebView加载web
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;

    //设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    // 初始化*WebViewJavascriptBridge*实例,设置代理,进行桥接
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
  
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";
    
    
}
//-(UIWebView *)webView
//{
//    if (!_webView) {
//        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH)];
//        _webView.delegate = self;
//        
//    }
//    return _webView;
//}


#pragma mark -  getGoodsCostInfo 用户订单确定费用信息接口
-(void)getGoodsCostInfoListPostRequst
{
    
    NSDictionary * parma = @{
                             
                             @"goodsCostList":@"",//集合
                             
                             };
    
    [MBProgressHUD showProgressToView:nil Text:@"加载中..."];
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/getGoodsCostInfo",zfb_baseUrl] params:parma success:^(id response) {
        
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].delegate.window animated:YES];
 
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
        NSLog(@"progeress=====%@",progeress);
        
    } failure:^(NSError *error) {
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
}


@end
