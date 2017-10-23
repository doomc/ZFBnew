//
//  MineWalletViewController.m
//  ZFB
//
//  Created by  展富宝  on 2017/8/28.
//  Copyright © 2017年 com.zfb. All rights reserved.
//  我的钱包

#import "MineWalletViewController.h"
#import "ZFCashCell.h"

@interface MineWalletViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * titleArray;

@end

@implementation MineWalletViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";
    _titleArray = @[@"账户余额",@"提成金额",@"优惠券",@"富豆"];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZFCashCell" bundle:nil] forCellReuseIdentifier:@"ZFCashCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZFCashCell * cashCell = [self.tableView dequeueReusableCellWithIdentifier:@"ZFCashCell" forIndexPath:indexPath];
    cashCell.lb_title.text = _titleArray[indexPath.row];
    return cashCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
