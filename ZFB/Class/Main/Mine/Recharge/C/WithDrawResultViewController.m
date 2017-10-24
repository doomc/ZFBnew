//
//  WithDrawResultViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/10/22.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "WithDrawResultViewController.h"

@interface WithDrawResultViewController ()
//银行卡信息
@property (weak, nonatomic) IBOutlet UILabel *lb_BankCardInfo;
@property (weak, nonatomic) IBOutlet UILabel *lb_WithDrawAmount;//提现金额

@end

@implementation WithDrawResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认提现";
    
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
