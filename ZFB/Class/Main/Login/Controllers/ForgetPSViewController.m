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
    [self.nextStep_btn addTarget:self action:@selector(goToResetPageView:) forControlEvents:UIControlEventTouchUpInside];
    [self textFieldSettingDelegate];
    
    
}
- (IBAction)backAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        if (_tf_phoneNum.text.length == 11 && _tf_codeVerification.text.length == 6 ) {
           
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
        
        NSLog(@"验证码 ----- 不匹配");
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

/**
   下一步

 @param sender 重置密码下一步
 */
- (void)goToResetPageView:(id)sender {

    ResetPassWViewController * resetVc= [[ResetPassWViewController alloc]init];
    [self.navigationController pushViewController:resetVc animated:YES];
    
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
