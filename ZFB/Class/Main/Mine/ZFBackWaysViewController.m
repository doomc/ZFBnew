//
//  ZFBackWaysViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/27.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "ZFBackWaysViewController.h"

@interface ZFBackWaysViewController ()

@end

@implementation ZFBackWaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"商品退回方式";
}


#pragma mark - 服务名称 -----提交售后申请 zfb/InterfaceServlet/afterSale/afterSaleApply
-(void)commitPostRequset
{
    NSDictionary * param = @{
 
                             @"cmUserId":BBUserDefault.cmUserId,
                             @"orderNum":_orderNum,
                             
                             };
    
    [SVProgressHUD show];
    
    [MENetWorkManager post:[zfb_baseUrl stringByAppendingString:@"/order/afterSaleApply"] params:param success:^(id response) {
        
        [SVProgressHUD dismiss];
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        NSLog(@"error=====%@",error);
        [self.view makeToast:@"网络错误" duration:2 position:@"center"];
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
