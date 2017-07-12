//
//  ForgetPSViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ForgetPSViewController.h"
#import "ResetPassWViewController.h"

@interface ForgetPSViewController ()<UITextFieldDelegate>
{
    NSString * _smsCode ;
}
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *tf_codeVerification;
@property (weak, nonatomic) IBOutlet UIButton *getCodeVerification_btn;
@property (weak, nonatomic) IBOutlet UIButton *nextStep_btn;

@end

@implementation ForgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"找回密码";
    
    self.nextStep_btn.enabled = NO;
    
    [self.nextStep_btn addTarget:self action:@selector(goToResetPageView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.getCodeVerification_btn addTarget:self action:@selector(getVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self textFieldSettingDelegate];
    
    [self set_leftButton];
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
#pragma mark - 获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
    
    if ([_tf_phoneNum.text isMobileNumber]) {
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
        
    }
    else{
        [self.view makeToast:@"请输入手机号格式不正确" duration:2.0 position:@"center"];
        
    }
    
}
#pragma mark - UITextFieldDelegate  设置代理
-(void)textFieldSettingDelegate
{
    self.tf_phoneNum.delegate  = self;
    self.tf_codeVerification.delegate = self;
    
    [self.tf_phoneNum addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    [self.tf_codeVerification addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//当文本内容改变时调用
- (void)textChange :(UITextField *)textfiled
{
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (textfiled == _tf_phoneNum) {
        
        NSLog(@"_tf_phoneNum==%@",_tf_phoneNum.text);
    }
    if (textfiled == _tf_codeVerification) {
        NSLog(@"tf_codeVerification==%ld",_tf_codeVerification.text.length);
        
        //当账号与密码同时有值,登录按钮才能够点击
        if ([_tf_phoneNum.text  isMobileNumber] && _tf_codeVerification.text.length > 0 ) {
            
            self.nextStep_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            self.nextStep_btn.enabled = YES;
            
        }else{
            self.nextStep_btn.enabled = NO;
            self.nextStep_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
            
        }
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_tf_phoneNum == textField) {
        //判断是不是手机号
        if ( [_tf_phoneNum.text isMobileNumber]) {
            
            NSLog(@" 正确");
            
        }else{
            
            [self.view makeToast:@"手机格式错误" duration:2.0 position:@"center"];
        }
    }
    if (_tf_codeVerification == textField) {
        if ([_tf_phoneNum.text  isMobileNumber] && _tf_codeVerification.text.length == 6 ) {
            
            self.nextStep_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            self.nextStep_btn.enabled = YES;
            
        }else{
            self.nextStep_btn.enabled = NO;
            self.nextStep_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
            
        }
        NSLog(@"提示 ----- 提示");
    }
    
}
//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_codeVerification resignFirstResponder];
    [_tf_phoneNum resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}


#pragma mark - goToResetPageView 重置密码下一步
- (void)goToResetPageView:(id)sender {
    
    if (![self.tf_codeVerification.text isEqualToString:_smsCode]) {
        
        JXTAlertController * alert =  [JXTAlertController alertControllerWithTitle:nil message:@"验证码输入错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction  * action  =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {   }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:NO completion:nil];
        
    }else{
        
        ResetPassWViewController * resetVc= [[ResetPassWViewController alloc]init];
        resetVc.phoneNum = _tf_phoneNum.text;
        resetVc.Vercode = _smsCode;
        [self.navigationController pushViewController:resetVc animated:YES];
    }
    
}




#pragma mark - ValidateCodePostRequset验证码网络请求
-(void)ValidateCodePostRequset
{
    [SVProgressHUD show ];
    
    NSDictionary * parma = @{
                             @"SmsLogo":@"1",
                             @"svcName":@"",
                             @"mobilePhone":_tf_phoneNum.text,
                             //                             @"userId":@"",
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/SendMessages",zfb_baseUrl] params:parma success:^(id response) {
        
        NSLog(@"response ===== %@",response);
        
        
        _smsCode =  response[@"smsCode"];
        NSLog(@"_smsCode ===== %@",_smsCode);
        _tf_codeVerification.text = _smsCode;
        self.nextStep_btn.enabled = YES;
        self.nextStep_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        
        [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        
        
        [SVProgressHUD dismiss];
        
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
