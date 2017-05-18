//
//  ZFSearchBarViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/5/18.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFSearchBarViewController.h"
#import "ZFSearchDetailViewController.h"
 
@interface ZFSearchBarViewController ()

@end

@implementation ZFSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    
//    BaseNavigationController *nav =[[ BaseNavigationController alloc]initWithRootViewController:zfSearchVC];
//    
     UIButton* navSearch_btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [navSearch_btn setBackgroundImage:[UIImage imageNamed:@"searchBar"] forState:UIControlStateNormal];
    [navSearch_btn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    navSearch_btn.frame = CGRectMake(0, 100, KScreenW - 60, 30);
    [self.view addSubview:navSearch_btn];
    
    
    UIButton* navSearch_btn2  =[UIButton buttonWithType:UIButtonTypeCustom];
    [navSearch_btn2 setBackgroundImage:[UIImage imageNamed:@"searchBar"] forState:UIControlStateNormal];
    [navSearch_btn2 addTarget:self action:@selector(cancel2:) forControlEvents:UIControlEventTouchUpInside];
    navSearch_btn2.frame = CGRectMake(0, 200, KScreenW - 60, 30);
    [self.view addSubview:navSearch_btn2];
 
}


-(void)cancel2:(UIButton*)sender{
    
    ZFSearchBarViewController * zfSearchVC= [ZFSearchBarViewController new];
    [self.navigationController pushViewController:zfSearchVC animated:YES];
    
}
-(void)cancel:(UIButton*)sender{
    NSLog(@"%@",sender);
    [self dismissViewControllerAnimated:YES completion:^{
        
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
