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
    [self set_rightButton];
    self.title =@"注册";
    self.regist_btn.enabled = NO;
    [self.regist_btn addTarget:self action:@selector(regist_btnSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerificationCode_btn addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];

    [self textFieldSettingDelegate];
}
 
#pragma mark - 获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
    if ([_phoneNumStr isMobileNumber]) {
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
        [self.view makeToast:@"手机号不正确" duration:2 position:@"center"];

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
        
        NSLog(@" 设置密码 ");
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
    if (_tf_verificationCode.text.length == 6 && _tf_loginPassword.text.length >7 &&_tf_loginPassword.text.length < 21 ) {
        
         [self RegisterPostRequest];
        
    }else{
       
        [self.view makeToast:@"验证码错误密码格式不正确" duration:2 position:@"center"];
    }
   
    
    NSLog(@"注册成功调用注册接口");
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

//设置右边事件
-(void)left_button_event:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//设置右边按键（如果没有右边 可以不重写）
-(UIButton*)set_rightButton
{
    NSString * saveStr = @"登录";
    UIButton *right_button = [[UIButton alloc]init];
    [right_button setTitle:saveStr forState:UIControlStateNormal];
    right_button.titleLabel.font=SYSTEMFONT(14);
    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
    CGFloat width = size.width ;
    right_button.frame =CGRectMake(0, 0, width+10, 22);

    return right_button;
}

//设置右边事件
-(void)right_button_event:(id)sender {
    NSLog(@"去登录");
    LoginViewController  * logVC =[LoginViewController new];
    [self.navigationController popToViewController:logVC animated:YES];
}


#pragma mark - ValidateCodePostRequset验证码网络请求
-(void)ValidateCodePostRequset
{
    [SVProgressHUD showInfoWithStatus:@"hold on ~~"];
    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"svcName":@"SendMessages",
                             @"mobilePhone":_tf_loginPassword.text,
                             };
    
    
    NSDictionary *parmaDic=[NSDictionary dictionaryWithDictionary:parma];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parmaDic responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSString  * data = [ responseObject[@"data"] base64DecodedString];
            NSDictionary * dataDic= [NSString dictionaryWithJsonString:data];
            _smsCode = dataDic[@"smsCode"];
            _tf_verificationCode.text = _smsCode;
   
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@  = error " ,error);
        
    }];
}

#pragma mark - RetetPasswordPostRequest注册网络请求
-(void)RegisterPostRequest
{
    [SVProgressHUD showProgress:2 status:@"hold on ~~"];
    
    NSDictionary * parma = @{
                             @"svcName":@"userRegistered",
                             @"mobilePhone":_phoneNumStr,
                             @"loginPwd":_tf_loginPassword.text,
                             @"smsCheckCode":_smsCode,
                             
                             };
    
    
    [SVProgressHUD  showProgress:2];
    
    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parma responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"responseObject"] isEqualToString:@"0" ]) {
            
            [self.view makeToast:@"注册成功！✔️" duration:2 position:@"center"];
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"103"]) {
            
            NSString * message = responseObject[@"resultMessage"];
  
            [self.view makeToast:message duration:2 position:@"center"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    [SVProgressHUD dismiss];
    
}

@end
