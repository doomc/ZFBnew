//
//  DetailPaySuccessViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailPaySuccessViewController.h"
#import "ZFAllOrderViewController.h"

@interface DetailPaySuccessViewController ()

@end

@implementation DetailPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收银台";
}

//返回跳转到全部订单
-(void)backAction
{
    ZFAllOrderViewController * allVC = [ ZFAllOrderViewController new];
    allVC.buttonTitle = @"全部订单";
    [self.navigationController pushViewController:allVC animated:NO];
    
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
