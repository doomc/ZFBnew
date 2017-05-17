//
//  LoginViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPSViewController.h"
#import "ZFPersonalViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl * loginSegment;
//手机号
@property (weak, nonatomic) IBOutlet UITextField * tf_loginphone;
//验证码 或者 密码
@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCodeOrPassWord;
@property (weak, nonatomic) IBOutlet UIImageView *img_iconOfVerificationOrPs;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSegmentInterfaceAndTextfiled];

}

/**
   初始化segement
 */
-(void)initSegmentInterfaceAndTextfiled
{
    self.navigationItem.title = @"登录展富宝";
    [self.loginSegment addTarget:self action:@selector(LoginSegmentchange:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x363636),NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];

    _loginSegment.layer.masksToBounds = YES;
    _loginSegment.layer.borderWidth =1.0;
    _loginSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    [_loginSegment setTitleTextAttributes:dic forState:UIControlStateNormal];

    //  self.LoginSegment.tintColor = HEXCOLOR(0x363636);

    
    _tf_loginphone.delegate= self;
    _tf_verificationCodeOrPassWord.delegate = self;
    
}
/**
 快速登录
 
 @param segment  分段控制器
 */
-(void)LoginSegmentchange:(UISegmentedControl *)segment
{
   
    if (segment.selectedSegmentIndex == 0) {
  
        NSLog(@"快捷登录");
        _tf_verificationCodeOrPassWord.placeholder = @"请输入短信验证码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@""];
        
        
    }
    else{
        NSLog(@"密码登录");
        _tf_verificationCodeOrPassWord.placeholder = @"请输入登录密码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@""];
        
    }
}





/**
    登录

 @param sender 点击登录
 */
- (IBAction)login_Success:(UIButton *)sender {
#warning -----  不走 poptoView 方法为什么？

    //方法一
  //  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    //方法2：
    [self  popToViewControllerWithName:@"ZFPersonalViewController"];
    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        
//        if ([controller isKindOfClass:[ZFPersonalViewController class]]) {
//            
//            [self.navigationController popToViewController:controller animated:YES];
//            
//        }
//        
//    }
 
    NSLog(@"登录成功");
    
}



/**
 忘记密码

 @param sender push到忘记密码页面
 */
- (IBAction)forgot_PassWord:(id)sender {
    
    
    ForgetPSViewController * forgetVC =[[ForgetPSViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

/**
 去注册

 @param sender push到注册页面
 */
- (IBAction)goto_Regist:(id)sender {
    
    RegisterViewController * regVC =[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
    
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
