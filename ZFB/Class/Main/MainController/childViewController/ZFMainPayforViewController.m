//
//  ZFMainPayforViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/5/23.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  支付页面

#import "ZFMainPayforViewController.h"
#import "PayforCell.h"
@interface ZFMainPayforViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)NSArray * dataArr ;
@property(nonatomic ,strong)UITableView * pay_tableView ;
@property(nonatomic ,strong)UIView * footerView;
@property(nonatomic ,strong)UIButton * sure_payfor;//确认支付

@end

@implementation ZFMainPayforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收银台";

    self.dataArr = @[@"选择支付方式",@"余额   350.00元",@"快捷支付",@"微信",@"支付宝",@"实付金额"];
    [self.pay_tableView registerNib:[UINib nibWithNibName:@"PayforCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.pay_tableView];

}
-(UITableView *)pay_tableView
{
    if (!_pay_tableView) {
        _pay_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
        _pay_tableView.delegate =self;
        _pay_tableView.dataSource= self;
     }
    
    return _pay_tableView;
}
-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 100)];
        _sure_payfor = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sure_payfor setTitle:@"确认支付" forState:UIControlStateNormal];
        [_sure_payfor setBackgroundColor:HEXCOLOR(0xfe6d6a)];
        _sure_payfor.titleLabel.font =[UIFont systemFontOfSize:15];
        _sure_payfor.frame = CGRectMake(30, 50, KScreenW-60, 40);
        _sure_payfor.layer.cornerRadius = 4;
        [_sure_payfor addTarget:self action:@selector(didClickPayFor:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_sure_payfor];
    }
   return  _footerView;
}

-(void)didClickPayFor:(UIButton *)sender
{
    NSLog(@"确认支付");
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _dataArr.count;

    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return  self.footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayforCell * cell = [self.pay_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.lb_title.text = _dataArr[indexPath.row];
    
    if (indexPath.row ==5) {
        cell.btn_selected.hidden = YES;
        cell.lb_Price.hidden = NO;
        
    }
    return cell;
}




@end
