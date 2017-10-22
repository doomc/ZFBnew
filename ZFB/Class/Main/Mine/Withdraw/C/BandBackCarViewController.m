
//
//  BandBackCarViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/20.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  绑定银行卡

#import "BandBackCarViewController.h"

@interface BandBackCarViewController ()


@property (nonatomic ,strong) UITableView * tableView;

@end

@implementation BandBackCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
 
}

#pragma mark - 提现接口
-(void)withDrawkCashPost
{
    NSDictionary * param = @{
                             @"account":BBUserDefault.userPhoneNumber,
                             @"bankId":@"",//绑卡后银行卡编号
                             @"amount":@"12",//银行卡号
                             @"logoUrl":@"",//银行卡绑定电话
                             @"objectName":@"",//银行卡持有人姓名

                             };
    [MENetWorkManager post:[NSString stringWithFormat:@"%@/QRCode/withdrawCash",zfb_baseUrl] params:param success:^(id response) {
        
        
    } progress:^(NSProgress *progeress) {
        
    } failure:^(NSError *error) {
        
    }];
    
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
