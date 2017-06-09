//
//  ZFCInterpersonalCircleViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****人际圈

#import "ZFCInterpersonalCircleViewController.h"


static NSString *const dataUrl = @"http://api.budejie.com/api/api_open.php";
static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";


@interface ZFCInterpersonalCircleViewController ()
@property(nonatomic,strong)   UITextView  * textView;

@end

@implementation ZFCInterpersonalCircleViewController
-(UITextView *)textView
{
    if (!_textView) {
        _textView =[[UITextView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    self.title = @"人际圈";
    
    UIButton *  uploadbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:uploadbtn];
    uploadbtn.frame = CGRectMake(100, 100, 100, 100);
    uploadbtn.backgroundColor = [UIColor redColor];
    [uploadbtn
     addTarget:self action:@selector(uploadaaaaa) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:self.textView];
//
//    // 开启日志打印
//    [PPNetworkHelper openLog];
//    
//    // 获取网络缓存大小
//    PPLog(@"网络缓存大小cache = %fKB",[PPNetworkCache getAllHttpCacheSize]/1024.f);
//    
//    // 清理缓存 [PPNetworkCache removeAllHttpCache];
//    
//    // 实时监测网络状态
//    [self monitorNetworkStatus];
//    
//    /*
//     * 一次性获取当前网络状态
//     这里延时0.1s再执行是因为程序刚刚启动,可能相关的网络服务还没有初始化完成(也有可能是AFN的BUG),
//     导致此demo检测的网络状态不正确,这仅仅只是为了演示demo的功能性, 在实际使用中可直接使用一次性网络判断,不用延时
//     */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getCurrentNetworkStatus];
//    });
//    
//    [self getData:YES url:dataUrl];

}
-(void)uploadaaaaa{
       
}
//- (void)PPHTTPRequestLayerDemo
//{
//    // 登陆
//    [PPHTTPRequest getLoginWithParameters:@"参数" success:^(id response) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//    // 退出
//    [PPHTTPRequest getExitWithParameters:@"参数" success:^(id response) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//}


#pragma mark - 实时监测网络状态
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                // 无网络
            case PPNetworkStatusNotReachable:
                self.textView.text = @"没有网络";
                [self getData:YES url:dataUrl];

                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
 
                PPLog(@"有网络,请求网络数据");
                break;
        }
        
    }];
    
}

#pragma mark - 一次性获取当前最新网络状态
- (void)getCurrentNetworkStatus
{
    if (kIsNetwork) {
        PPLog(@"有网络");
        if (kIsWWANNetwork) {
            PPLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            PPLog(@"WiFi网络");
        }
    } else {
        PPLog(@"无网络");
    }
    // 或
    //    if ([PPNetworkHelper isNetwork]) {
    //        PPLog(@"有网络");
    //        if ([PPNetworkHelper isWWANNetwork]) {
    //            PPLog(@"手机网络");
    //        }else if ([PPNetworkHelper isWiFiNetwork]){
    //            PPLog(@"WiFi网络");
    //        }
    //    } else {
    //        PPLog(@"无网络");
    //    }
}

/**
 *  json转字符串
 */
- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)getData:(BOOL)isOn url:(NSString *)url
{
    
    NSDictionary *para = @{ @"a":@"list", @"c":@"data",@"client":@"iphone",@"page":@"0",@"per":@"10", @"type":@"29"};
   
    // 无缓存
    
    [PPNetworkHelper GET:url parameters:para success:^(id responseObject) {
        //请求成功
        self.textView.text = [self jsonToString:responseObject];

    } failure:^(NSError *error) {
        //请求失败
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
