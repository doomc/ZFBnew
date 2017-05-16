//
//  ForgetPSViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/12.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ForgetPSViewController.h"
#import "ResetPassWViewController.h"

@interface ForgetPSViewController ()

@end

@implementation ForgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
   下一步

 @param sender 重置密码下一步
 */
- (IBAction)goToResetPageView:(id)sender {
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
