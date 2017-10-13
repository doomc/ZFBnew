//
//  QRCodeSaoyiSaoViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/8/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "QRCodeSaoyiSaoViewController.h"
#import "SGQRCode.h"
#import "QRCodeScanSuccessViewController.h"
//#import "ZFMainPayforViewController.h"
#import "CheckstandViewController.h"

@interface QRCodeSaoyiSaoViewController ()<SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
{
    NSString * _notify_url ;//回调url
    NSString * _orderAmount ;//订单金额
    NSString * _paySign ;
    NSString * _datetime;
}
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) NSArray *orderListArray;

@end

@implementation QRCodeSaoyiSaoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    
    [self setupNavigationBar];
    [self setupQRCodeScanning];
    
    _orderListArray = [NSArray array];
    NSDate * date = [NSDate date];
    _datetime     = [dateTimeHelper timehelpFormatter: date];//2017-07-20 17:08:54
    
    
}
- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)rightBarButtonItenAction {
    
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager SG_readQRCodeFromAlbumWithCurrentController:self];
    
    manager.delegate = self;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        BOOL isPHAuthorization = manager.isPHAuthorization;
        if (isPHAuthorization == YES) {
            [self removeScanningView];
        }
    });
}
//初始化扫描
- (void)setupQRCodeScanning {
 
    SGQRCodeScanManager *manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    manager.delegate = self;
}


#pragma mark - - - SGQRCodeAlbumManagerDelegate 扫描相册
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    
    [self.view addSubview:self.scanningView];
}
//扫描成功跳转
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    
    //type
    NSString * type = [result substringToIndex:1];//字符串开始
    NSLog(@"type ==== %@",type);
   
    //verificationKey
    NSRange  range  = [result rangeOfString:@"á"];
    result = [result substringFromIndex:range.length+1];
    NSLog(@"result:%@",result);
    [self creatPayMoneyQRcodePostType:type verificationKey:result];
    
    //判断是条形码 还是 二维码
    if ([result hasPrefix:@"http"]) {
        QRCodeScanSuccessViewController *jumpVC = [[QRCodeScanSuccessViewController alloc] init];
        jumpVC.jump_URL = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
        
    } else {
        QRCodeScanSuccessViewController *jumpVC = [[QRCodeScanSuccessViewController alloc] init];
        jumpVC.jump_bar_code = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }


}

#pragma mark - - - SGQRCodeScanManagerDelegate  扫描当前
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager SG_palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager SG_stopRunning];
        [scanManager SG_videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString * verificationKey = [obj stringValue];
        
        NSLog(@"verificationKey ===== %@",verificationKey);
        NSRange  range  = [verificationKey rangeOfString:@"á"];
        //type
        NSString * type = [verificationKey substringToIndex:1];//字符串开始
        NSLog(@"type ==== %@",type);
        
        NSString * afterVerificationKey = [verificationKey substringFromIndex:range.length+1];
        [self creatPayMoneyQRcodePostType:type verificationKey:afterVerificationKey];
        
        //如果需要下一级就这里跳转
//        QRCodeScanSuccessViewController *jumpVC = [[QRCodeScanSuccessViewController alloc] init];
//        jumpVC.jump_URL = verificationKey;
        
    } else {
        NSLog(@"暂未识别出扫描的二维码");
        JXTAlertController * alertVC = [JXTAlertController alertControllerWithTitle:@"暂未识别出扫描的二维码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sure];
        [alertVC presentViewController:alertVC animated:YES completion:nil];
        
    }
}


#pragma mark  -  QRCode/verificationUserQRcode校验用户二维码接口

-(void)creatPayMoneyQRcodePostType:(NSString *)type verificationKey:(NSString *)verificationKey
{
    NSDictionary * param  = @{
                              @"qrCodeType":type,
                              @"verificationKey":verificationKey,///二维码唯一标示
                              @"userKeyMd5":BBUserDefault.userKeyMd5,
                              };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/verificationUserQRcode",zfb_baseUrl] params:param success:^(id response) {
        
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ( [code isEqualToString:@"0"]) {

            _orderAmount = [NSString stringWithFormat:@"%@",response[@"pay_money"]];
            _orderListArray = response[@"result"];

            [self getPaypaySignWithNotify_url:response[@"thirdURI"][@"notify_url"] return_url:response[@"thirdURI"][@"return_url"] datetime:_datetime];
        }
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 获取支付paySign值
-(void)getPaypaySignWithNotify_url:(NSString *)notify_url return_url:(NSString *)return_url datetime :(NSString *)datetime
{
    NSLog(@"orderListArray === %@",_orderListArray);
    
    [SVProgressHUD show];
    NSString * listJsonString  =  [NSString arrayToJSONString:_orderListArray];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/order/paySign",zfb_baseUrl] params:[NSDictionary dictionaryWithDictionary:params] success:^(id response) {
        
        _paySign = response[@"paySign"];
        [SVProgressHUD dismissWithCompletion:^{
            
            [self getGoodsCostPayResulrUrlNotify_url :notify_url return_url:return_url datetime:datetime];
        }];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


#pragma mark -  PayResulrUrl支付页面地址
-(void)getGoodsCostPayResulrUrlNotify_url:(NSString *)notify_url return_url:(NSString *)return_url datetime :(NSString *)datetime
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSString * listJsonString  = [NSString arrayToJSONString:_orderListArray];
    [params setValue:_paySign forKey:@"sign"];//回传参数：商户可自定义该参数，在支付回调后带回
    [params setValue:BBUserDefault.userPhoneNumber forKey:@"account"];
    [params setValue:datetime forKey:@"datetime"];//yyyy-MM-dd HH:mm:ss（北京时间）
    [params setValue:notify_url forKey:@"notify_url"];//异步通知地址（用于接收订单支付通知）
    [params setValue:return_url forKey:@"return_url"];//同步通知地址（支付成功后的跳转）
    [params setValue:listJsonString forKey:@"order_list"];//Json格式的订单字符集
    [params setValue:@"" forKey:@"passback_params"];//回传参数：商户可自定义该参数，在支付回调后带回
    NSDictionary * dic  = [NSDictionary dictionaryWithDictionary:params];
    
    CheckstandViewController * payVC = [CheckstandViewController new];
    payVC.amount = _orderAmount;
    payVC.notifyUrl = notify_url;
    payVC.signDic = dic;
    [self.navigationController pushViewController:payVC animated:NO];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
