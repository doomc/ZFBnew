//
//  RegisterViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerificationCodeViewController.h"
#import "UserProtocolViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *nextTarget_btn;
@property (weak, nonatomic) IBOutlet UIButton *choose_btn;//s_Selected  s_normal
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"注册";
    [self set_leftButton];
    self.choose_btn.selected = NO;
    self.tf_phoneNum.delegate = self;
    
    [self.nextTarget_btn addTarget:self action:@selector(goToRegisterAcount:) forControlEvents:UIControlEventTouchUpInside];
    [self.tf_phoneNum addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];

    [self didSelectedProtocol:self.choose_btn];
    
}


#pragma  mark - UITextFieldDelegate
- (void)textChange :(UITextField *)textfiled
{
    _tf_phoneNum.text = textfiled.text;

    if ([_tf_phoneNum.text isMobileNumberClassification]) {
        
        _nextTarget_btn.enabled = YES;
       
        _nextTarget_btn.backgroundColor = HEXCOLOR(0xfe6d6a);

    }else{
        _nextTarget_btn.enabled = NO;
        _nextTarget_btn.backgroundColor = HEXCOLOR(0xa7a7a7);

    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //判断是不是手机号
    if ( [_tf_phoneNum.text isMobileNumberClassification] && _choose_btn.selected == YES) {
        
        _nextTarget_btn.enabled = YES;
        _nextTarget_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
        
    }else{
        _nextTarget_btn.enabled = NO;
        [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];
        
    }
 
}

//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_phoneNum resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

/**
 注册 下一步
 @param sender 立即去注册
 */
- (void)goToRegisterAcount:(UIButton *)sender {
    
    if ([_tf_phoneNum.text isMobileNumberClassification])
    {
        VerificationCodeViewController * verificationVC = [[VerificationCodeViewController alloc]init];
        verificationVC.phoneNumStr = _tf_phoneNum.text;
        [self.navigationController pushViewController:verificationVC animated:YES];
        
    }else{
        [self.view makeToast:@"手机格式错误或者未同意展富宝用户协议" duration:2.0 position:@"center"];
    }
}


/**
 同意协议
 
 @param sender 选择按钮 button状态改变灰色
 */
- (IBAction)didSelectedProtocol:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
       
        if ([_tf_phoneNum.text isMobileNumberClassification]) {
            _nextTarget_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            _nextTarget_btn.enabled = YES;
        }
        
    }else{
        _choose_btn.selected = NO;
        self.nextTarget_btn.enabled = NO;
        _nextTarget_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
        
    }
}

/**
 服务协议
 
 @param sender push到协议
 */
- (IBAction)serviceProtocol_btn:(id)sender {
    
    NSLog(@"服务协议");
    UserProtocolViewController * userVC = [UserProtocolViewController new];
    [self.navigationController pushViewController:userVC animated:NO];
    
}

-(UIButton*)set_leftButton
{
    
    UIButton *left_button = [UIButton buttonWithType:UIButtonTypeCustom];
    left_button.frame =CGRectMake(0, 0,22,22);
    [left_button setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button addTarget:self action:@selector(left_button_event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left_button];
    self.navigationItem.leftBarButtonItem = leftItem;
    return left_button;
}

//设置右边事件
-(void)left_button_event:(UIButton *)sender{
    
    if (_mark == YES) {
     
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
      
        [self.navigationController popViewControllerAnimated:YES];
    }
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
