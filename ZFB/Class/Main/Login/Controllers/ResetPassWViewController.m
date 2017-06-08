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
@property (weak, nonatomic) IBOutlet UIButton *complete_btn;

@end

@implementation ResetPassWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"重置密码";
    self.complete_btn.enabled = NO;
 

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
    if (textfiled == _tf_newPS) {
        
        if (_tf_newPS.text.length < 20 && _tf_newPS.text.length > 8 ) {
            NSLog(@"_tf_newPS==%@",_tf_newPS.text);
        }
        [self.view makeToast:@"输入密码格式不正确" duration:2.0 position:@"center"];
    }
    if (textfiled == _tf_surePS) {
        NSLog(@"_tf_surePS==%@",_tf_surePS.text);
        
        //当账号与密码同时有值,登录按钮才能够点击
        if ([_tf_surePS.text isEqualToString:_tf_newPS.text] && (_tf_newPS.text.length >= 8 && _tf_newPS.text.length <=20) ) {
          
            self.complete_btn.enabled = YES;
            self.complete_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
            
        }
        else{
            self.complete_btn.enabled = NO;
            self.complete_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _tf_surePS) {
      
        BBUserDefault.newPassWord = _tf_surePS.text;
        
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

//确认重置密码
- (IBAction)sureReset_btn:(id)sender {

    if (! [_tf_newPS.text isEqualToString:_tf_surePS.text ]) {
       
        [self.view makeToast:@"2次输入的密码不匹配" duration:2 position:@"center"];

    }else{
        NSLog(@"重置成功了");
        [self RetetPasswordPostRequest];
     }

}


#pragma mark - PPNetworkHelper注册网络请求
-(void)RetetPasswordPostRequest
{
    
    NSDate *date = [NSDate date];
    NSString *DateTime =  [dateTimeHelper htcTimeToLocationStr: date];
    
    //通用MD5_KEY
    NSString * transactionTime = DateTime;//当前时间
    NSString * transactionId = DateTime; //每个用户唯一
    NSLog(@"%@",DateTime);
    NSString * tempStr;

    NSString * jsonStr = [NSString convertToJsonData:@{
                                                           @"mobilePhone":_phoneNum,
                                                           @"newPassword":_tf_surePS.text,
                                                           @"smsCheckCode":_Vercode,
                                                           }];
    NSString * data = [NSString base64:jsonStr];
    NSDictionary * params2 = @{
                               //@"userId":@"",
                               @"signType":@"MD5",
                               @"transactionTime":transactionTime,
                               @"transactionId":transactionId,
                               @"svcName":@"forgetPassword",
                               @"data":data,
                               };
    
    ZFEncryptionKey  * keydic = [ZFEncryptionKey new];
    NSString * sign = [keydic signStringWithParam:params2];
    
    NSDictionary * parma = @{
                             @"data":data,//base64
                             @"sign":sign,//签名
                             @"transactionTime":transactionTime,
                             @"transactionId":transactionId,
                             @"signType":@"MD5",
                             @"svcName":@"forgetPassword",
                             @"mobilePhone":_phoneNum,
                             @"newPassword":_tf_surePS.text,
                             @"smsCheckCode":_Vercode,
                             
                             };
    
    [SVProgressHUD  showSuccessWithStatus:@"修改成功"];

    [PPNetworkHelper POST:ZFB_11SendMessageUrl parameters:parma success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"responseObject"] isEqualToString:@"0" ]) {
            
            [SVProgressHUD  showInfoWithStatus:@"修改成功~"];
            [SVProgressHUD dismissWithCompletion:^{
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                
            }];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
