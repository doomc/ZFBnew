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
    BOOL _isLogin;
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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _isQuickLogin = YES;//默认为快速登录
    _indexType = quickLoginIndexType; //默认为快速登录
    self.login_btn.enabled = NO; //默认关闭用户登录
    [self initSegmentInterfaceAndTextfiled];//设置segement
    [self textFieldSettingDelegate];//代理
    [self.getCodeVerification_btn addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];

    [self set_leftButton];
    
 

    
}
#pragma mark - setter方法
-(UIButton*)set_leftButton
{
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"navback_white"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(left_button_event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    return left_button;
}

//设置右边事件
-(void)left_button_event:(UIButton *)sender{

//    [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark - getVerificationCodeAction获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
    if ([_tf_loginphone.text isMobileNumber]) {
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
        [WJYAlertView showOneButtonWithTitle:@"提示信息" Message:@"请输入手机号" ButtonType:WJYAlertViewButtonTypeNone ButtonTitle:@"知道了" Click:^{
            
        }];
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
            if ( [_tf_loginphone.text isMobileNumber] && _tf_verificationCodeOrPassWord.text.length == 6) {
                self.login_btn.enabled = YES;
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.enabled = NO;
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
        }
        NSLog(@"验证码j手机号%@ ",_tf_loginphone.text );
    }
    if (_isQuickLogin == NO) {
       
        _tf_verificationCodeOrPassWord.secureTextEntry = YES;
        
        if (_tf_verificationCodeOrPassWord == textfiled) {
            
            //当账号与密码同时有值,登录按钮才能够点击
            if ( [_tf_loginphone.text isMobileNumber] && _tf_verificationCodeOrPassWord.text.length > 0) {
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
            if ( [_tf_loginphone.text isMobileNumber]) {

                BBUserDefault.userPhoneNumber = _tf_loginphone.text;
                
            }else{
               
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];

            }
        }
        if (_tf_verificationCodeOrPassWord == textField) {
            
            if ( [_tf_loginphone.text isMobileNumber] && _tf_verificationCodeOrPassWord.text.length == 6) {
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
            if ( [_tf_loginphone.text isMobileNumber]) {
                
                NSLog(@"自动请求发送验证码");
                
            }else{
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];
                
            }
        }
        if (_tf_verificationCodeOrPassWord == textField) {
            if ( [_tf_loginphone.text isMobileNumber] && _tf_verificationCodeOrPassWord.text.length > 7) {
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
    
    NSLog(@"%@",BBUserDefault.cmUserId);

    if (_isQuickLogin == YES) {//快捷登录
        
        [self QuickLoginPostRequest];
       
        if ( BBUserDefault.isLogin == YES) {
            
            [self.view makeToast:@"快速登录成功" duration:2 position:@"center" ];
            NSLog(@"跳转到指定页面");
            [self left_button_event:sender];
        }
        NSLog(@"快速-登录成功");
        

    }else{
        [self PasswordLoginPostRequest];

        if ( BBUserDefault.isLogin == YES) {//密码登录
   
            if ([_tf_verificationCodeOrPassWord.text isEqualToString: BBUserDefault.userPhonePassword]) {
                
            [self left_button_event:sender];
                NSLog(@"跳转到指定页面");

            }else{
            
                [self.view makeToast:@"密码输入错误" duration:2 position:@"center" ];
            }
        }
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
    [SVProgressHUD showInfoWithStatus:@"hold on ~~"];

    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"mobilePhone":_tf_loginphone.text,
                             };
    
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:[zfb_baseUrl stringByAppendingString:@"/SendMessages"] parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {

        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSString  * data = [ responseObject[@"data"] base64DecodedString];
            NSDictionary * dataDic= [NSString dictionaryWithJsonString:data];
            _smsCode = dataDic[@"smsCode"];
            _tf_verificationCodeOrPassWord.text = _smsCode;
            self.login_btn.enabled = YES;
            self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@  = error " ,error);

    }];
}

#pragma mark -  QuickLoginPostRequest 快速登录
-(void)QuickLoginPostRequest
{
    
    [SVProgressHUD showWithStatus:@"登录中"];
    NSDictionary * parma = @{
                             
                            @"mobilePhone":_tf_loginphone.text,
                            @"smsCheckCode":_smsCode,
                            };
   
 
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:[zfb_baseUrl stringByAppendingString:@"/quickLogin"] parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        NSLog(@"  %@  = responseObject  " ,responseObject);
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
        
            _isLogin = YES;
            BBUserDefault.isLogin = _isLogin;
            BBUserDefault.userPhoneNumber =_tf_loginphone.text;
            [self.view makeToast:responseObject[@"resultMessage"]   duration:2 position:@"center"];
 
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        NSLog(@"%@  = error " ,error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];

        
    }];


}

#pragma mark -  PasswordLoginPostRequest 密码登录
-(void)PasswordLoginPostRequest{
    
    //测试
    [SVProgressHUD showWithStatus:@"登陆中"];
    NSDictionary * parma = @{
                             
                             @"mobilePhone":_tf_loginphone.text,
                             @"loginPwd":_tf_verificationCodeOrPassWord.text,
//                             @"svcName":@"",
//                             @"cmUserId":BBUserDefault.cmUserId,

                             };
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:[zfb_baseUrl stringByAppendingString:@"/login"] parameters:parmaDic success:^(id responseObject) {
        
        NSLog(@"  %@  = responseObject  " ,responseObject);
//        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
//            
//            _isLogin = YES;
//            [self.view makeToast:@"登录成功" duration:2 position:@"center" ];
//            
//            NSString  * dataStr= [responseObject[@"data"] base64DecodedString];
//            NSDictionary * dic = [NSString dictionaryWithJsonString:dataStr];
//            BBUserDefault.isLogin = _isLogin;
//            BBUserDefault.userPhoneNumber = _tf_loginphone.text;
//            BBUserDefault.cmUserId = dic[@"userInfo"][@"cmUserId"];
//            BBUserDefault.nickName = dic[@"userInfo"][@"nickName"];
//            BBUserDefault.userKeyMd5 = dic[@"userInfo"][@"userKeyMd5"];//QSXQBXDIJIKNGOO6
//            BBUserDefault.userStatus = dic[@"userInfo"][@"userStatus"];
//            
//            NSLog(@"dic= %@ ",dic[@"userInfo"][@"cmUserId"]);
//    
//        }
        [self.view makeToast:responseObject[@"resultMessage"]   duration:2 position:@"center"];

 
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    }];

   
}
@end
