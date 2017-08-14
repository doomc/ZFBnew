//
//  QRPayMoneyViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/14.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  付款


#import "QRPayMoneyViewController.h"
#import "SGQRCode.h"
#import "QRCollectHistoryViewController.h"
@interface QRPayMoneyViewController ()


@end

@implementation QRPayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"付款";
    // 生成二维码(中间带有图标)
    [self setupGenerate_Icon_QRCode];
}
///历史记录
- (IBAction)didClickPayMoneyHistory:(id)sender {
    
    QRCollectHistoryViewController * VC =[[ QRCollectHistoryViewController alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
    
}
#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    
    // 1、借助UIImageView显示二维码
    CGFloat scale = 0.2;
    
    // 2、将最终合得的图片显示在UIImageView上
    self.sacnCodeView.image = [SGQRCodeGenerateManager SG_generateWithLogoQRCodeData:@"https://github.com/kingsic" logoImageName:@"logo" logoScaleToSuperView:scale];
    
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
