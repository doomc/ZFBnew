//
//  ChangePasswordViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  修改支付密码

#import "ChangePasswordViewController.h"
#import "TPPasswordTextView.h"
#import "FindPayPassWordViewController.h"

@interface ChangePasswordViewController ()

@property (nonatomic , strong)   TPPasswordTextView * paView;
@property (nonatomic , copy  )   NSMutableString * mutPassword ;
@property (nonatomic , copy  )   NSMutableString * oldPassword ;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改支付密码";
    
    self.paView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(0, 0, KScreenW - 60, 44)];
    self.paView.elementCount = 6;
    CGPoint center = self.view.center;
    self.paView.center = CGPointMake(center.x, 120);
    self.paView.elementBorderColor = [UIColor grayColor];
    self.paView.elementMargin = 5;
    [self.view addSubview:self.paView];

    
    __weak typeof(self)weakself = self;
    self.paView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        
        if (password.length == 6) {
            weakself.mutPassword  = [NSMutableString stringWithFormat:@"%@",password];
            if ([weakself checkPassWordIsNotEasy:weakself.mutPassword]  ) {//&& [weakself.mutPassword isEqualToString:BBUserDefault.oldPayPassWord]
                NSLog(@"成功  --可以调 接口");
                [weakself checkOutPasswordPostRequst];
             
            }else{
                JXTAlertController * alertvc = [JXTAlertController alertControllerWithTitle:@"支付密码不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * forget = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    FindPayPassWordViewController * findVC = [FindPayPassWordViewController alloc];
                    [weakself.navigationController pushViewController:findVC animated:NO];
                    
                }];
                UIAlertAction * refix= [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.paView clearPassword];//清空

                }];
                
                [alertvc addAction:forget];
                [alertvc addAction:refix];
                [weakself presentViewController:alertvc animated:YES completion:^{
                    
                }];
                
            }
        }
    };
    
    UILabel * tag = [[UILabel alloc]init];
    tag.text = @"请输入原有密码已验证身份";
    tag.numberOfLines = 0 ;
    tag.textAlignment = NSTextAlignmentCenter;
    tag.textColor = HEXCOLOR(0x363636);
    tag.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tag];
    
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.view).with.offset(60);
        make.right.equalTo(weakself.view).with.offset(-60);
        make.top.equalTo(weakself.paView).with.offset(60);
    }];
    
}

#pragma mark - 验证支付密码
-(void)checkOutPasswordPostRequst
{
    NSDictionary * param = @{
                             @"payPassword":_mutPassword,
                             @"account":BBUserDefault.userPhoneNumber,
                             
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/validatePayPassword"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0" ]) {

            [self updatePasswordPostRequst];
        }
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];

    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    

}

#pragma mark - 用于更新支付密码接口
-(void)updatePasswordPostRequst
{
    NSDictionary * param = @{
                             
                             @"payPassword":_mutPassword,
                             @"oldPayPassword":_mutPassword,
                             @"account":BBUserDefault.userPhoneNumber,
                             
                             };
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/updatePayPassword"] params:param success:^(id response) {
        
        if ([response[@"resultCode"] isEqualToString:@"0" ]) {
            
            FindPayPassWordViewController * findVC= [[ FindPayPassWordViewController alloc]init];
            [self.navigationController pushViewController:findVC animated:NO];
        }
        [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
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
