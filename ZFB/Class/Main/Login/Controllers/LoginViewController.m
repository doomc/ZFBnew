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

typedef NS_ENUM(NSUInteger, indexType) {
    
    quickLoginIndexType = 0,//快捷登录
    passwordLoginIndexType,//密码登录
    
};
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL _isQuickLogin;
    
    NSString * _smsCode;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl * loginSegment;
//手机号
@property (weak, nonatomic) IBOutlet UITextField * tf_loginphone;
//验证码 或者 密码
@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCodeOrPassWord;
@property (weak, nonatomic) IBOutlet UIImageView *img_iconOfVerificationOrPs;

@property (weak, nonatomic) IBOutlet UIButton *login_btn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeVerification_btn;

@property (assign,nonatomic) indexType  indexType;

@property (nonatomic, strong) Reachability * rech;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    BBUserDefault.isLogin = 0;
    _isQuickLogin = YES;//默认为快速登录
    _indexType = quickLoginIndexType; //默认为快速登录
    self.login_btn.enabled = NO; //默认关闭用户登录
    [self initSegmentInterfaceAndTextfiled];//设置segement
    [self textFieldSettingDelegate];//代理
    [self.getCodeVerification_btn addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self set_leftButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.rech = [Reachability reachabilityForInternetConnection];
    [self.rech startNotifier];
    
}
- (void)dealloc
{
    [self.rech stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)networkStateChange
{
    [self checkNetworkState];
 
}
- (void)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        
    } else { // 没有网络
        
        NSLog(@"没有网络");
    }
}
#pragma mark - setter方法
-(UIButton*)set_leftButton
{
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"navback_white"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(left_button_event) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    return left_button;
}

//设置右边事件
-(void)left_button_event{
    
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:^{
         
    }];
}

#pragma mark - getVerificationCodeAction获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
    if ([_tf_loginphone.text isMobileNumberClassification]) {
        // 网络请求
        [self ValidateCodePostRequset];
        [dateTimeHelper verificationCode:^{
            //倒计时完毕
            sender.enabled = YES;
            [sender setTitle:@"重新发送" forState:UIControlStateNormal];
            [sender setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal] ;
            
        } blockNo:^(id time) {
            sender.enabled = NO;
            [sender setTitle:time forState:UIControlStateNormal];
            [sender setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal] ;
        }];
        
    }else{
        
        JXTAlertController * alert =  [JXTAlertController alertControllerWithTitle:nil message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * action  =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
}

#pragma mark -initSegmentInterfaceAndTextfiled 初始化segement
-(void)initSegmentInterfaceAndTextfiled
{
    
    self.navigationItem.title = @"登录展富宝";
    self.loginSegment.selectedSegmentIndex = 0;
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
    
    if (_isQuickLogin == YES) {
        
        _tf_verificationCodeOrPassWord.secureTextEntry = NO;
        
        if (textfiled == _tf_verificationCodeOrPassWord) {
            
            //当账号与密码同时有值,登录按钮才能够点击
            if ( _tf_verificationCodeOrPassWord.text.length > 0) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
            NSLog(@"验证码手机号%@ ",_tf_loginphone.text );

        }
    }
    if (_isQuickLogin == NO) {
        
        _tf_verificationCodeOrPassWord.secureTextEntry = YES;
        
        if (_tf_verificationCodeOrPassWord == textfiled) {
            
            //当账号与密码同时有值,登录按钮才能够点击
            if ( _tf_verificationCodeOrPassWord.text.length > 0) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
            
            NSLog(@"登录--账号+密码 = %@",_tf_verificationCodeOrPassWord.text);
        }
        
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_isQuickLogin == YES ) {
        if (_tf_loginphone == textField) {
         
            //判断是不是手机号

            if ( [_tf_loginphone.text isMobileNumberClassification]) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];

            }

        }
        if (_tf_verificationCodeOrPassWord == textField) {
            
            if ( [_tf_loginphone.text isMobileNumberClassification] && _tf_verificationCodeOrPassWord.text.length > 0) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
            NSLog(@"快捷登录--验证码 匹配正确  = %@",_smsCode);
            
        }
        
    }else if (_isQuickLogin == NO){
        
        if (_tf_loginphone == textField) {
            //判断是不是手机号
            if ( [_tf_loginphone.text isMobileNumberClassification]) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];
                
            }
        }
        if (_tf_verificationCodeOrPassWord == textField) {
            if ( [_tf_loginphone.text isMobileNumberClassification] && _tf_verificationCodeOrPassWord.text.length > 0) {
               
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);

            }
            NSLog(@"登录--账号+密码2 %@",textField );
            
        }
    }
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    
    return YES;
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

#pragma  mark  - 分段控制器
-(void)LoginSegmentchange:(UISegmentedControl *)segment
{
    _tf_verificationCodeOrPassWord.text = nil;
    
    _indexType  =  segment.selectedSegmentIndex;
    switch (_indexType) {
        case quickLoginIndexType:
            NSLog(@"快捷登录");
            _isQuickLogin = YES;
            _tf_verificationCodeOrPassWord.placeholder = @"请输入短信验证码";
            _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"message"];
            _getCodeVerification_btn.hidden = NO;
            
            break;
            
        case passwordLoginIndexType:
            NSLog(@"密码登录");
            _isQuickLogin = NO;
            _getCodeVerification_btn.hidden = YES;
            _tf_verificationCodeOrPassWord.placeholder = @"请输入登录密码";
            _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"passWord"];
            
            break;
    }
}


#pragma mark - login_Success 点击登录
- (void)login_Success:(UIButton *)sender {
    
    if (_isQuickLogin == YES) {//快捷登录
        
        [self QuickLoginPostRequest];
        
    }else{
        
        [self PasswordLoginPostRequest];
        
    }
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


#pragma mark - ValidateCodePostRequset验证码网络请求
-(void)ValidateCodePostRequset
{
    [SVProgressHUD show];
    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"mobilePhone":_tf_loginphone.text,
                             @"cmUserId":@"",
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/SendMessages",zfb_baseUrl] params:parma success:^(id response) {
        if ([response[@"resultCode"] intValue ] == 0) {
            
            _smsCode = response[@"smsCode" ];
            _tf_verificationCodeOrPassWord.text = _smsCode;
            
            self.login_btn.enabled = YES;
            self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            
        }

        [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    
}

#pragma mark -  QuickLoginPostRequest 快速登录
-(void)QuickLoginPostRequest
{
 
    [SVProgressHUD show ];
    NSDictionary * parma = @{
                             
                             @"mobilePhone":_tf_loginphone.text,
                             @"smsCheckCode":_smsCode,
                             @"cmUserId":@"",
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/quickLogin",zfb_baseUrl] params:parma success:^(id response) {
 
        if ([response[@"resultCode"] intValue ] == 0) {
            BBUserDefault.isLogin = 1;
            
            BBUserDefault.cmUserId = response[@"userInfo"][@"cmUserId"];
            BBUserDefault.nickName = response[@"userInfo"][@"nickName"];
            BBUserDefault.userPhoneNumber = _tf_loginphone.text;
            BBUserDefault.userKeyMd5  = response[@"userInfo"][@"userKeyMd5"];
            BBUserDefault.token = response[@"userInfo"][@"token"];
            BBUserDefault.accid = response[@"userInfo"][@"accid"];

            NSLog(@" ======= signMD5Key=======%@", BBUserDefault.userKeyMd5 );
            
            [self left_button_event];
        }

        [self.view makeToast:response[@"resultMsg"]   duration:2 position:@"center"];
        
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        
    }];
    [SVProgressHUD dismiss];

}

#pragma mark -  PasswordLoginPostRequest 密码登录
-(void)PasswordLoginPostRequest{
    //测试
    NSDictionary * parma = @{
                             
                             @"mobilePhone":_tf_loginphone.text,
                             @"loginPwd":_tf_verificationCodeOrPassWord.text,
                             @"cmUserId":@"",
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/login",zfb_baseUrl] params:parma success:^(id response) {
        
        NSLog(@"response ===== %@",response);
 
        if ([response[@"resultCode"] intValue ] == 0) {
            //设置全局变量
            BBUserDefault.isLogin = 1;
            BBUserDefault.userKeyMd5  = response[@"userInfo"][@"userKeyMd5"];
            BBUserDefault.cmUserId = response[@"userInfo"][@"cmUserId"];
            BBUserDefault.nickName = response[@"userInfo"][@"nickName"];
            BBUserDefault.userPhoneNumber = _tf_loginphone.text;
            BBUserDefault.token = response[@"userInfo"][@"token"];
            BBUserDefault.accid = response[@"userInfo"][@"accid"];
            [self left_button_event];
    
        }
        NSLog(@" ======= userKeyMd5=======%@",BBUserDefault.userKeyMd5 );
        [self.view makeToast:response [@"resultMsg"] duration:2 position:@"center"];
        
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];

    }];
   

}


@end
