//
//  ForgetPSViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ForgetPSViewController.h"
#import "ZYFVerificationCodeViewController.h"
@interface ForgetPSViewController ()

@end

@implementation ForgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
  点击下一步验证
 @param sender <#sender description#>
 */
- (IBAction)goto_NextPage:(id)sender {
    
    ZYFVerificationCodeViewController * verificationVC = [[ZYFVerificationCodeViewController alloc]init];
    [self.navigationController pushViewController:verificationVC animated:YES];
    
    
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
