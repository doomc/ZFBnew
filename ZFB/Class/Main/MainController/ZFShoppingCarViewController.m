//
//  ZFShoppingCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  ****购物车


#import "ZFShoppingCarViewController.h"
#import "LoginViewController.h"

@interface ZFShoppingCarViewController ()

@end

@implementation ZFShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =  randomColor;
    
    
    UIButton * login =[UIButton buttonWithType:UIButtonTypeSystem];
    [login  setTitle:@"马上去登录" forState:UIControlStateNormal];
    login.frame =CGRectMake(100, 100, 100, 100);
    [self.view addSubview:login];
    
    [login addTarget:self action:@selector(login_action) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)login_action
{
    LoginViewController * logvc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:logvc animated:YES];
    
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
