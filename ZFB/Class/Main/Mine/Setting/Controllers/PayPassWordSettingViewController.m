//
//  PayPassWordSettingViewController.m
//  ZFB
//
//  Created by 熊维东 on 2017/9/11.
//  Copyright © 2017年 com.zfb. All rights reserved.
//

#import "PayPassWordSettingViewController.h"
#import "SettingPayPasswordViewController.h"
#import "FindPayPassWordViewController.h"
#import "ChangePasswordViewController.h"
@interface PayPassWordSettingViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic , strong) UITableView  * tableView;

@end

@implementation PayPassWordSettingViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,KScreenW , KScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"支付设置";
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [ self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
 
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = HEXCOLOR(0x363636);
    
    if ([BBUserDefault.isSetPassword isEqualToString:@"1"]) {
        if (indexPath.row == 0) {
            cell.textLabel.text =  @"修改支付密码";
        }else{
            cell.textLabel.text =  @"找回支付密码";

        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text =  @"设置支付密码";
        }else{
            cell.textLabel.text =  @"找回支付密码";
            
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BBUserDefault.isSetPassword isEqualToString:@"1"]) {
        if (indexPath.row == 0) {
            //修改支付密码
            ChangePasswordViewController * changevc = [ChangePasswordViewController new];
            [self.navigationController pushViewController:changevc animated:NO];
            
        }else
        {
            //找回密码
            FindPayPassWordViewController * findVC = [FindPayPassWordViewController new];
            [self.navigationController pushViewController:findVC animated:NO];
        }

    }else{
        
        if (indexPath.row == 0) {
            //设置支付密码
            SettingPayPasswordViewController * vc = [SettingPayPasswordViewController new];
            [self.navigationController pushViewController:vc animated:NO];

        }else
        {
            //找回密码
            FindPayPassWordViewController * findVC = [FindPayPassWordViewController new];
            [self.navigationController pushViewController:findVC animated:NO];
        }
 
    }
    
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
