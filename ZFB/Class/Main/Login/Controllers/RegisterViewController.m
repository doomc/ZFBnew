//
//  RegisterViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZYFVerificationCodeViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

{
    BOOL _isChoose;
}

@property (weak, nonatomic) IBOutlet UIButton *nextTarget_btn;
@property (weak, nonatomic) IBOutlet UIButton *choose_btn;//s_Selected  s_normal
@property (nonatomic ,strong) UIButton * selectButton;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"注册";
    _isChoose = NO;
 
    
    self.nextTarget_btn.enabled = NO;
    
    self.tf_phoneNum.delegate = self;
    
    [self.nextTarget_btn addTarget:self action:@selector(goToRegisterAcount:) forControlEvents:UIControlEventTouchUpInside];
    [self.tf_phoneNum addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    
    [self didSelectedProtocol:self.choose_btn];
    
}


#pragma  mark - UITextFieldDelegate
- (void)textChange :(UITextField *)textfiled
{
    _tf_phoneNum.text = textfiled.text;
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //判断是不是手机号
    if ( [_tf_phoneNum.text isMobileNumber]) {
        
        NSLog(@"格式正确");
        
    }else{
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
    
     if (_tf_phoneNum.text.length == 11  &&  _isChoose == YES)
     {
         ZYFVerificationCodeViewController * verificationVC = [[ZYFVerificationCodeViewController alloc]init];
         [self.navigationController pushViewController:verificationVC animated:YES];

     }else{
         [self.view makeToast:@"手机格式错误或者未同意展富宝用户协议" duration:2.0 position:@"center"];
     }
}

/**
 服务协议
 
 @param sender push到协议
 */
- (IBAction)serviceProtocol_btn:(id)sender {
    
    
}



/**
 同意协议
 
 @param sender 不同意 button状态改变灰色
 */
- (IBAction)didSelectedProtocol:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
    
        _isChoose = YES;
        [self.choose_btn setImage:[UIImage imageNamed:@"s_Selected"] forState:UIControlStateNormal];
        
        if (_isChoose == YES && _tf_phoneNum.text.length == 11) {
            
            _nextTarget_btn.enabled = YES;
            _nextTarget_btn.backgroundColor = HEXCOLOR(0xfe6d6a);

        }
       
        
    }else{
        _isChoose = NO;
        sender.selected=NO;
        _nextTarget_btn.enabled = NO;
        _nextTarget_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
        [self.choose_btn setImage:[UIImage imageNamed:@"s_normal"] forState:UIControlStateNormal];
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
