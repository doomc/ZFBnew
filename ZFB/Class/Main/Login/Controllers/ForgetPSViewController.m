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
    
    
}
#pragma mark - 获取验证码
-(void)getVerificationCodeAction:(UIButton *)sender{
    // 网络请求
    [self VerificationCodePostRequest];
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
    resetVc.phoneNum = _tf_phoneNum.text;
    resetVc.Vercode = _tf_codeVerification.text;
    [self.navigationController pushViewController:resetVc animated:YES];
    
}




#pragma marl - VerificationCodePostRequest验证码网络请求
-(void)VerificationCodePostRequest
{
//    NSString * SmsLogo = @"1";
//    NSDate *date = [NSDate date];
//    NSString *DateTime =  [dateTimeHelper htcTimeToLocationStr: date];
//    
//    //通用MD5_KEY
//    NSString * transactionTime = DateTime;//当前时间
//    NSString * transactionId = DateTime; //每个用户唯一
//    NSLog(@"%@",DateTime);
//    NSString * tempStr =  @"";
//    NSString * jsonStr = [tempStr convertToJsonData:@{
//                                                           @"mobilePhone":_tf_phoneNum.text,
//                                                           @"SmsLogo":SmsLogo,
//                                                           }];
//    NSString * data = [NSString base64:jsonStr];
//    NSDictionary * params2 = @{
//                               //@"userId":@"",
//                               @"signType":@"MD5",
//                               @"transactionTime":transactionTime,
//                               @"transactionId":transactionId,
//                               @"svcName":@"forgetPassword",
//                               @"data":data,
//                               };
//    
//    ZFEncryptionKey  * keydic = [ZFEncryptionKey new];
//    NSString * sign = [keydic signStringWithParam:params2];
//    
//    NSDictionary * param =  @{
//                              
//                              @"data":data,//base64
//                              @"sign":sign,//签名
//                              @"transactionTime":transactionTime,
//                              @"transactionId":transactionId,
//                              @"signType":@"MD5",
//                              @"svcName":@"forgetPassword",
//                              };
//    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:param responseCache:^(id responseCache) {
//        
//    } success:^(id responseObject) {
//        NSLog(@"拿到验证码code%@",responseObject);
//        NSString  * data = [ responseObject[@"data"] base64DecodedString];
//        
//        NSDictionary * dataDic= [NSString dictionaryWithJsonString:data];
//        
//        _smsCode = dataDic[@"smsCode"];
//        
//        NSLog(@"%@" , _smsCode);
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@  = error " ,error);
//        
//    }];
//    
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
