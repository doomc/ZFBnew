//
//  LoginViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPSViewController.h"
#import "ZFPersonalViewController.h"
#import "NSString+ZFSortAppdending.h"
#import "NSString+JsonChange.h"

const NSString * MD5_key = @"1233@sdf%22dscE3";//全局

typedef NS_ENUM(NSUInteger, indexType) {
    quickLoginIndexType = 0,//快捷登录
    passwordLoginIndexType,//密码登录
    
};
@interface LoginViewController ()<UITextFieldDelegate>
{
    
    //    BOOL _isQuickLogin;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl * loginSegment;
//手机号
@property (weak, nonatomic) IBOutlet UITextField * tf_loginphone;
//验证码 或者 密码
@property (weak, nonatomic) IBOutlet UITextField *tf_verificationCodeOrPassWord;
@property (weak, nonatomic) IBOutlet UIImageView *img_iconOfVerificationOrPs;
@property (weak, nonatomic) IBOutlet UIButton *login_btn;

@property (assign,nonatomic) indexType  indexType;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self initSegmentInterfaceAndTextfiled];
    [self textFieldSettingDelegate];
    
    
}


/**
 初始化segement
 */
-(void)initSegmentInterfaceAndTextfiled
{
    
    self.navigationItem.title = @"登录展富宝";
    self.loginSegment.selectedSegmentIndex = 0;
    [self.loginSegment addTarget:self action:@selector(LoginSegmentchange:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x363636),NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:15],NSFontAttributeName ,nil];
    _loginSegment.layer.masksToBounds = YES;
    _loginSegment.layer.borderWidth =1.0;
    _loginSegment.layer.borderColor = [UIColor whiteColor].CGColor;
    [_loginSegment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    [_login_btn addTarget:self action:@selector(login_Success:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



#pragma mark - UITextFieldDelegate  设置代理
-(void)textFieldSettingDelegate
{
    self.tf_loginphone.delegate  = self;
    self.tf_verificationCodeOrPassWord.delegate = self;
    
    [self.tf_loginphone addTarget:self action:@selector(textChange :) forControlEvents:UIControlEventEditingChanged];
    [self.tf_verificationCodeOrPassWord addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
}

//当文本内容改变时调用
- (void)textChange :(UITextField *)textfiled
{
    textfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    if (_loginSegment.selectedSegmentIndex == 0) {
        
        if (textfiled == _tf_verificationCodeOrPassWord) {
            
            //当账号与密码同时有值,登录按钮才能够点击
            if ( _tf_loginphone.text.length == 11 && _tf_verificationCodeOrPassWord.text.length == 6) {
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
        }
        NSLog(@"%@ ",_tf_loginphone.text );
        
        
    }
    if (_loginSegment.selectedSegmentIndex == 1) {
        _tf_verificationCodeOrPassWord.secureTextEntry = YES;
        
        if (_tf_verificationCodeOrPassWord == textfiled) {
            
            //当账号与密码同时有值,登录按钮才能够点击
            if ( _tf_loginphone.text.length == 11 && _tf_verificationCodeOrPassWord.text.length >7) {
                self.login_btn.backgroundColor = HEXCOLOR(0xfe6d6a);
                
            }else{
                self.login_btn.backgroundColor = HEXCOLOR(0xa7a7a7);
                
            }
            
            NSLog(@"登录--账号+密码 = %@",_tf_verificationCodeOrPassWord.text);
        }
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (_loginSegment.selectedSegmentIndex == 0  ) {
        
        if (_tf_loginphone == textField) {
            //判断是不是手机号
            if ( [_tf_loginphone.text isMobileNumber]) {
                
                [self requsetWithValidateCode];
                
                NSLog(@"自动请求发送验证码");
                
            }else{
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];
                
            }
        }
        if (_tf_verificationCodeOrPassWord == textField) {
            
            
            NSLog(@"快捷登录--验证码2  = %@",_tf_verificationCodeOrPassWord.text);
            
        }
        
    }else if (_loginSegment.selectedSegmentIndex == 1){
        
        
        if (_tf_loginphone == textField) {
            //判断是不是手机号
            if ( [_tf_loginphone.text isMobileNumber]) {
                
                NSLog(@"自动请求发送验证码");
                
            }else{
                [self.view makeToast:@"你输入的手机格式错误" duration:2.0 position:@"center"];
                
            }
        }
        if (_tf_verificationCodeOrPassWord == textField) {
            
            NSLog(@"登录--账号+密码2 %@",textField );
            
        }
    }
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    
    return YES;
}
//回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf_loginphone resignFirstResponder];
    [_tf_verificationCodeOrPassWord resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
/**
 快速登录
 
 @param segment  分段控制器
 */
-(void)LoginSegmentchange:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        
        NSLog(@"快捷登录");
        _tf_verificationCodeOrPassWord.placeholder = @"请输入短信验证码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"message"];
        
        
    }
    else{
        NSLog(@"密码登录");
        _tf_verificationCodeOrPassWord.placeholder = @"请输入登录密码";
        _img_iconOfVerificationOrPs.image = [UIImage imageNamed:@"passWord"];
        
    }
}



/**
 登录
 
 @param sender 点击登录
 */
- (void)login_Success:(UIButton *)sender {
#warning -----  不走 poptoView 方法为什么？
    
    //方法一
    //  [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    //方法2：
    // [self  popToViewControllerWithName:@"ZFPersonalViewController"];
    
    //    for (UIViewController *controller in self.navigationController.viewControllers) {
    //
    //        if ([controller isKindOfClass:[ZFPersonalViewController class]]) {
    //
    //            [self.navigationController popToViewController:controller animated:YES];
    //
    //        }
    //
    //    }
    
    NSLog(@"登录成功");
    
}



/**
 忘记密码
 
 @param sender push到忘记密码页面
 */
- (IBAction)forgot_PassWord:(id)sender {
    
    
    ForgetPSViewController * forgetVC =[[ForgetPSViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    
}

/**
 去注册
 
 @param sender push到注册页面
 */
- (IBAction)goto_Regist:(id)sender {
    
    RegisterViewController * regVC =[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
    
}


/**
 验证码网络请求
 */
-(void)requsetWithValidateCode
{
    
    NSString * phoneNumber = _tf_loginphone.text;
    NSString * SmsLogo = @"1";
   

    NSDate *date = [NSDate date];
    NSString *DateTime =  [dateTimeHelper htcTimeToLocationStr: date];
    
    //通用MD5_KEY
 
  
 

    NSString * transactionTime = DateTime;//当前时间
    NSString * transactionId = DateTime; //每个用户唯一
    NSLog(@"%@",DateTime);
    NSString * jsonStr = [phoneNumber convertToJsonData:@{
                                                          @"mobilePhone":phoneNumber,
                                                          @"SmsLogo":SmsLogo,
                                                          }];
    
    NSString * data = [NSString base64:jsonStr];
    
    NSLog(@" base64 = %@ ",data);
    
    NSDictionary * params2 = [NSDictionary dictionary];
 
    params2 = @{
//                @"userId":@"",
                @"signType":@"MD5",
                @"transactionTime":transactionTime,
                @"transactionId":transactionId,
                @"svcName":@"SendMessages",
                @"data":data,
               };

    
    NSArray *keyArray = [params2 allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         return [obj1 compare:obj2 options:NSNumericSearch];
     }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[params2 objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString * signStr =[NSString stringWithFormat:@"%@|%@",[signArray componentsJoinedByString:@"|"],MD5_key];
    NSLog(@"signStr = %@",signStr);
 
    
    NSString * sign =  [MD5Tool MD5ForLower32Bate:signStr];
    NSDictionary * param   = [NSDictionary dictionary];
                param = @{
               
                            @"data":data,//base64
                            @"sign":sign,//签名
                            @"transactionTime":transactionTime,
                            @"transactionId":transactionId,
                            @"signType":@"MD5",
                            @"svcName":@"SendMessages",
                             };

    
    [PPNetworkHelper POST:ZFB_22SendMessageUrl parameters:param responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSLog(@"%@  = responseObject  \n  %@ = param " ,responseObject,param);

    } failure:^(NSError *error) {
        NSLog(@"%@  = error " ,error);

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
