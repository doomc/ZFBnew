//
//  VerificatePayPassWordViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  确认支付密码

#import "VerificatePayPassWordViewController.h"
#import "TPPasswordTextView.h"
#import "VerificatePayPassWordViewController.h"
@interface VerificatePayPassWordViewController ()
{
    NSMutableString * newPassword ;
}
@end

@implementation VerificatePayPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认支付密码";
    
    TPPasswordTextView * paView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake(0, 50, KScreenW - 60, 44)];
    paView.elementCount = 6;
    CGPoint center = self.view.center;
    paView.center = CGPointMake(center.x, 120);
    paView.elementBorderColor = HEXCOLOR(0xfe6d6a);
    paView.elementMargin = 5;
    [self.view addSubview:paView];
    
    paView.passwordDidChangeBlock = ^(NSString *password) {
        NSLog(@"%@",password);
        
        if (password.length == 6) {
            newPassword  = [NSMutableString stringWithFormat:@"%@",password];
            if ([self checkPassWordIsNotEasy:newPassword] && [_checkPassword isEqualToString:newPassword]) {
                NSLog(@"成功  --可以调 接口");
                [self checkCommitAction];
                
            }else{
                [self.view makeToast:@"确认密码错误,请核对后重新输入" duration:2 position:@"center"];
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
    
    
    UIButton * next_btn =[ UIButton buttonWithType:UIButtonTypeCustom];
    [next_btn setTitle:@"完成" forState:UIControlStateNormal];
    next_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    next_btn.backgroundColor = RGBA(254,109,106,1);
    next_btn.layer.cornerRadius = 5;
    next_btn.clipsToBounds = YES;
    [next_btn addTarget:self action:@selector(checkCommitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next_btn];
    
    [next_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
        make.top.equalTo(tag).with.offset(50);
        make.height.mas_equalTo(44);
    }];
    
}

#pragma mark - 确认提交
-(void)checkCommitAction
{
    [self commitPasswordPostRequset];
}
#pragma mark - 提交密码 请求
-(void)commitPasswordPostRequset
{
    
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
