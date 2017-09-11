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

@interface PayPassWordSettingViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
    NSArray  * titles;
}
@property (nonatomic , strong) UITableView  * tableView;

@end

@implementation PayPassWordSettingViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,KScreenW , KScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"支付设置";
    titles = @[@"设置支付密码",@"修改密码",@"找回密码"];
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [ self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = titles[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        SettingPayPasswordViewController * vc = [SettingPayPasswordViewController new];
        [self.navigationController pushViewController:vc animated:NO];
    
    }else if (indexPath.row == 1)
    {

    }
    else{
        
        FindPayPassWordViewController * findVC= [ FindPayPassWordViewController new];
        [self.navigationController pushViewController:findVC animated:NO];
        
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
