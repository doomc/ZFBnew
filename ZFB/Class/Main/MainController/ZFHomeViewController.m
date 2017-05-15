//
//  ZFHomeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****新零售

#import "ZFHomeViewController.h"
#import "FinGoodsViewController.h"
#import "FindStoreViewController.h"
#import "FindCircleViewController.h"
#import "DCNavTabBarController.h"
@interface ZFHomeViewController ()
@end

@implementation ZFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
//    self.automaticallyAdjustsScrollViewInsets = NO;//(0,0)
//    self.navigationController.navigationBar.translucent = NO;
     self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xffcccc);
    
    [self initMainController];
}
-(void)initMainController
{
    FindStoreViewController *findStoreVC = [[FindStoreViewController alloc]init];
    findStoreVC.title = @"找 店";
    FinGoodsViewController *findGoodsVC = [[FinGoodsViewController alloc]init];
    findGoodsVC.title = @"找商品";
    FindCircleViewController *findCircleVC = [[FindCircleViewController alloc]init];
    findCircleVC.title = @"找圈子";
    
    NSArray *subViewControllers = @[findStoreVC,findGoodsVC,findCircleVC];
    
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    tabBarVC.view.frame = CGRectMake(0, 64, KScreenW, KScreenH - 64);
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
