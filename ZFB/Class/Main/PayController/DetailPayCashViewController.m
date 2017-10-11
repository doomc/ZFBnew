//
//  DetailPayCashViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/24.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "DetailPayCashViewController.h"

@interface DetailPayCashViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UIButton *btn_Remake;
@property (weak, nonatomic) IBOutlet UIButton *btn_forgetOfPS;
@property (weak, nonatomic) IBOutlet UIImageView *img_Status;

@end

@implementation DetailPayCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收银台";

    self.btn_Remake.layer.masksToBounds = YES;
    self.btn_Remake.layer.cornerRadius = 4;
    
    self.btn_forgetOfPS.layer.masksToBounds = YES;
    self.btn_forgetOfPS.layer.cornerRadius = 4;
}
//重新输入
- (IBAction)didClickReputin:(id)sender {
    
}

//忘记密码
- (IBAction)didClickforgetPass:(id)sender {
    
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
