//
//  ZFFeedbackViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/6/8.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFFeedbackViewController.h"
#import "ZFCommitOpinionViewController.h"
#import "ZFMyOpinionViewController.h"

@interface ZFFeedbackViewController ()

@end

@implementation ZFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = YES;

    [self initWithControllers];
    
}
-(void)initWithControllers
{
    ZFCommitOpinionViewController *commitOpinionVC = [[ZFCommitOpinionViewController alloc]init];
    commitOpinionVC.title = @"提交意见";
    ZFMyOpinionViewController *myOpinionVC = [[ZFMyOpinionViewController alloc]init];
    myOpinionVC.title = @"我的意见";
    
    NSArray *subViewControllers = @[commitOpinionVC,myOpinionVC];
    
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0,64, KScreenW, KScreenH - 64);
    [self.view addSubview:tabBarVC.view];
    [self addChildViewController:tabBarVC];
    
    
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
