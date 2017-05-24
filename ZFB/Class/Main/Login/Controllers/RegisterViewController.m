//
//  RegisterViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZYFVerificationCodeViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextTarget_btn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.nextTarget_btn addTarget:self action:@selector(goToRegisterAcount:) forControlEvents:UIControlEventTouchUpInside];
}


/**
   注册 下一步
 @param sender 立即去注册
 */
- (void)goToRegisterAcount:(UIButton *)sender {
    
    ZYFVerificationCodeViewController * verificationVC = [[ZYFVerificationCodeViewController alloc]init];
    [self.navigationController pushViewController:verificationVC animated:YES];
    
    
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
    if (sender.selected) {
        
        
    }else{
        sender.selected=NO;
        
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
