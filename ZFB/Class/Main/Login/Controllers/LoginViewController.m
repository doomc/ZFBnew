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
{
    
    BOOL _isQuickLogin;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl * loginSegment;
//手机号
@property (weak, nonatomic) IBOutlet UITextField * tf_loginphone;
//验证码 或者 密码
@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCodeOrPassWord;
@property (weak, nonatomic) IBOutlet UIImageView *img_iconOfVerificationOrPs;

@property (weak, nonatomic) IBOutlet UIButton *login_btn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    
    [self initSegmentInterfaceAndTextfiled];
    [self textFieldSettingDelegate];
    

}


/**
 初始化segement
 */
-(void)initSegmentInterfaceAndTextfiled
{
    
    _isQuickLogin = YES;//默认为快捷登录
    self.navigationItem.title = @"登录展富宝";
    [self.loginSegment addTarget:self action:@selector(LoginSegmentchange:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x363636),NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    _loginSegment.layer.masksToBounds = YES;
    _loginSegment.layer.borderWidth =1.0;
    _loginSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    [_loginSegment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [_login_btn addTarget:self action:@selector(login_Success:) forControlEvents:UIControlEventTouchUpInside];

    
}



#pragma mark - UITextFieldDelegate  设置代理
-(void)textFieldSettingDelegate
{
    self.tf_loginphone.delegate  = self;
    self.tf_verificationCodeOrPassWord.delegate = self;
    
    [self.tf_loginphone addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    [self.tf_verificationCodeOrPassWord addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

}

//当文本内容改变时调用
- (void)textChange :(UITextField *)textfiled
{
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;

    if (textfiled == _tf_loginphone) {
      

         NSLog(@"_tf_loginphone==%@",_tf_loginphone.text);
    }
    if (textfiled == _tf_verificationCodeOrPassWord) {
        NSLog(@"tf_verificationCodeOrPassWord==%@",_tf_verificationCodeOrPassWord.text);
        
        //当账号与密码同时有值,登录按钮才能够点击
        self.login_btn.enabled = _tf_loginphone.text.length && _tf_verificationCodeOrPassWord.text.length;
        if (self.login_btn.enabled == YES) {
            self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
 
        }else{
            self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);

        }
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tf_loginphone == textField) {
        //判断是不是手机号
        if ( [_tf_loginphone.text isMobileNumber]) {
      
            NSLog(@"请求发送验证码");

        }else{
            NSLog(@"弹框操作");
            [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];

        }
  
        NSLog(@"第1行end");
    }
    if (_tf_verificationCodeOrPassWord == textField) {
        if (_isQuickLogin == YES) {
            NSLog(@"验证 验证码");
        }else{
            
          //  [_tf_verificationCodeOrPassWord.text  isEqualToString:@""];
            NSLog(@"验证 密码");
 
        }
    }
}
//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_loginphone resignFirstResponder];
    [_tf_verificationCodeOrPassWord resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
/**
 快速登录
 
 @param segment  分段控制器
 */
-(void)LoginSegmentchange:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        
        NSLog(@"快捷登录");
        _isQuickLogin = YES;
        
        _tf_verificationCodeOrPassWord.placeholder = @"请输入短信验证码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"message"];
        
        
    }
    else{
        NSLog(@"密码登录");
        _isQuickLogin = NO;
        
        _tf_verificationCodeOrPassWord.placeholder = @"请输入登录密码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"passWord"];
        
    }
}



/**
    登录

 @param sender 点击登录
 */
- (void)login_Success:(UIButton *)sender {
#warning -----  不走 poptoView 方法为什么？

    //方法一
  //  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    //方法2：
   // [self  popToViewControllerWithName:@"ZFPersonalViewController"];
    
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
