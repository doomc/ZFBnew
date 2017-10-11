//
//  SettingPayPasswordViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  设置支付密码

#import "SettingPayPasswordViewController.h"
#import "TPPasswordTextView.h"
#import "VerificatePayPassWordViewController.h"
@interface SettingPayPasswordViewController ()
{
    NSMutableString * newPassword ;
}
@end

@implementation SettingPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置支付密码";
    
    TPPasswordTextView * paView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(0, 50, KScreenW - 60, 44)];
    paView.elementCount = 6;
    CGPoint center = self.view.center;
    paView.center = CGPointMake(center.x, 120);
    paView.elementBorderColor = [UIColor grayColor];
    paView.elementMargin = 5;
    [self.view addSubview:paView];
    
    paView.passwordDidChangeBlock = ^(NSString *password) {
        if (password.length == 6) {
            newPassword  = [NSMutableString stringWithFormat:@"%@",password];
            if ([self checkPassWordIsNotEasy:newPassword]) {
                NSLog(@"密码排除校验通过了！");
            }else{
                [self.view makeToast:@"您的支付密码太过简单" duration:2 position:@"center"];
            }
        }
    };
    
    UILabel * tag = [[UILabel alloc]init];
    tag.text = @"六位密码数字不能完全相同,按顺序升序或降序；如666666,123456,654321等";
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
    
    
    UIButton * next_btn =[ UIButton buttonWithType:UIButtonTypeCustom];
    [next_btn setTitle:@"下一步" forState:UIControlStateNormal];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    next_btn.backgroundColor = RGBA(254,109,106,1);
    [next_btn addTarget:self action:@selector(didclickCheck:) forControlEvents:UIControlEventTouchUpInside];
    next_btn.layer.cornerRadius = 5;
    next_btn.clipsToBounds = YES;
    [self.view addSubview:next_btn];

    [next_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(tag).with.offset(50);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 进入下一页 验证验证密码
-(void)didclickCheck:(UIButton *)sender
{
    if ([self checkPassWordIsNotEasy:newPassword]) {
        
        VerificatePayPassWordViewController * vc = [VerificatePayPassWordViewController new];
        vc.checkPassword = newPassword;
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        
        [self.view makeToast:@"您的支付密码太过简单" duration:2 position:@"center"];
    }
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
