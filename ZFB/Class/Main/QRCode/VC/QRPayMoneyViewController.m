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
{
    NSString * _QRCode;
    
}

@end
@implementation QRPayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"付款";
    
    [self creatPayMoneyQRcodePost];

}
///历史记录
- (IBAction)didClickPayMoneyHistory:(id)sender {
    
    QRCollectHistoryViewController * VC =[[ QRCollectHistoryViewController alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
    
}
#pragma mark - - - 生成付款二维码
-(void)interfaceOfRQcodeView
{
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:_QRCode options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.sacnCodeView.image = [UIImage imageWithData:imageData];
    
    self.sacnCodeView.contentMode = UIViewContentModeScaleAspectFit;
}


#pragma mark  -    QRCode/generateAllKindsQRCode 生成付款二维码
-(void)creatPayMoneyQRcodePost
{
    NSDictionary * param  = @{
                              @"qrCodeType":@"2",///0 订单二维码 1 收款二维码 2 付款二维码
                              @"account":BBUserDefault.userPhoneNumber,///当qrCodeType不等于0的时候 此时必须传该值
                            };
    [SVProgressHUD show];
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/generateAllKindsQRCode",zfb_baseUrl] params:param success:^(id response) {
       
        if ([response[@"resultCode"] intValue] == 0) {
           
            _QRCode = response[@"result"][@"QRCode"];
            
            [self interfaceOfRQcodeView];
        }
       
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {

        [SVProgressHUD dismiss];

    }];
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
