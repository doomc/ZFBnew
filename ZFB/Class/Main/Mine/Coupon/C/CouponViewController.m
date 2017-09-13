//
//  CouponViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/9/13.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "CouponViewController.h"
#import "SGPagingView.h"//控制自控制器
#import "MTSegmentedControl.h"

@interface CouponViewController ()<MTSegmentedControlDelegate>

@property (strong, nonatomic)  MTSegmentedControl *segumentView;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优惠券";
    
    [self setupPageView];

    
}
- (void)setupPageView {
    
    NSArray *titleArr = @[@"未使用(0)", @"已使用(0)", @"已过期(0)"];
    
    _segumentView = [[MTSegmentedControl alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 44)];
    [self.segumentView segmentedControl:titleArr Delegate:self];
    [self.view addSubview:_segumentView];
 


 

}

- (void)segumentSelectionChange:(NSInteger)selection
{
    NSLog(@" ===%ld === ",selection);

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
