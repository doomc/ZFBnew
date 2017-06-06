//
//  ZYFVerificationCodeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZYFVerificationCodeViewController.h"
#import "LoginViewController.h"
@interface ZYFVerificationCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *tf_loginPassword;
@property (weak, nonatomic) IBOutlet UILabel *lb_VerificationNum;//验证号码  短信验证码已发送到手机号为136 5521 3333

@property (weak, nonatomic) IBOutlet UIButton *regist_btn;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode_btn;//重新发送验证码

@end

@implementation ZYFVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"注册";
    [self.regist_btn addTarget:self action:@selector(regist_btnSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self textFieldSettingDelegate];
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
    
    if (textfiled == _tf_verificationCode) {
        
        
        NSLog(@"_tf_verificationCode==%@",_tf_verificationCode.text);
    }
    if (textfiled == _tf_loginPassword) {
        NSLog(@"_tf_loginPassword==%ld",_tf_loginPassword.text.length);
        
        //当账号与密码同时有值,登录按钮才能够点击
        if ((_tf_verificationCode.text.length >0) && (_tf_loginPassword.text.length >= 8 && _tf_loginPassword.text.length <=20) ) {
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
        if ( [_tf_verificationCode.text isEqualToString:@"123123"]) {
            
            NSLog(@" 验证码 正确");
            
        }else{
     
            [self.view makeToast:@"验证码输入错误" duration:2.0 position:@"center"];
            
        }
        
    }
    if (_tf_loginPassword == textField) {
        
        NSLog(@"密码匹配");
        
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
    if ([_tf_verificationCode.text isEqualToString:@""]) {
        [self.view makeToast:@"验证码为空或者验证码错误" duration:2 position:@"center"];
 
    }if (_tf_loginPassword.text.length <8 &&_tf_loginPassword.text.length>20) {
        
        [self.view makeToast:@"密码格式不正确" duration:2 position:@"center"];
  
    }else{
        [self.view makeToast:@"右上角去登录" duration:2 position:@"center"];

    }
    
    NSLog(@"注册成功调用注册接口");
}

////设置右边按键（如果没有右边 可以不重写）
//-(UIButton*)set_rightButton
//{
//    NSString * saveStr = @"登录";
//    UIButton *right_button = [[UIButton alloc]init];
//    [right_button setTitle:saveStr forState:UIControlStateNormal];
//    right_button.titleLabel.font=SYSTEMFONT(14);
//    [right_button setTitleColor:HEXCOLOR(0xfe6d6a)  forState:UIControlStateNormal];
//    right_button.titleLabel.textAlignment = NSTextAlignmentRight;
//    CGSize size = [saveStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SYSTEMFONT(14),NSFontAttributeName, nil]];
//    CGFloat width = size.width ;
//    right_button.frame =CGRectMake(0, 0, width+10, 22);
//    
//    return right_button;
//}


//设置右边事件
-(void)right_button_event:(id)sender {
    NSLog(@"去登录");
    LoginViewController  * logVC =[LoginViewController new];
    
    [self.navigationController popToViewController:logVC animated:YES];
}


@end
