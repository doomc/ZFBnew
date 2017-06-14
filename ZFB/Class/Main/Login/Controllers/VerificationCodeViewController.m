//
//  VerificationCodeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "LoginViewController.h"

@interface VerificationCodeViewController ()<UITextFieldDelegate>
{
    NSString * _smsCode ;
    BOOL _isRegiste;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *tf_loginPassword;
@property (weak, nonatomic) IBOutlet UILabel *lb_VerificationNum;//验证号码  短信验证码已发送到手机号为136 5521 3333
@property (weak, nonatomic) IBOutlet UIButton *regist_btn;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode_btn;//重新发送验证码

@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self set_leftButton];
    self.title =@"注册";
    _isRegiste = NO;
    self.regist_btn.enabled = NO;
    [self.regist_btn addTarget:self action:@selector(regist_btnSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerificationCode_btn addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];


    // 验证码请求
    if ([_phoneNumStr isMobileNumber]) {
       
        self.lb_VerificationNum.text = [NSString stringWithFormat:@" 短信验证码已发送到手机号为 %@",_phoneNumStr];
        [self ValidateCodePostRequset];
    }
    
    [self textFieldSettingDelegate];
}
 
#pragma mark - 获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
   
    if (_tf_verificationCode.text.length > 0) {
       
        [self.view makeToast:@"已经发送过验证码了" duration:2.0 position:@"center"];
        [self.getVerificationCode_btn setEnabled:NO];

    }else{
        
        [self.getVerificationCode_btn setEnabled:YES];
        [self timeCountdown];
    }
}
#pragma mark - UITextFieldDelegate  设置代理
-(void)textFieldSettingDelegate
{
    self.tf_loginPassword.delegate  = self;
    self.tf_verificationCode.delegate = self;
    
    [self.tf_loginPassword addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    [self.tf_verificationCode addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//当文本内容改变时调用
- (void)textChange :(UITextField *)textfiled
{
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf_loginPassword.secureTextEntry = YES;

    if (textfiled == _tf_verificationCode) {
        
        NSLog(@"_tf_verificationCode==%@",_tf_verificationCode.text);
    }
    if (textfiled == _tf_loginPassword) {
        //当账号与密码同时有值,登录按钮才能够点击
        if ((_tf_verificationCode.text.length ==6) && (_tf_loginPassword.text.length >= 8 && _tf_loginPassword.text.length <=20) ) {
            self.regist_btn.enabled = YES;
            self.regist_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            
        }else{
            self.regist_btn.enabled = NO;
            self.regist_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
            
        }
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tf_verificationCode == textField) {
        //判断是不是手机号
        if ( [_tf_verificationCode.text isEqualToString:_smsCode]) {
            
            NSLog(@" 验证码 正确");
            
        }else{
            
            [self.view makeToast:@"验证码输入错误" duration:2.0 position:@"center"];
        }
    }
    if (_tf_loginPassword == textField) {
        
        BBUserDefault.userPhoneNumber = _tf_loginPassword.text;
        
    }
    
}
//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_loginPassword resignFirstResponder];
    [_tf_verificationCode resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

/**
 注册按钮
 
 @param sender 注册后的操作
 */
-(void)regist_btnSuccess:(UIButton*)sender
{
   
    if ([_tf_verificationCode.text isEqualToString:_smsCode] && _tf_loginPassword.text.length >7 &&_tf_loginPassword.text.length < 21 ) {

        [self RegisterPostRequest];
       
    }else{
        
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
 
    }

    
    
}
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

//设置左边事件
-(void)left_button_event:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 倒计时
-(void)timeCountdown{
   
    [dateTimeHelper verificationCode:^{
        //倒计时完毕
        _getVerificationCode_btn.enabled = YES;
        [_getVerificationCode_btn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_getVerificationCode_btn setTitleColor:HEXCOLOR(0xfe6d6a) forState:UIControlStateNormal] ;
        
    } blockNo:^(id time) {
        _getVerificationCode_btn.enabled = NO;
        [_getVerificationCode_btn setTitle:time forState:UIControlStateNormal];
        [_getVerificationCode_btn setTitleColor:HEXCOLOR(0x363636) forState:UIControlStateNormal] ;
    }];

}

#pragma mark - ValidateCodePostRequset验证码网络请求
-(void)ValidateCodePostRequset
{
    [self timeCountdown]; //开始倒计时

    [SVProgressHUD showWithStatus:@"正在发送验证码"];

    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"svcName":@"SendMessages",
                             @"mobilePhone":_phoneNumStr,
                             };
    
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
 
            NSString  * data = [ responseObject[@"data"] base64DecodedString];
            
            NSDictionary * dataDic= [NSString dictionaryWithJsonString:data];
            
            _smsCode = dataDic[@"smsCode"];
       
            _tf_verificationCode.text = _smsCode;

            [self.view makeToast:@"验证码发送成功" duration:2 position:@"center"];

        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        NSLog(@"%@  = error " ,error);
        
        [self.view makeToast:@"验证码中心很忙,稍后重试" duration:2 position:@"center"];
        [SVProgressHUD dismiss];

    }];

}

#pragma mark - RetetPasswordPostRequest注册网络请求
-(void)RegisterPostRequest
{
    [SVProgressHUD showWithStatus:@"请稍后..."];
    
    NSDictionary * parma = @{
                             @"svcName":@"userRegistered",
                             @"mobilePhone":_phoneNumStr,
                             @"loginPwd":_tf_loginPassword.text,
                             @"smsCheckCode":_smsCode,
                             
                             };
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parma responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0" ]) {
       
            BBUserDefault.userPhonePassword = _tf_loginPassword.text;//保存密码
            NSLog(@"%@", BBUserDefault.userPhonePassword );
            _isRegiste = YES;
  
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"103"]) {
            
            NSString * message = responseObject[@"resultMessage"];
            
            [self.view makeToast:[NSString stringWithFormat:@"%@",message] duration:2 position:@"center"];

        }
        if (_isRegiste== YES) {
            
            JXTAlertController *AlertVC =[JXTAlertController alertControllerWithTitle:@"提示信息" message:@"已经注册成功了是否马上去登陆" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * login = [UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }];
            [AlertVC addAction:cancle];
            [AlertVC addAction:login];
            [self presentViewController:AlertVC animated:YES completion:nil];
            
        }

        [SVProgressHUD dismiss];

    } failure:^(NSError *error) {
       
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];

        NSLog(@"%@",error);
        [SVProgressHUD dismiss];

    }];
    
}

@end
