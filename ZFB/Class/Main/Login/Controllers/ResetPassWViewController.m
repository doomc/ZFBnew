//
//  ResetPassWViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/16.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ResetPassWViewController.h"
#import "LoginViewController.h"
@interface ResetPassWViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_newPS;
@property (weak, nonatomic) IBOutlet UITextField *tf_surePS;
@property (weak, nonatomic) IBOutlet UIButton    *complete_btn;

@end

@implementation ResetPassWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"重置密码";
    self.complete_btn.enabled = NO;
    
    [self set_leftButton];
    [self textFieldSettingDelegate];
}

#pragma mark - UITextFieldDelegate  设置代理
-(void)textFieldSettingDelegate
{
    self.tf_newPS.delegate  = self;
    self.tf_surePS.delegate = self;
    
    [self.tf_newPS addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    [self.tf_surePS addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//当文本内容改变时调用
- (void)textChange :(UITextField *)textfiled
{
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfiled.secureTextEntry = YES;

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tf_surePS) {
        
        BBUserDefault.newPassWord = _tf_surePS.text;
        
    }
    if (textField == _tf_newPS) {
        
        if (_tf_newPS.text.length < 20 && _tf_newPS.text.length > 8 ) {
            NSLog(@"_tf_newPS==%@",_tf_newPS.text);
        }
        
        [self.view makeToast:@"密码格式不对" duration:2 position:@"center"];
        
    }
    if (textField == _tf_surePS) {
        NSLog(@"_tf_surePS==%@",_tf_surePS.text);
        
        //当账号与密码同时有值,登录按钮才能够点击
        if ( _tf_surePS.text.length > 0  && (_tf_newPS.text.length >= 8 && _tf_newPS.text.length <=20) ) {
            
            self.complete_btn.enabled         = YES;
            self.complete_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            
        }
        else{
            self.complete_btn.enabled         = NO;
            self.complete_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
        }
    }
}
//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_surePS resignFirstResponder];
    [_tf_newPS resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
-(UIButton*)set_leftButton
{
    
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame     = CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(left_button_event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem             = [[UIBarButtonItem alloc]initWithCustomView:left_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    return left_button;
}

//设置z边事件
-(void)left_button_event:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//确认重置密码
- (IBAction)sureReset_btn:(id)sender {
    
    if (! [_tf_newPS.text isEqualToString:_tf_surePS.text ]) {
        
        [self.view makeToast:@"2次输入的密码不匹配" duration:2 position:@"center"];
        
        
    }else{
        NSLog(@"重置成功了");
        [self RetetPasswordPostRequest];
        
    }
    
}


#pragma mark - RetetPasswordPostRequest注册网络请求
-(void)RetetPasswordPostRequest
{
    
    
    NSDictionary * parma = @{

                             @"mobilePhone":_phoneNum,
                             @"newPassword":_tf_surePS.text,
                             @"smsCheckCode":_Vercode,
                             
                             };
    
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/forgetPassword",zfb_baseUrl] params:parma success:^(id response) {
        NSString * code = [NSString stringWithFormat:@"%@",response[@"resultCode"]]        ;
        if ([code isEqualToString:@"0"]) {
            [self.view makeToast:response[@"resultMsg"] duration:2 position:@"center"];
            BBUserDefault.userPhonePassword = _tf_surePS.text;//保存密码
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    } progress:^(NSProgress *progeress) {
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
    
    
    
}

@end
