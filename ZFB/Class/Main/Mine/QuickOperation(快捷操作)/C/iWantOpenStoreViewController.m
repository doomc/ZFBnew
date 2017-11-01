//
//  iWantOpenStoreViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/11/1.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "iWantOpenStoreViewController.h"

@interface iWantOpenStoreViewController ()<UITextFieldDelegate>
{
    NSString * _phoneNum;
    NSString * _verCodeNum;
    NSString * _emailNum;
    
}
@end

@implementation iWantOpenStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我要开店";
    
    [self initView];
}
-(void)initView{
    //手机号
    self.tf_phoneNum.layer.masksToBounds = YES;
    self.tf_phoneNum.layer.cornerRadius = 4;
    self.tf_phoneNum.layer.borderWidth = 1;
    self.tf_phoneNum.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_phoneNum.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_phoneNum.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_phoneNum addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    //验证码
    self.verCode_btn.layer.masksToBounds = YES;
    self.verCode_btn.layer.cornerRadius = 4;
    
    self.tf_VerCode.layer.masksToBounds = YES;
    self.tf_VerCode.layer.cornerRadius = 4;
    self.tf_VerCode.layer.borderWidth = 1;
    self.tf_VerCode.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_VerCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_VerCode.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_VerCode addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    //电子邮箱
    self.tf_email.layer.masksToBounds = YES;
    self.tf_email.layer.cornerRadius = 4;
    self.tf_email.layer.borderWidth = 1;
    self.tf_email.layer.borderColor = HEXCOLOR(0x8d8d8d).CGColor;
    self.tf_email.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    [self.tf_email addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];

    self.NextPage_btn.layer.masksToBounds = YES;
    self.NextPage_btn.layer.cornerRadius = 4;
    
}


#pragma mark - 获取验证码
- (IBAction)getVerCodeAction:(id)sender {
    
}

#pragma mark - 下一步
- (IBAction)openStoreNextPage:(id)sender {

}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"编辑完了");
}
-(void)textfieldChange:(UITextField *)textField
{
    if (self.tf_phoneNum == textField) {
        _phoneNum = textField.text;

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
