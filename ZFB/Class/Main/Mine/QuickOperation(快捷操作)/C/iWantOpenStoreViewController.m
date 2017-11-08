//
//  iWantOpenStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "iWantOpenStoreViewController.h"
#import "iOpenStoreViewController.h"
#import "ProvinceVC.h"

@interface iWantOpenStoreViewController ()<UITextFieldDelegate>
{
    NSString * _verCodeNum;
    NSString * _emailNum;
    NSString * _smsCode;
    NSString * _detailAddress;
    NSString * _areaId;
    NSString * _address;
}


@end

@implementation iWantOpenStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我要开店";
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self initView];
    
}
-(void)initView{
    //手机号
    self.tf_phoneNum.layer.masksToBounds = YES;
    self.tf_phoneNum.layer.cornerRadius = 4;
    self.tf_phoneNum.delegate = self;
    self.tf_phoneNum.layer.borderWidth = 1;
    self.tf_phoneNum.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_phoneNum.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_phoneNum.leftViewMode = UITextFieldViewModeAlways;
    self.tf_phoneNum.text = BBUserDefault.userPhoneNumber;
    self.tf_phoneNum.userInteractionEnabled = NO;
    [self.tf_phoneNum addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    //验证码
    self.verCode_btn.layer.masksToBounds = YES;
    self.verCode_btn.layer.cornerRadius = 4;
    
    self.tf_VerCode.layer.masksToBounds = YES;
    self.tf_VerCode.layer.cornerRadius = 4;
    self.tf_VerCode.delegate = self;
    self.tf_VerCode.layer.borderWidth = 1;
    self.tf_VerCode.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_VerCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_VerCode.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_VerCode addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //电子邮箱
    self.tf_email.layer.masksToBounds = YES;
    self.tf_email.layer.cornerRadius = 4;
    self.tf_email.layer.borderWidth = 1;
    self.tf_email.delegate = self;
    self.tf_email.layer.borderColor = HEXCOLOR(0xbbbbbb).CGColor;
    self.tf_email.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_email addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];

    self.NextPage_btn.layer.masksToBounds = YES;
    self.NextPage_btn.layer.cornerRadius = 4;
    
    //详情地址
    self.tf_address.layer.masksToBounds = YES;
    self.tf_address.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_address.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_address addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - 获取验证码
- (IBAction)getVerCodeAction:(UIButton *)sender {
        // 网络请求
        [self ValidateCodePostRequset];
        
        [dateTimeHelper verificationCode:^{
            //倒计时完毕
            sender.enabled = YES;
            [sender setTitle:@"重新发送" forState:UIControlStateNormal];
            
        } blockNo:^(id time) {
            sender.enabled = NO;
            [sender setTitle:time forState:UIControlStateNormal];

    }];
 
}
//选择地址
- (IBAction)selectedAreaAddress:(id)sender {

    ProvinceVC * vc = [ ProvinceVC new];
    vc.addressBlock = ^(NSString *areaId, NSString *address) {
        NSLog(@"第一级：%@,%@",areaId,address);
        [self.address_btn setTitle:address forState:UIControlStateNormal];
        _areaId = areaId;
        _address = address;
    };
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - 下一步
- (IBAction)openStoreNextPage:(id)sender {
 
    if ([_smsCode isEqualToString:_verCodeNum] && [_emailNum isEmailAddress] == YES ) {
//        iWantOpenStoreViewController * openVC = [iWantOpenStoreViewController new];
//        openVC.phoneNum = BBUserDefault.userPhoneNumber;
//        openVC.email = _emailNum;
//        openVC.verCode = _smsCode;
//        openVC.areaId = _areaId;
//        [self.navigationController pushViewController:openVC animated:NO];
        
    }else
    {
        if ([_emailNum isEmailAddress] == NO) {
            [self.view makeToast:@"请填写正确的邮箱" duration:2 position:@"center"];
            
        }
        else if (![_smsCode isEqualToString:_verCodeNum] ) {
            [self.view makeToast:@"验证码有误" duration:2 position:@"center"];
        }
        else if (_address == nil || [_address isEqualToString:@""])
        {
            [self.view makeToast:@"请选择所在区域" duration:2 position:@"center"];
        }
        else
        {
            [self.view makeToast:@"验证码有误" duration:2 position:@"center"];
        }
    }
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"编辑完了");
    [textField resignFirstResponder];
}
-(void)textfieldChange:(UITextField *)textField
{
    if (self.tf_phoneNum == textField) {
 
         NSLog(@"手机号%@",textField.text);
    }
    if (self.tf_VerCode == textField) {
        _verCodeNum = textField.text;

        NSLog(@"验证码：%@",textField.text);
    }
    if (self.tf_email == textField) {
        _emailNum = textField.text;
        NSLog(@"email：%@",textField.text);
    }
    if (self.tf_address == textField) {
        
        _detailAddress = textField.text;
        NSLog(@"详情地址：%@",textField.text);

    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 验证码网络请求 SmsLogo 1 注册为配送  2注册商户
-(void)ValidateCodePostRequset
{
    [SVProgressHUD show];
    NSDictionary * parma = @{
                             @"SmsLogo":@"2",
                             @"mobilePhone":BBUserDefault.userPhoneNumber,
                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/SendMessages",zfb_baseUrl] params:parma success:^(id response) {
        
        NSString * code  = [NSString stringWithFormat:@"%@",response[@"resultCode"]];
        if ([code isEqualToString:@"0"]) {
            _smsCode = response[@"smsCode" ];
         }
        [self.view makeToast:response[@"resultMsg"]  duration:2 position:@"center"];
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
    }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self settingNavBarBgName:@"nav64_gray"];
 
    
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
