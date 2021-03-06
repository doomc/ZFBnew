//
//  VerificatePayPassWordViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  确认支付密码

#import "VerificatePayPassWordViewController.h"
#import "TPPasswordTextView.h"

@interface VerificatePayPassWordViewController ()
{
    NSMutableString * currentPassword ;
}
@end
@implementation VerificatePayPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认支付密码";
    
    TPPasswordTextView * paView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(30, 20, KScreenW - 60, 44)];
    paView.elementCount = 6;
    paView.elementMargin = 5;
    paView.elementBorderColor = HEXCOLOR(0x333333);

    [self.view addSubview:paView];
    
    paView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        
        if (password.length == 6) {
            currentPassword  = [NSMutableString stringWithFormat:@"%@",password];
            if ([_checkPassword isEqualToString:currentPassword]) {
                NSLog(@"成功  --可以调 接口");
                [self commitPasswordPostRequset];
                
            }else{
                [self.view makeToast:@"2次密码不匹配,请核对后重新输入" duration:2 position:@"center"];
            }
        }
    };
    
    UILabel * tag = [[UILabel alloc]init];
    tag.text = @"请确认支付密码";
    tag.numberOfLines = 0 ;
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = HEXCOLOR(0x363636);
    tag.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tag];
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(60);
        make.right.equalTo(self.view).with.offset(-60);
        make.top.equalTo(paView).with.offset(60);
    }];
    
}

#pragma mark - 提交密码 请求
-(void)commitPasswordPostRequset
{
    NSDictionary * param = @{
                             @"payPassword":currentPassword,
                             @"account":BBUserDefault.userPhoneNumber,
                             
                             };
    
    [SVProgressHUD show];
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/sitePayPassword"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] intValue] == 0) {
            JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"支付密码设置成功!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self poptoUIViewControllerNibName:@"SettingPayPasswordViewController" AndObjectIndex:1];
            }];
            
            [alertvc addAction:sure];
            [self presentViewController:alertvc animated:YES completion:^{
                
            }];
            
        }
        [SVProgressHUD dismiss];
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
