//
//  RechargeViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/10/17.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  充值

#import "RechargeViewController.h"
#import "AddBankCardViewController.h"//添加银行卡

#import "BackCell.h"
#import "WithdrawCell.h"
#import "AddBackButtonCell.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,WithdrawCellDelegate,AddBackButtonCellDelegate>

@property (nonatomic , strong) UITableView * backTableView;


@end

@implementation RechargeViewController


-(UITableView *)backTableView
{
    if (!_backTableView) {
        _backTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return  _backTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    [self.view addSubview: self.backTableView];
    
    [self.backTableView registerNib:[UINib nibWithNibName:@"BackCell" bundle:nil] forCellReuseIdentifier:@"BackCell"];
    [self.backTableView registerNib:[UINib nibWithNibName:@"AddBackButtonCell" bundle:nil] forCellReuseIdentifier:@"AddBackButtonCell"];
    [self.backTableView registerNib:[UINib nibWithNibName:@"WithdrawCell" bundle:nil] forCellReuseIdentifier:@"WithdrawCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 65;
    
    }else if (indexPath.section == 1)
    {
        height = 130;
    }else{
        height = 125;
 
    }
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 10)];
        view.backgroundColor = HEXCOLOR(0xf7f7f7);
        
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BackCell * cell = [self.backTableView dequeueReusableCellWithIdentifier:@"BackCell" forIndexPath:indexPath];
        return cell;
    }
   else if (indexPath.section == 1) {
        WithdrawCell  * drawCell = [self.backTableView dequeueReusableCellWithIdentifier:@"WithdrawCell" forIndexPath:indexPath];
       drawCell.delegate = self;
       return drawCell;
    }
    else{
        AddBackButtonCell * cell = [self.backTableView dequeueReusableCellWithIdentifier:@"AddBackButtonCell" forIndexPath:indexPath];
        cell.deldegate = self;
        return cell;

    }
 }

 
#pragma mark - AddBackButtonCellDelegate 添加银行卡代理
//添加银行卡
-(void)didClickAddBankCard
{
    NSLog(@"点击了  ---- 添加银行卡");
    AddBankCardViewController * addVC = [AddBankCardViewController new];
    [self.navigationController pushViewController:addVC animated:NO];
    
}
//确认提现
-(void)didClickcashWithdraw
{
    NSLog(@"点击了  ---- 确认提现");

}

#pragma mark - WithdrawCellDelegate 提现代理
//全部提现
-(void)didClickAllWithDraw
{
    NSLog(@"全部提现  ---- 显示金额");
}
//输入的金额
-(void)inputTextfiledText:(NSString *)resulet
{
    NSLog(@" 外部获取到的 ---%@",resulet);
}


-(void)viewWillAppear:(BOOL)animated{
    
 
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
